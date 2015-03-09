//
//  CShop.swift
//  kusogee
//
//  Created by Tinyan on 1/22/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

import StoreKit


public class CCommonShop : CCommonGeneral , SKProductsRequestDelegate , SKPaymentTransactionObserver
{
	
	let SHOP_GETPRICE_MODE = 1
	let SHOP_MAIN_MODE = 2
	let SHOP_CANNOT_MODE = 3
	
	var m_paymentMode = false
	var m_payment : SKPayment!
	var m_productID : String!
	
	var m_productIDList : [String] = ["com.bugnekosoft.productname.itemname"]
	var m_priceList : [String] = ["dummy"]
	var m_priceListGetFlag : [Bool] = [false]
	var m_priceGetError = false
	var m_processingFlag = false
	
	func checkInAppPurChuse() -> Bool
	{
		if !SKPaymentQueue.canMakePayments()
		{
			return false
		}
		
		return true
	}
	
	func getProductIDSet(objects:[AnyObject]) -> Set<NSObject>
	{
		return Set<NSObject>(arrayLiteral: objects)
//		return NSSet(array:objects)
	}
	
	
	
	func getPriceList(objects:[String])
	{
		var productID = getProductIDSet(objects)
		var request  = SKProductsRequest(productIdentifiers: productID)
		request.delegate = self
		request.start()
	}
	
	
//	func startPayment(object:AnyObject)
	func startPayment(object:String)
	{
		m_paymentMode = true
//		m_productID = object as! String
		m_productID = object
		
//		var productID = Set<NSObject>(arrayLiteral: [object])
		var productID = getProductIDSet([object])
//		var productID : NSSet  = NSSet(object:object)
		var request  = SKProductsRequest(productIdentifiers: productID)
		request.delegate = self
		startIndicator()
		request.start()
	}
	
	func startRestore(object:String)
	{
		m_paymentMode = false
//		m_productID = object as! String
		m_productID = object
		
		
//		var productID = Set<NSObject>(arrayLiteral: [object])
		var productID = getProductIDSet([object])
		
		//		var productID : NSSet  = NSSet(object:object)
		var request  = SKProductsRequest(productIdentifiers:  productID)
		request.delegate = self
		startIndicator()
		request.start()
	}
	
	//deletate
	public func productsRequest(request: SKProductsRequest!,  didReceiveResponse response: SKProductsResponse!)
	{
		if response == nil
		{
			//error
			stopIndicator()
			printNoResponseError()
			if m_shopMode == SHOP_GETPRICE_MODE
			{
				m_priceGetError = true
			}
			return
		}
		
		if (response.invalidProductIdentifiers.count > 0)
		{
			// productID error!
			stopIndicator()
			printProductIDError()
			if m_shopMode == SHOP_GETPRICE_MODE
			{
				m_priceGetError = true
			}
			return
		}
		
		if m_shopMode == SHOP_GETPRICE_MODE
		{
			//get local price sample
			for product in response.products
			{
				var formatter = NSNumberFormatter()
				formatter.formatterBehavior = .Behavior10_4
				formatter.numberStyle = .CurrencyStyle
				formatter.locale = product.priceLocale
				var str = formatter.stringFromNumber(product.price)
				var ids = (product as SKProduct).productIdentifier
				
				for i in 0 ..< m_productIDList.count
				{
					if m_productIDList[i] == ids
					{
						m_priceListGetFlag[i] = true
						m_priceList[i] = str!
					}
				}
			}
			stopIndicator()
			
			var flag = true
			for i in 0 ..< m_priceListGetFlag.count
			{
				if !m_priceListGetFlag[i]
				{
					flag = false
					break
				}
			}
			
			m_priceGetFlag = flag
			
			return
		}
		
		
		for product in response.products as! [SKProduct]
		{
			m_payment = SKPayment(product: product)
			SKPaymentQueue.defaultQueue().addTransactionObserver(self)
			
			
			if m_paymentMode
			{
				printDebugMessage("start payment")
				SKPaymentQueue.defaultQueue().addPayment(m_payment)
			}
			else
			{
				printDebugMessage("start restore")
				SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
			}
			break
		}
	}
	
	
	public func paymentQueue(queue: SKPaymentQueue!,	updatedTransactions transactions: [AnyObject]!)
	{
		for transaction in transactions as! [SKPaymentTransaction]
		{
			//let transaction = object as! SKPaymentTransaction
			var state = transaction.transactionState
			
			switch (state)
			{
			case SKPaymentTransactionState.Purchasing:
				printDebugMessage("Purchasing")
				break
				
			case SKPaymentTransactionState.Purchased:
				printDebugMessage("Purchased")
				purchaseProduct(m_productID)
				stopIndicator()
				printPurchaseOk()
				queue.finishTransaction(transaction)
				break
				
			case SKPaymentTransactionState.Failed:
				//	printFail()
				printDebugMessage("Failed")
				queue.finishTransaction(transaction)
				break
				
			case SKPaymentTransactionState.Restored:
				//
				printDebugMessage("Restored")
				restoreProduct(m_productID)
				queue.finishTransaction(transaction)
				break
				
			default:
				queue.finishTransaction(transaction)
			}
		}
	}
	
