//
//  CCommonConfig.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2/18/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

let CONFIG_BUTTON_LAYER_Z : CGFloat = 50.0

public class CCommonConfig : CCommonGeneral
{
	convenience required public init(coder aDecoder: NSCoder)
	{
		self.init(coder:aDecoder)
	}
	

	
	
	override public init(modeNumber:Int , game : CCommonGame, size:CGSize)
	{
		super.init(modeNumber:modeNumber , game:game , size: size)
		
		self.backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 1.0)
		scaleMode = .AspectFit
		
		
		
		if var json = CCommonJsonObject.loadByFilename("init/config")
		{
			m_commonMenu = CCommonMenu(general: self, json: json, menu: "menu")
			self.addChild(m_commonMenu)
		}
		
	}
	
	public override func EnterMode()
	{
		super.EnterMode()

	
		reCreateButton()
		
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
			switch cmd
			{
			case 0:
				var soundFlag = m_game.getSoundFlag()
				soundFlag = !soundFlag
				m_game.setSoundFlag(soundFlag)
				m_game.setCommonUserConfigBool(COMMON_CONFIG_SOUND_FLAG, flag: soundFlag)
				m_game.saveCommonUserConfig()
				reCreateButton()
				
			case 1:
				var gamecenterFlag = m_game.getGamecenterFlag()
				gamecenterFlag = !gamecenterFlag
				m_game.setGamecenterFlag(gamecenterFlag)
				m_game.setCommonUserConfigBool(COMMON_CONFIG_GAMECENTER_FLAG, flag: gamecenterFlag)
				m_game.saveCommonUserConfig()
				m_game.changeGamecenterStatus(gamecenterFlag)
				
				reCreateButton()
				
			case 2:
				m_game.changeMode(TITLE_MODE)
				
			default:
				break
			}
		}
	}
	
	
	public override func onCommonClick(number : Int)
	{
		if m_commonCommand == -1
		{
			
			m_commonCommand = number
			m_commonLastCount = 60
			
			var tm = 1.0
			var turnAction = SKAction.rotateByAngle(3.14, duration: tm)
			var fadeoutAction = SKAction.fadeOutWithDuration(tm)
			var scaleAction = SKAction.scaleTo(3.0, duration: tm)
			var groupAction = SKAction.group([turnAction,fadeoutAction,scaleAction])

			if var menu = m_commonMenu
			{
				if number < menu.m_button.count
				{
					var button = menu.m_button[number]
					var sound = button.m_sound
					m_game.playSound(sound)
					button.runAction(groupAction)
				}
			}
		}
	}
	
	public func reCreateButton()
	{
		var status = [0,0,0]
		
		if !m_game.getSoundFlag()
		{
			status[0] = 1
		}
		
		if !m_game.getGamecenterFlag()
		{
			status[1] = 1
		}
		
		m_commonMenu.createAllButton(status)

		m_commonCommand = -1
	}


}
