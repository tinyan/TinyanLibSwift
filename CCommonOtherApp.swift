//
//  CCommonOtherApp.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2/18/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

let OTHERAPP_EXIT_BUTTON = 0

public class CCommonOtherApp : CCommonGeneral
{
	convenience required public init(coder aDecoder: NSCoder)
	{
		self.init(coder:aDecoder)
	}
	
	
	override public init(modeNumber:Int , game : CCommonGame, size:CGSize)
	{
		super.init(modeNumber:modeNumber , game:game , size: size)

		m_bgColorRed = 0.1
		m_bgColorGreen = 0.1
		m_bgColorBlue = 0.9
		m_bgColorAlpha = 1.0
		
		if var json = CCommonJsonObject.loadByFilename("init/otherapp")
		{
			getViewParam(json)
			m_commonMenu = CCommonMenu(general: self, json: json, menu: "menu")
			self.addChild(m_commonMenu)
			
		}
		
		self.backgroundColor = UIColor(red: m_bgColorRed, green: m_bgColorGreen, blue: m_bgColorBlue, alpha: m_bgColorAlpha)
		scaleMode = .AspectFit
		
	}
	
	public override func EnterMode()
	{
		super.EnterMode()
	}
	
	public override func ExitMode()
	{
		super.ExitMode()
	}
	
	public override func onUpdate(currentTime: CFTimeInterval)
	{
		super.onUpdate(currentTime)
			
		if var cmd = calcuCommonButtonResult()
		{
			if cmd == OTHERAPP_EXIT_BUTTON
			{
				m_game.changeMode(TITLE_MODE)
			}
			else if cmd != -1
			{
				
				
				
				//other app
			}
			
		}
	}

	public override func onCommonClick(number : Int)
	{
		if m_commonCommand == -1
		{
			if var menu = m_commonMenu
			{
				if number < menu.m_button.count
				{
					m_commonCommand = number
					m_commonLastCount = 1
					
//					var tm = 1.0
//					var turnAction = SKAction.rotateByAngle(3.14, duration: tm)
//					var fadeoutAction = SKAction.fadeOutWithDuration(tm)
//					var scaleAction = SKAction.scaleTo(3.0, duration: tm)
//					var groupAction = SKAction.group([turnAction,fadeoutAction,scaleAction])
					
					var button = menu.m_button[number]
					var sound = button.m_sound
					m_game.playSound(sound)
					
//					button.runAction(groupAction)
				}
			}
		}
	}
	
}