	public func paymentQueue(queue: SKPaymentQueue!,restoreCompletedTransactionsFailedWithError error: NSError!)
	{
		stopIndicator()
		//		println("restoreCompletedTransactionsFailedWithError")
	}
	
	public func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!)
	{
		//		println("paymentQueueRestoreCompletedTransactionsFinished")
		
		var restore = false
		
		for transaction in queue.transactions as! [SKPaymentTransaction]
		{
			if transaction.payment.productIdentifier == m_productID
			{
				printDebugMessage("found resotore")
				restoreProduct(m_productID)
				restore = true
				stopIndicator()
				printRestoreOk()
				break
			}
		}
		
		
		if !m_paymentMode
		{
			if !restore
			{
				printDebugMessage("cannot resotore because not buy")
				printCannotRestoreNotBuy()
			}
		}
		
		stopIndicator()
		
	}
	
	
	
	public func paymentQueue(queue: SKPaymentQueue!,	removedTransactions transactions: [AnyObject]!)
	{
		//		println("removedTransactions")
		stopIndicator()
		SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
	}
	
//	public var m_shopButtonFilename = "bmp/shopbutton.png"
//	public var m_shopButtonPicNumber = [1,2]
//	public var m_shopButtonSize = CGSize(width: 300, height: 150)
//	public var m_shopButtonPoint = CGPoint(x:150,y:75)
	
	
	public var m_indicatorCreateFlag = false
//	public var m_buttonPic = CCommonSpriteCutter(filename: "bmp/shopbutton.png", x: 1, y: 2)
//	public var m_shopButton : [CCommonButton] = []
	public var m_indicator : UIActivityIndicatorView!
	
	public var m_shopMode = 0
	public var m_shopButtonCreateFlag = false
	
	
	
	public var m_shopItemPic : CCommonSpriteCutter!
	public var m_alreadyBuyPic : SKTexture!
	public var m_itemButtonPic : CCommonSpriteCutter!
	
	public var m_alreadyBuySize = CGSize(width: 300, height: 300)
	
	public var m_itemSize = CGSize(width: 400, height: 400)
	public var m_itemPoint = CGPoint(x:225,y:1350)
	public var m_itemNext = CGVector(dx:0,dy:-500)
	public var m_itemHorizontally = true
	public var m_itemBlockX = 1
	public var m_itemBlockY = 1
	public var m_buyButtonOffset = CGVector(dx:450,dy:100)
	public var m_restoreButtonOffset = CGVector(dx:450,dy:-100)
	public var m_buyButtonSize = CGSize(width: 400, height: 100)
	public var m_restoreButtonSize = CGSize(width: 400, height: 100)
	
