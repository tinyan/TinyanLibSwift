//
//  CCommonGeneral.swift
//  colors
//
//  Created by たいにゃん on 2014/08/11.
//  Copyright (c) 2014年 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit

class CCommonGeneral : SKScene
{
	
	
	override func didMoveToView(view: SKView)
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
	
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
		//self.init(coder: aDecoder)
	}
	
	var m_game : CCommonGame?
	
	
	init(game : CCommonGame, size:CGSize)
	{
		//var size = CGSizeMake(600,400)
		super.init(size: size)
		//		super.init(fileNamed: "GameScene")
		m_game = game
		scaleMode = .AspectFill
	}
	
	func ExitMode()
	{
		NSLog("general:ExitMode()")
	}
	
	
	func EnterMode()
	{
		NSLog("general:EnterMode()")
		
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
	{
		/* Called when a touch begins */
		
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self)
			
			NSLog("touch %f %f",Float(location.x),Float(location.y));
		}
	}
	override func update(currentTime: CFTimeInterval)
	{
		m_game?.onUpdate(currentTime)
		//	NSLog("update general")
		/* Called before each frame is rendered */
	}
}