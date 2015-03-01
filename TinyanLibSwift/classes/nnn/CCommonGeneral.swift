//
//  CCommonGeneral.swift
//  colors
//
//  Created by Tinyan on 2014/08/11.
//  Copyright (c) 2014 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit

let COMMON_BUTTON_LAYER_Z : CGFloat = 50.0

public class CCommonGeneral : SKScene
{
	override public func didMoveToView(view: SKView)
	{
	}
	
	
	convenience required public init(coder aDecoder: NSCoder)
	{
		self.init(coder:aDecoder)
	}
	
	
	public var m_game : CCommonGame
	public var m_modeNumber:Int
	
	public var m_commonMenu : CCommonMenu!
	public var m_commonCommand = -1
	public var m_commonLastCount = 0
	

	public var m_bgColorRed : CGFloat = 0.5
	public var m_bgColorGreen : CGFloat = 0.5
	public var m_bgColorBlue : CGFloat = 0.5
	public var m_bgColorAlpha : CGFloat = 1.0
	
	public init(modeNumber:Int , game : CCommonGame, size:CGSize)
	{
		m_game = game
		m_modeNumber = modeNumber
		
		super.init(size: size)
		
		self.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.3, alpha: 1.0)
		scaleMode = .AspectFill
	}
	
	public func ExitMode()
	{
	}
	
	
	public func EnterMode()
	{
		m_commonCommand = -1
	}

	override public func touchesBegan(touches: NSSet, withEvent event: UIEvent)
//	override public func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
	{
		if m_game.checkActive()
		{
			if m_modeNumber == m_game.m_mode
			{
				onTouchesBegan(touches, withEvent: event)
			}
		}
	}
	
	override public func touchesMoved(touches: NSSet, withEvent event: UIEvent)
//	override public func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
	{
		if m_game.checkActive()
		{
			if m_modeNumber == m_game.m_mode
			{
				onTouchesMoved(touches, withEvent: event)
			}
		}
	}
	
	override public func touchesEnded(touches: NSSet, withEvent event: UIEvent)
//	override public func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
	{
		if m_game.checkActive()
		{
			if m_modeNumber == m_game.m_mode
			{
				onTouchesEnded(touches, withEvent: event)
			}
		}
	}
	
	//dummy routine
	public func onTouchesBegan(touches: NSSet, withEvent event: UIEvent)
	{
		
	}
	
	public func onTouchesMoved(touches: NSSet, withEvent event: UIEvent)
	{
		
	}
	
	public func onTouchesEnded(touches: NSSet, withEvent event: UIEvent)
	{
		
	}

	
	override public func update(currentTime: CFTimeInterval)
	{
		if m_game.checkActive()
		{
			m_game.onUpdate(currentTime)
			
			if m_modeNumber == m_game.m_mode
			{
				onUpdate(currentTime)
			}
		}
		
	}
	
	//dummy
	public func onUpdate(currentTime: CFTimeInterval)
	{
	}
	
	public func onCommonClick(number:Int)
	{
	}
	
	public func calcuCommonButtonResult() -> Int?
	{
		if m_commonCommand != -1
		{
			if m_commonLastCount > 0
			{
				m_commonLastCount--
				if m_commonLastCount == 0
				{
					return m_commonCommand
				}
			}
		}
		
		return nil
	}
	
	
	public func captureImage(imageSize:CGSize,aspectFit:Bool = true) -> UIImage
	{
		var rect = self.frame
		
		UIGraphicsBeginImageContextWithOptions(rect.size,false,UIScreen.mainScreen().scale)
		if let view = self.view
		{
			view.drawViewHierarchyInRect(rect, afterScreenUpdates: true)
		}
		var image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		
		
		var w = imageSize.width
		var h = imageSize.height
		var x : CGFloat = 0.0
		var y : CGFloat = 0.0
		
		if aspectFit
		{
			var imageAspect = w / h
			var aspect = rect.size.width / rect.size.height

			if imageAspect >= aspect
			{
				h = w * aspect
			}
			else
			{
				w = h / aspect
			}
			
			x = ( imageSize.width - w ) * 0.5
			y = ( imageSize.height - h ) * 0.5
		}
		
//		var w : CGFloat = 900.0 / 2.0
//		var h : CGFloat = rect.size.height * (w / rect.size.width)
		
		UIGraphicsBeginImageContext(CGSize(width: imageSize.width, height: imageSize.height))
		image.drawInRect(CGRect(x: x, y: y, width: w, height: h))
		var image2 = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image2
	}
	
	public func getViewParam(json:CCommonJsonObject)
	{
		if var red : Int = json.getObject(keyList: "view","red")
		{
			m_bgColorRed = CGFloat(red) / 255.0
		}
		if var green : Int = json.getObject(keyList: "view","green")
		{
			m_bgColorGreen = CGFloat(green) / 255.0
		}
		if var blue : Int = json.getObject(keyList: "view","blue")
		{
			m_bgColorBlue = CGFloat(blue) / 255.0
		}
		if var alpha : Int = json.getObject(keyList: "view","alpha")
		{
			m_bgColorAlpha = CGFloat(alpha) / 255.0
		}
		
	}

}