//	public var m_shopItemPic = CCommonSpriteCutter(filename: "bmp/shopitem.png", x: 2, y: 2)
//	public var m_alreadyBuyPic = SKTexture(imageNamed: "bmp/alreadybuy.png")
//	public var m_itemButtonPic = CCommonSpriteCutter(filename: "bmp/shopitembutton.png", x: 1, y: 2)
	
	
	public var m_itemButton : [CCommonButton] = []
	public var m_alreadyBuyTexture : [SKSpriteNode] = []
	
	public var m_priceGetFlag = false
	
	
	public var m_restoreText = "RESTORE"
	public var m_buyButtonFontName = "Helvetica-Bold"
	public var m_restoreButtonFontName = "Helvetica-Bold"
	public var m_buyButtonFontSize : CGFloat = 64.0
	public var m_restoreButtonFontSize : CGFloat = 64.0
	
	
	
	public var m_shopItemDesc : [String] = ["DESC1","DESC2..."]
	public var m_shopItemDescPoint = CGPoint(x:450,y:900)
	public var m_shopItemDescNext = CGVector(dx:0,dy:-150)
	public var m_shopItemDescFontFilename = "bmp/shopfont.png"
	public var m_shopItemDescFontSize = CGSize(width: 32, height: 32)
	
	//public var m_shopItemDescFilename : String = "text/shopitemdesc"
	
	public var m_shopItemDescMessage : [CCommonMessage64] = []

	
	
