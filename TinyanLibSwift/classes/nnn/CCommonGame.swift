//
//  CGameCallback.swift
//  colors
//
//  Created by たいにゃん on 2014/08/18.
//  Copyright (c) 2014年 bugnekosoft. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

let NOTHING_MODE = 0


class CCommonGame
{
	var m_mode = 0
	var m_general = [CCommonGeneral?](count: 256, repeatedValue: nil)
	//	var m_general = [GameScene?](count: 256, repeatedValue: nil)
	var m_viewController : CCommonViewController
	var m_soundControl : CCommonSoundControl?
	
	var m_active : Bool
	var m_iAd : Bool
	var m_inGamecenter : Bool
	
	
	init(viewController:CCommonViewController)
	{
		m_viewController = viewController
		m_mode = NOTHING_MODE
		m_active = true
		m_iAd = false
		m_inGamecenter = false
	}
	
	
	func changeMode(newMode : Int)
	{
		if let old = m_general[m_mode]
		{
			NSLog("finalexit")
			old.ExitMode()
		}
		
		NSLog("first")
		m_mode = newMode
		if let general = m_general[m_mode]
		{
			general.EnterMode()
			
			NSLog("second")
			let skView = m_viewController.view as SKView
			
			let transition = SKTransition.crossFadeWithDuration(0.1)
			skView.presentScene(general,transition: transition)
		}
	}
	
	func onUpdate(currentTime: CFTimeInterval)
	{
		//	NSLog("update gamecallback")
		/* Called before each frame is rendered */
	}
	
	func onActive(flag : Bool)
	{
	}
	
	func inGameCenter(flag: Bool)
	{
	}
	
	func oniAd(flag : Bool)
	{
	}
	
	func getSoundControl() -> CCommonSoundControl
	{
		return m_soundControl!
	}
}
