//
//  CCommonTitle.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2/18/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

let TITLE_START_BUTTON = 0
let TITLE_CONFIG_BUTTON = 1
let TITLE_GAMECENTER_BUTTON = 2
let TITLE_OTHERAPP_BUTTON = 3

let TITLE_BUTTON_LAYER_Z : CGFloat = 50.0

public class CCommonTitle : CCommonGeneral
{
	convenience required public init(coder aDecoder: NSCoder)
	{
		self.init(coder:aDecoder)
	}

	public var m_playerFlag = false
	public var m_titleButtonSound : [Int] = []
	public var m_titleButton : [CCommonButton] = []
	public var m_titleButtonPic : CCommonSpriteCutter!
	
	
	
	
	
	override public init(modeNumber:Int , game : CCommonGame, size:CGSize)
	{
		super.init(modeNumber:modeNumber , game:game , size: size)
		
		m_bgColorRed = 0.1
		m_bgColorGreen = 0.1
		m_bgColorBlue = 0.9
		m_bgColorAlpha = 1.0

		
		
		if var json = CCommonJsonObject.loadByFilename("init/title")
		{
			getCommonParam(json)
			m_commonMenu = CCommonMenu(general: self, json: json, menu: "menu")
			self.addChild(m_commonMenu)
		}
		
		self.backgroundColor = UIColor(red: m_bgColorRed, green: m_bgColorGreen, blue: m_bgColorBlue, alpha: m_bgColorAlpha)
		scaleMode = .AspectFit
		
		if m_game.checkGamecenterEnable()
		{
			m_playerFlag = true
		}
	}
	
	public override func EnterMode()
	{
		super.EnterMode()

		m_commonMenu?.createAllButton([])
		setButtonStatus()
		checkPlayer()
	}
	
	public override func ExitMode()
	{
		super.ExitMode()
	}
	
	override public func ReturnFromGamecenter()
	{
		m_commonMenu?.createAllButton([])
		setButtonStatus()
		checkPlayer()
	}

	public override func onUpdate(currentTime: CFTimeInterval)
	{
		super.onUpdate(currentTime)

		checkPlayer()
		
		if var cmd = calcuCommonButtonResult()
		{
			switch cmd
			{
			case TITLE_START_BUTTON:
				m_game.newGame()
			case TITLE_CONFIG_BUTTON:
				m_game.changeMode(CONFIG_MODE)
			case TITLE_GAMECENTER_BUTTON:
				m_game.showRanking()
			case TITLE_OTHERAPP_BUTTON:
				m_game.changeMode(OTHERAPP_MODE)
				break
			default:
				break
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
					m_commonLastCount = 60
						
					var tm = 1.0
					var turnAction = SKAction.rotateByAngle(3.14, duration: tm)
					var fadeoutAction = SKAction.fadeOutWithDuration(tm)
					var scaleAction = SKAction.scaleTo(3.0, duration: tm)
					var groupAction = SKAction.group([turnAction,fadeoutAction,scaleAction])

					var button = menu.m_button[number]
					var sound = button.m_sound
					m_game.playSound(sound)
				
					button.runAction(groupAction)
				}
			}
		}
	}
	
	
	public func checkPlayer()
	{
		if m_playerFlag && m_game.m_gamecenterFlag
		{
			setButtonStatus()
			return
		}
		
		if m_playerFlag
		{
			return
		}
		
		if !m_game.m_gamecenterFlag
		{
			return
		}
		
		if m_game.checkGamecenterEnable()
		{
			m_playerFlag = true;
			setButtonStatus()
		}
	}
	
	public func setButtonStatus()
	{
		var flag = m_game.checkGamecenterEnable()
		if var menu = m_commonMenu
		{
			if menu.m_button.count > TITLE_GAMECENTER_BUTTON
			{
				var button = menu.m_button[TITLE_GAMECENTER_BUTTON]
				var alpha : CGFloat = 1.0
				
				if !flag
				{
					alpha = 0.4
				}
				
				button.userInteractionEnabled = flag
				button.alpha = alpha
			}
		}
	}

}