//	public var m_itemDescPrintX : CGFloat = 450.0
//	public var m_itemDescPrintY : CGFloat = 900.0
//	public var m_itemDescNextX : CGFloat = 0
//	public var m_itemDescNextY : CGFloat = -150.0

	
	public var m_backMode = -1
	public var m_backSound = -1
	public var m_buySound = -1
	public var m_restoreSound = -1
	
	convenience required public init(coder aDecoder: NSCoder)
	{
		self.init(coder:aDecoder)
	}
	
	override public init(modeNumber:Int , game : CCommonGame, size:CGSize)
	{
		super.init(modeNumber:modeNumber , game:game , size: size)
		
		if var json = CCommonJsonObject.loadByFilename("init/shop")
		{
			getCommonParam(json)

			m_commonMenu = CCommonMenu(general: self, json: json, menu: "menu")
			self.addChild(m_commonMenu)
			
			if var productList : [String] = json.getArrayObject(keyList: "productList")
			{
				m_productIDList = productList
				//var cnt = m_productIDList.count
				m_priceList  = []
				m_priceListGetFlag = []
				for i in 0 ..< m_productIDList.count
				{
					m_priceList.append("dummy")
					m_priceListGetFlag.append(false)
				}
			}

			var top = "common"
			if var dummy: AnyObject = json.getAnyObject(top)
			{
				var itemFilename = "bmp/shopitem.png"
				var block = [1,1]
				getInitParam(json, name: &itemFilename, keyList: top,"itemFilename")
				getInitArray(json,name:&block,keyList:top,"itemPicNumber")
				m_shopItemPic = CCommonSpriteCutter(filename: itemFilename, x: block[0], y: block[1])

				var alreadyBuyFilename = "bmp/alreadybuy.png"
				getInitParam(json,name: &alreadyBuyFilename,keyList:top,"alreadyBuyFilename")
				m_alreadyBuyPic = SKTexture(imageNamed: alreadyBuyFilename)
				
				getInitParam(json,name:&m_alreadyBuySize,keyList:top,"alreadyBuySize")
				
				var itemButtonFilename = "bmp/shopitembutton.png"
				getInitParam(json,name:&itemButtonFilename,keyList:top,"itemButtonFilename")

				block = [1,2]
				getInitArray(json, name: &block, keyList: top,"itemButtonPicNumber")
				m_itemButtonPic = CCommonSpriteCutter(filename: itemButtonFilename, x: block[0], y: block[1])

				getInitParam(json, name: &m_restoreText, keyList: top,"restoreText")
				
				getInitParam(json,name:&m_itemSize,keyList:top,"itemSize")
				getInitParam(json,name:&m_itemPoint,keyList:top,"itemPoint")
				getInitParam(json,name:&m_itemNext,keyList:top,"itemNext")
				
				getInitParam(json, name: &m_buyButtonOffset, keyList: top,"buyButtonOffset")
				getInitParam(json, name: &m_buyButtonSize, keyList: top,"buyButtonSize")
				getInitParam(json,name:&m_buyButtonFontName,keyList:top,"buyButtonFontName")
				getInitParam(json,name:&m_buyButtonFontSize,keyList:top,"buyButtonFontSize")
				getInitParam(json, name: &m_restoreButtonOffset, keyList: top,"restoreButtonOffset")
				getInitParam(json, name: &m_restoreButtonSize, keyList: top,"restoreButtonSize")
				getInitParam(json,name:&m_restoreButtonFontName,keyList:top,"restoreButtonFontName")
				getInitParam(json,name:&m_restoreButtonFontSize,keyList:top,"restoreButtonFontSize")
				
				getInitArray(json, name: &m_shopItemDesc, keyList: top,"shopItemDesc")
				getInitParam(json,name:&m_shopItemDescFontFilename,keyList:top,"shopItemDescFontFilename")
				getInitParam(json, name: &m_shopItemDescFontSize, keyList: top,"shopitemDescFontSize")
				
			}
			
			for i in 0 ..< m_productIDList.count
			{
				//kobetu setteiarebakokode
				
				
			}
		}
		
		var shopFont = CCommonSpriteCutter(filename: m_shopItemDescFontFilename, x: 8, y: 8)
		
		for i in 0 ..< m_shopItemDesc.count
		{
			var mes = CCommonMessage64(size: m_shopItemDescFontSize, font: shopFont)
			m_shopItemDescMessage.append(mes);
			
			var x : CGFloat = m_shopItemDescPoint.x + CGFloat(i) * m_shopItemDescNext.dx
			var y : CGFloat = m_shopItemDescPoint.y + CGFloat(i) * m_shopItemDescNext.dy
			
			m_shopItemDescMessage[i].position = CGPoint(x:x,y:y)
			self.addChild(m_shopItemDescMessage[i])
		}
		
		
		self.backgroundColor = UIColor(red: m_bgColorRed, green: m_bgColorGreen, blue: m_bgColorBlue, alpha: m_bgColorAlpha)
		scaleMode = .AspectFit
	}
	
	override public func EnterMode()
	{
		super.EnterMode()
		
		m_shopMode = 0
		m_priceGetError = false
		m_processingFlag = false
		
		for i in 0 ..< m_shopItemDesc.count
		{
			var x : CGFloat = m_shopItemDescPoint.x + CGFloat(i) * m_shopItemDescNext.dx
			var y : CGFloat = m_shopItemDescPoint.x + CGFloat(i) * m_shopItemDescNext.dy
			var point = CGPoint(x:x,y:y)
			m_shopItemDescMessage[i].print(point: point, mes: m_shopItemDesc[i], center: true)
		}
		
		
	}
	
	override public func ExitMode()
	{
		super.ExitMode()
		stopIndicator()
	}
	
	override public func onUpdate(currentTime: CFTimeInterval)
	{
		super.onUpdate(currentTime)
		
		if !m_indicatorCreateFlag
		{
			m_indicator = UIActivityIndicatorView()
			m_indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
			m_indicator.center = CGPoint(x:self.view!.frame.width / 2,y:self.view!.frame.height / 2)
			m_indicator.hidesWhenStopped = true
			m_indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
			m_indicator.hidden = false
			//let view = self.view as UIView
			self.view!.addSubview(m_indicator)
			m_indicator.alpha = 1.0
			//			m_indicator.startAnimating()
			
			m_indicatorCreateFlag = true
		}
		
		if m_shopMode == 0
		{
			if checkInAppPurChuse()
			{
				if m_priceGetFlag
				{
					startShop()
				}
				else
				{
					startGetPrice()
				}
			}
			else
			{
				startCannotUseShop()
			}
		}
		else if m_shopMode == SHOP_GETPRICE_MODE
		{
			if m_priceGetFlag
			{
				startShop()
			}
			else if m_priceGetError
			{
				startCannotGetPrice()
			}
		}
		else if m_shopMode == SHOP_MAIN_MODE
		{
		}
		
		
	}
	
	
	public func startGetPrice()
	{
		m_shopMode = SHOP_GETPRICE_MODE
		startIndicator()
		getPriceList(m_productIDList)
	}
	
	
	public func startShop()
	{
		m_shopMode = SHOP_MAIN_MODE
		let game = m_game as CCommonGame
		
		if !m_shopButtonCreateFlag
		{
			for i in 0 ..< m_productIDList.count
			{
				var itemPoint = getItemBasePoint(i)
				var itemTexture = m_shopItemPic.cutSprite(i)
				var itemSprite = SKSpriteNode(texture: itemTexture,color : UIColor.clearColor(),size:m_itemSize)
				itemSprite.position = itemPoint
				self.addChild(itemSprite)
				
				//already buy
				var alreadyBuySprite = SKSpriteNode(texture:m_alreadyBuyPic,color:UIColor.clearColor(),size:m_alreadyBuySize)
				itemSprite.addChild(alreadyBuySprite)
				m_alreadyBuyTexture.append(alreadyBuySprite)
				
				
				//button
				var buyTexture = m_itemButtonPic.cutSprite(0)
				var buyButton = CCommonButton(general: self, texture: buyTexture, size: m_buyButtonSize)
				buyButton.setNumber(3 + i * 2 + 0)
				buyButton.position = getBuyButtonPoint(i)
				
				var label = SKLabelNode(text: m_priceList[i])
				label.fontName = m_buyButtonFontName
				label.fontSize = m_buyButtonFontSize
				label.fontColor = UIColor.cyanColor()
				label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
				label.position = CGPoint(x:0,y:0)
				buyButton.addChild(label)
				
				self.addChild(buyButton)
				
				m_itemButton.append(buyButton)
				
				
				var restoreTexture = m_itemButtonPic.cutSprite(1)
				var restoreButton = CCommonButton(general: self, texture: restoreTexture, size: m_restoreButtonSize)
				restoreButton.position = getRestoreButtonPoint(i)
				restoreButton.setNumber(3 + i * 2 + 1)
				
				var label2 = SKLabelNode(text: m_restoreText)
				label2.fontName = m_restoreButtonFontName
				label2.fontSize = m_restoreButtonFontSize
				label2.fontColor = UIColor.cyanColor()
				label2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
				label2.position = CGPoint(x:0,y:0)
				restoreButton.addChild(label2)
				
				
				self.addChild(restoreButton)
				m_itemButton.append(restoreButton)
				
				
				
			}
			
			
			m_shopButtonCreateFlag = true
		}
		
		checkAlreadyBuyAndSetButton()
	}
	
	public func getItemBasePoint(n:Int) -> CGPoint
	{
		var point:CGPoint = CGPoint(x:0,y:0)
		
		
		var nx = 0
		var ny = 0
		
		if m_itemHorizontally
		{
			nx = n % m_itemBlockX
			ny = n / m_itemBlockX
		}
		else
		{
			ny = n % m_itemBlockY
			nx = n / m_itemBlockY
		}
		
		
		
		point.x = m_itemPoint.x + m_itemNext.dx * CGFloat(nx)
		point.y = m_itemPoint.y + m_itemNext.dy * CGFloat(ny)
		
		return point
	}
	
	
	public func getBuyButtonPoint(n:Int) -> CGPoint
	{
		var point = getItemBasePoint(n)
		point.x += m_buyButtonOffset.dx
		point.y += m_buyButtonOffset.dy
		return point
	}

	public func getRestoreButtonPoint(n:Int) -> CGPoint
	{
		var point = getItemBasePoint(n)
		point.x += m_restoreButtonOffset.dx
		point.y += m_restoreButtonOffset.dy
		return point
	}
	
	
	public func startCannotUseShop()
	{
		
		
		m_shopMode = SHOP_CANNOT_MODE
	}
	
	public func startCannotGetPrice()
	{
		m_shopMode = SHOP_CANNOT_MODE
	}
	
	override public func onCommonClick(number : Int)
	{
		let game = m_game as CCommonGame
		
		if !m_processingFlag
		{
			switch number
			{
			case 0:
				myPlaySound(m_backSound)
				if m_backMode != -1
				{
					m_game.changeMode(m_backMode)
				}
				break
			case 1:
				if m_shopMode == SHOP_MAIN_MODE
				{
			//		m_game.playSound(SHOP_BUY_SOUND)
					printDebugMessage("start payment test")
					startPayment(m_productIDList[0])
				}
			case 2:
				if m_shopMode == SHOP_MAIN_MODE
				{
			//		m_game.playSound(SHOP_RESTORE_SOUND)
					printDebugMessage("start restore test")
					startRestore(m_productIDList[0])
				}
			default:
				//3-
				if m_shopMode == SHOP_MAIN_MODE
				{
					var item = (number - 3) / 2
					var type = (number - 3) % 2
					if type == 0
					{
						myPlaySound(m_buySound)
						printDebugMessage("start payment")
						startPayment(m_productIDList[item])
					}
					else
					{
						myPlaySound(m_restoreSound)
						printDebugMessage("start restore")
						startRestore(m_productIDList[item])
					}
				}
				break
			}
		}
		
		
	}
	
	
	public func startIndicator()
	{
		m_indicator.startAnimating()
		m_processingFlag = true
		for button in m_commonMenu.m_button
		{
			button.alpha = 0.3
		}
	}
	
	public func stopIndicator()
	{
		m_indicator.stopAnimating()
		m_processingFlag = false
		for button in m_commonMenu.m_button
		{
			button.alpha = 1.0
		}
	}
	
	
	public func restoreProduct(productID:String)
	{
		printDebugMessage("restored")
		if var n = searchID(productID)
		{
			m_game.buyItem(n, restore: true, productID: productID)
		}
//		openStage(productID)
		stopIndicator()
		checkAlreadyBuyAndSetButton()
	}
	
	public func purchaseProduct(productID:String)
	{
		printDebugMessage("Purchased")
		if var n = searchID(productID)
		{
			m_game.buyItem(n, restore: false, productID: productID)
		}
//		openStage(productID)
		stopIndicator()
		checkAlreadyBuyAndSetButton()
	}
	
	func searchID(id:String) -> Int?
	{
		for i in 0 ..< m_productIDList.count
		{
			if id == m_productIDList[i]
			{
				return i
			}
		}
		return -1
	}
	
