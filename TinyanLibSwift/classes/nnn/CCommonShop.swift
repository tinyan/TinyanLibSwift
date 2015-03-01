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
	
	func getPriceList(objects:[AnyObject])
	{
		var productID : NSSet  = NSSet(array:objects)
//		var request  = SKProductsRequest(productIdentifiers: productID)
		var request  = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
		request.delegate = self
		request.start()
	}
	
	
	func startPayment(object:AnyObject)
	{
		//var productID : NSSet  = NSSet(object:"com.bugnekosoft.kusogee.extrastage1")
		m_paymentMode = true
		m_productID = object as! NSString as String
		
		
		var productID : NSSet  = NSSet(object:object)
//		var request  = SKProductsRequest(productIdentifiers: productID )
		var request  = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
		request.delegate = self
		startIndicator()
		request.start()
	}
	
	func startRestore(object:AnyObject)
	{
		m_paymentMode = false
		m_productID = object as! NSString as String
		
		
		var productID : NSSet  = NSSet(object:object)
//		var request  = SKProductsRequest(productIdentifiers:  productID)
		var request  = SKProductsRequest(productIdentifiers:  productID as Set<NSObject>)
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
				var ids = (product as! SKProduct).productIdentifier
				
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
		
		
		for product in response.products
		{
			m_payment = SKPayment(product: product as! SKProduct)
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
		for object in transactions
		{
			let transaction = object as! SKPaymentTransaction
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
		
		for transaction in queue.transactions
		{
			if (transaction as! SKPaymentTransaction).payment.productIdentifier == m_productID
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
	
	
	
	public var m_indicatorCreateFlag = false
	public var m_buttonPic = CCommonSpriteCutter(filename: "bmp/shopbutton.png", x: 1, y: 2)
	public var m_shopButton : [CCommonButton] = []
	public var m_indicator : UIActivityIndicatorView!
	
	public var m_shopMode = 0
	public var m_shopButtonCreateFlag = false
	
	public var m_shopItemPic = CCommonSpriteCutter(filename: "bmp/shopitem.png", x: 2, y: 2)
	public var m_alreadyButPic = SKTexture(imageNamed: "bmp/alreadybuy.png")
	public var m_itemButtonPic = CCommonSpriteCutter(filename: "bmp/shopitembutton.png", x: 1, y: 2)
	
	public var m_itemButton : [CCommonButton] = []
	public var m_alreadyBuyTexture : [SKSpriteNode] = []
	
	//	required init?(coder aDecoder: NSCoder) {
	//		super.init(coder: aDecoder)
	//	}
	
	public var m_priceGetFlag = false
	
	public var m_shopItemDesc : [String] = ["DESC1","DESC2..."]
	public var m_shopItemDescFilename : String = "text/shopitemdesc"
	
	public var m_shopItemDescMessage : [CCommonMessage64] = []
	
	public var m_itemDescPrintX : CGFloat = 450.0
	public var m_itemDescPrintY : CGFloat = 900.0
	public var m_itemDescNextX : CGFloat = 0
	public var m_itemDescNextY : CGFloat = -150.0

	public var m_debugMessagePrintFlag = true
	
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
		
		self.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.9, alpha: 1.0)
		scaleMode = .AspectFit

		//set
		//dummy
		m_productIDList = ["com.bugnekosoft.kusogee.extrastage1"]
		m_priceList = ["dummy"]
		m_priceListGetFlag = [false]
		
		
		
		//		for i in 0 ..< 3 //for debug button
		for i in 0 ..< 1
		{
			var b = 0
			if i > 0
			{
				b = 1
			}
			var texture = m_buttonPic.cutSprite(b)
			var buttonSize = CGSize(width: 300.0, height: 150.0)
			var button = CCommonButton(general: self, texture: texture, size: buttonSize)
			var bx = CGFloat(i%3) * 300.0 + 150.0
			var by = CGFloat(i/3) * 150.0 + 75.0
			var pos = CGPoint(x:bx , y:by)
			button.setNumber(i)
			button.position = pos
			self.addChild(button)
			m_shopButton.append(button)
		}
		
		loadShopItemDesc()
		
		var shopFont = CCommonSpriteCutter(filename: "bmp/shopfont.png", x: 8, y: 8)
		
		
		for i in 0 ..< m_shopItemDesc.count
		{
			var mes = CCommonMessage64(size: CGSize(width: 32, height: 32), font: shopFont)
			m_shopItemDescMessage.append(mes);
			var x : CGFloat = m_itemDescPrintX + CGFloat(i) * m_itemDescNextX
			var y : CGFloat = m_itemDescPrintY + CGFloat(i) * m_itemDescNextY
			
			m_shopItemDescMessage[i].position = CGPoint(x:x,y:y)
			self.addChild(m_shopItemDescMessage[i])
		}
	}
	
	override public func EnterMode()
	{
		super.EnterMode()
		
		m_shopMode = 0
		m_priceGetError = false
		m_processingFlag = false
		
		for i in 0 ..< m_shopItemDesc.count
		{
			var x : CGFloat = m_itemDescPrintX + CGFloat(i) * m_itemDescNextX
			var y : CGFloat = m_itemDescPrintY + CGFloat(i) * m_itemDescNextY
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
				var printX : CGFloat = 225.0
				var printY : CGFloat = 1350.0 - CGFloat(i) * 500.0
				
				var itemTexture = m_shopItemPic.cutSprite(i)
				var itemSize = CGSize(width: 400, height: 400)
				var itemSprite = SKSpriteNode(texture: itemTexture,color : UIColor.clearColor(),size:itemSize)
				itemSprite.position = CGPoint(x:printX,y:printY)
				self.addChild(itemSprite)
				
				//already buy
				var alreadyBuySize = CGSize(width: 300.0, height: 300.0)
				var alreadyBuySprite = SKSpriteNode(texture:m_alreadyButPic,color:UIColor.clearColor(),size:alreadyBuySize)
				itemSprite.addChild(alreadyBuySprite)
				m_alreadyBuyTexture.append(alreadyBuySprite)
				
				//button
				var buttonSize = CGSize(width: 400.0, height: 100.0)
				var buyTexture = m_itemButtonPic.cutSprite(0)
				var buyButton = CCommonButton(general: self, texture: buyTexture, size: buttonSize)
				buyButton.setNumber(3 + i * 2 + 0)
				var buyButtonPos = CGPoint(x:printX + 450.0,y:printY + 100.0)
				buyButton.position = buyButtonPos
				
				var label = SKLabelNode(text: m_priceList[i])
				label.fontName = "Helvetica-Bold"
				label.fontSize = 64
				label.fontColor = UIColor.cyanColor()
				label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
				label.position = CGPoint(x:0,y:0)
				buyButton.addChild(label)
				
				self.addChild(buyButton)
				
				m_itemButton.append(buyButton)
				
				var restoreTexture = m_itemButtonPic.cutSprite(1)
				var restoreButton = CCommonButton(general: self, texture: restoreTexture, size: buttonSize)
				var restoreButtonPos = CGPoint(x:printX + 450.0,y:printY - 100.0)
				restoreButton.position = restoreButtonPos
				restoreButton.setNumber(3 + i * 2 + 1)
				
				var label2 = SKLabelNode(text: "RESTORE")
				label2.fontName = "Helvetica-Bold"
				label2.fontSize = 64
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
		for i in 0 ..< m_shopButton.count
		{
			m_shopButton[i].alpha = 0.3
		}
	}
	
	public func stopIndicator()
	{
		m_indicator.stopAnimating()
		m_processingFlag = false
		for i in 0 ..< m_shopButton.count
		{
			m_shopButton[i].alpha = 1.0
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
			/*
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
			*/
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
				var t = data as! [String]
				m_shopItemDesc = t
			}
					
			if var data : AnyObject = json.getAnyObject("print")
			{
				var t = data as! [Int]
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

	func printDebugMessage(mes:String)
	{
		if m_debugMessagePrintFlag
		{
			println(mes)
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



