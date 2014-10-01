//
//  CCommonGeneral.swift
//  colors
//
//  Created by たいにゃん on 2014/08/11.
//  Copyright (c) 2014年 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit




public class CCommonGeneral : SKScene
{
	
	
	override public func didMoveToView(view: SKView)
	{
		/* Setup your scene here */
		//		let myLabel = SKLabelNode(fontNamed:"Chalkduster")
		//		myLabel.text = "Hello, World!";
		//		myLabel.fontSize = 65;
		//		myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
		
		//		self.addChild(myLabel)
	}
	
	
	//	init(game:CGame)
	
	/*
	//	convenience required init(coder aDecoder: NSCoder!) {
	//		self.init(coder: aDecoder)
	//	}
	required init(coder aDecoder: NSCoder!) {
	super.init(coder: aDecoder);
	//self.init(coder: aDecoder)
	}
	*/
	
	
	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
		//self.init(coder: aDecoder)
	}
	
	
	public var m_game : CCommonGame?
	
	
	public init(game : CCommonGame, size:CGSize)
	{
		//var size = CGSizeMake(600,400)
		super.init(size: size)
		//		super.init(fileNamed: "GameScene")
		m_game = game
		scaleMode = .AspectFill
	}
	
	public func ExitMode()
	{
		NSLog("general:ExitMode()")
	}
	
	
	public func EnterMode()
	{
		NSLog("general:EnterMode()")
		
	}
	
	override public func touchesBegan(touches: NSSet, withEvent event: UIEvent)
	{
		if m_game!.checkActive()
		{
			onTouchesBegan(touches, withEvent: event)
		}
		
		/* Called when a touch begins */
		
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self)
			
			NSLog("touch %f %f",Float(location.x),Float(location.y));
		}
	}
	
	override public func touchesMoved(touches: NSSet, withEvent event: UIEvent)
	{
		if m_game!.checkActive()
		{
			onTouchesMoved(touches, withEvent: event)
		}
	}
	
	override public func touchesEnded(touches: NSSet, withEvent event: UIEvent)
	{
		if m_game!.checkActive()
		{
			onTouchesEnded(touches, withEvent: event)
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
		if m_game!.checkActive()
		{
			m_game?.onUpdate(currentTime)
			onUpdate(currentTime)
		}
		
		//	NSLog("update general")
		/* Called before each frame is rendered */
	}
	
	//dummy
	public func onUpdate(currentTime: CFTimeInterval)
	{
	}
	
}