/*
	func openStage(productID:String)
	{
		for i in 0 ..< m_productIDList.count
		{
			if m_productIDList[i] == productID
			{
				let game = m_game as CCommonGame
				game.openStage(i+1)
				return
			}
		}
	}
*/
	
	
	public func checkAlreadyBuyAndSetButton()
	{
		for i in 0 ..< m_productIDList.count
		{
			
			let game = m_game as CCommonGame
			var flag = game.checkBuyItem(i)
			m_alreadyBuyTexture[i].hidden = !flag
			
			if flag
			{
				m_itemButton[i*2].alpha = 0.5
				m_itemButton[i*2].userInteractionEnabled = false
			}
			else
			{
				m_itemButton[i*2].alpha = 1.0
				m_itemButton[i*2].userInteractionEnabled = true
			}
			
		}
	}
	
	
	public func printNoResponseError()
	{
		printDebugMessage("error1")
		var alert = UIAlertView()
		alert.title = "Error"
		alert.message = "No response"
		alert.addButtonWithTitle("OK")
		alert.show()
	}
	
	public func printProductIDError()
	{
		printDebugMessage("error2")
		var alert = UIAlertView()
		alert.title = "Error"
		alert.message = "ID Error"
		alert.addButtonWithTitle("OK")
		alert.show()
	}
	
	public func printFail()
	{
		printDebugMessage("Fail")
		var alert = UIAlertView()
		alert.title = "error"
		alert.message = "Fail"
		alert.addButtonWithTitle("OK")
		alert.show()
	}
	
	public func printPurchaseOk()
	{
		var alert = UIAlertView()
		alert.title = "ok"
		alert.message = "buy complete"
		alert.addButtonWithTitle("OK")
		alert.show()
	}
	
	public func printRestoreOk()
	{
		var alert = UIAlertView()
		alert.title = "ok"
		alert.message = "Restore succeed"
		alert.addButtonWithTitle("OK")
		alert.show()
	}
	
	public func printCannotRestoreNotBuy()
	{
		var alert = UIAlertView()
		alert.title = "error"
		alert.message = "cannot restore, It's not purchased item"
		alert.addButtonWithTitle("OK")
		alert.show()
	}
	
	
	
	public func loadShopItemDesc()
	{
		if var json = CCommonJsonObject.loadByFilename("text/shopitemdesc")
		{
			if var data : AnyObject = json.getAnyObject("itemdesc")
			{
				var t = data as [String]
				m_shopItemDesc = t
			}
					
			if var data : AnyObject = json.getAnyObject("print")
			{
				var t = data as [Int]
				if t.count >= 2
				{
					m_itemDescPrintX = CGFloat(t[0])
					m_itemDescPrintY = CGFloat(t[1])
				}
				if t.count >= 4
				{
					m_itemDescNextX = CGFloat(t[2])
					m_itemDescNextY = CGFloat(t[3])
				}
			}
		}
	}

	
	public func myPlaySound(sound:Int)
	{
		if sound != -1
		{
			m_game.playSound(sound)
		}
	}

	
	

	
	
}



