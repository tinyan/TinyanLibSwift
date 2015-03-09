//
//  CCommonButton.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 1/24/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//
import Foundation
import SpriteKit
import UIKit

let COMMON_TOUCH_LAYER : CGFloat = 50.0


public class CCommonButton : SKSpriteNode
{
	//	required init?(coder aDecoder: NSCoder)
	//	{
	//		super.init(coder: aDecoder)
	//	}
	
	convenience public required init(coder aDecoder: NSCoder)
	{
		self.init(coder:aDecoder)
	}
	
	
	var m_parent : CCommonGeneral
	var m_number = 0
	var m_action:SKAction? = nil
	public var m_sound = -1
	
	public init(general : CCommonGeneral, texture: SKTexture!,size: CGSize)
	{
		m_parent = general
		let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
		m_action = nil
		
		super.init(texture: texture, color: color, size: size)
		
		addTouchSprite(size)
		
		userInteractionEnabled = true
	}
	
	
	public init(general : CCommonGeneral, size: CGSize)
	{
		m_parent = general
		let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
		m_action = nil
		
		super.init(texture: nil, color: color, size: size)
		
		addTouchSprite(size)
		
		userInteractionEnabled = true
	}
	
	public func addTouchSprite(size:CGSize)
	{
		//add for touch sprite
		var touchSprite = SKSpriteNode(texture: nil, size: size)
		touchSprite.zPosition = COMMON_TOUCH_LAYER
		self.addChild(touchSprite)
	}
	
	public func setNumber(number : Int)
	{
		m_number = number
	}
	
	
	public func addSprite(#sprite : SKSpriteNode , point:CGPoint , name:String = "default")
	{
		sprite.name = name
		sprite.position = point
		self.addChild(sprite)
	}
	
	public func removeSprite(name:String = "default")
	{
		if var sprite = self.childNodeWithName(name)
		{
//			println("found!")
			sprite.removeFromParent()
		}
		else
		{
//			println("not found sprite name:\(name)")
		}
	}
	
	
	public func addActionData(action:SKAction)
	{
		m_action = action
	}
	
	public func startAction()
	{
		if let action = m_action
		{
			self.runAction(action)
		}
	}
	
	
	func removeMe()
	{
		removeFromParent()
	}
	
	
	override public func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
//	override public func touchesBegan(touches: NSSet, withEvent event: UIEvent)
	{
		m_parent.onCommonClick(m_number)
	}
	
	
}

