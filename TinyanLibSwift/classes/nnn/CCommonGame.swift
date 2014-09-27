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
import GameKit


let NOTHING_MODE = 0


public class CCommonGame
{
	public var m_mode = 0
	public var m_general = [CCommonGeneral?](count: 256, repeatedValue: nil)
	//	var m_general = [GameScene?](count: 256, repeatedValue: nil)
	public var m_viewController : CCommonViewController
	var m_soundControl : CCommonSoundControl?
	
	var m_active = true
	var m_iAd = false
	var m_inGamecenter = false

	var m_gamecenterControl : CCommonGamecenterDataControl? = nil
	
	public init(viewController:CCommonViewController)
	{
		m_viewController = viewController
		m_mode = NOTHING_MODE
		m_active = true
		m_iAd = false
		m_inGamecenter = false
		m_gamecenterControl = CCommonGamecenterDataControl()
	}
	
	
	public func changeMode(newMode : Int)
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
	
	public func onUpdate(currentTime: CFTimeInterval)
	{
		//	NSLog("update gamecallback")
		/* Called before each frame is rendered */
	}
	
	func checkActive() -> Bool
	{
		if !m_active || m_iAd || m_inGamecenter
		{
			return false
		}
		return true
	}
	
	
	func onActive(flag : Bool)
	{
		m_active = flag;
	}
	
	func inGameCenter(flag: Bool)
	{
		m_inGamecenter = flag;
	}
	
	func oniAd(flag : Bool)
	{
		m_iAd = flag;
	}
	
	public func getSoundControl() -> CCommonSoundControl
	{
		return m_soundControl!
	}
	
	public func reportAchievement(percent:Double , identifier : String , popup : Bool)
	{
		if GKLocalPlayer.localPlayer().authenticated
		{
			var achievement = GKAchievement(identifier: identifier)
			achievement.percentComplete = percent
			if popup
			{
				achievement.showsCompletionBanner = true
			}
			
			var achievements = [achievement]
			
			GKAchievement.reportAchievements(achievements,
				withCompletionHandler:
				{
					(error:NSError!) in
					self.receiveAchievementResult(identifier, percent: percent, error: error)
				}
			)
		}
	}
	
	public func reportAchievement(percent:Double , identifier : String , title:String , message:String)
	{
		if GKLocalPlayer.localPlayer().authenticated
		{
			var achievement = GKAchievement(identifier: identifier)
			achievement.percentComplete = percent
			
			var achievements = [achievement]

			GKAchievement.reportAchievements(achievements,
				withCompletionHandler:
				{
					(error:NSError!) in
					self.m_viewController.showBanner(title, message:message)
					self.receiveAchievementResult(identifier, percent: percent, error: error)
				}
			)
		}
	}
	
	
	
	public func reportScrore(score : Int64 , identifier : String)
	{
		if GKLocalPlayer.localPlayer().authenticated
		{
			var scoreReporter = GKScore(leaderboardIdentifier: identifier)
			scoreReporter.value = score
			scoreReporter.context = 0
			
			var scores = [scoreReporter]
			GKScore.reportScores(scores,
				withCompletionHandler:
				{
					(error:NSError!) in
					self.receiveScoreResult(identifier, score: score, error:error)
				}
			)
		}
	}
	
	public func receiveScoreResult(identifier : String, score : Int64 , error:NSError?)
	{
		if (error != nil)
		{
			m_gamecenterControl?.setGamecenterScore(identifier, score: score)
		}
	}
	
	public func receiveAchievementResult(identifier : String, percent : Double , error:NSError?)
	{
		if (error != nil)
		{
			m_gamecenterControl?.setGamecenterAchievement(identifier, percent: percent)
		}
	}
	
	public func showRanking()
	{
		var gamecenterController = GKGameCenterViewController()
		gamecenterController.viewState = GKGameCenterViewControllerState.Leaderboards
		gamecenterController.gameCenterDelegate = m_viewController
		
		m_viewController.presentViewController(gamecenterController, animated:true ,
			completion:
			{
				() in
				self.inGameCenter(true)
		})
	}
	
	
	public func showAchievements()
	{
		var gamecenterController = GKGameCenterViewController()
		gamecenterController.viewState = GKGameCenterViewControllerState.Achievements
		gamecenterController.gameCenterDelegate = m_viewController
		
		m_viewController.presentViewController(gamecenterController, animated:true ,
			completion:
			{
				() in
				self.inGameCenter(true)
			})
	}
	
}
