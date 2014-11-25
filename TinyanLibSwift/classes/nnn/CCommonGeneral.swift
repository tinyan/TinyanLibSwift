//
//  CCommonGeneral.swift
//  colors
//
//  Created by Tinyan on 2014/08/11.
//  Copyright (c) 2014 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit

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
		
	}
	
	override public func touchesBegan(touches: NSSet, withEvent event: UIEvent)
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
	
}