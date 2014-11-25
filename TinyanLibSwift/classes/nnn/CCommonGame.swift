//
//  CGameCallback.swift
//  colors
//
//  Created by Tinyan on 2014/08/18.
//  Copyright (c) 2014 bugnekosoft. All rights reserved.
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
	public var m_viewController : CCommonViewController
	public var m_soundControl : CCommonSoundControl?
	
	var m_active = true
	var m_iAd = false
	var m_inGamecenter = false
	public var m_soundFlag = true
	public var m_gamecenterFlag = false

	public var m_gamecenterControl : CCommonGamecenterDataControl? = nil
	
	
	var m_userHighScoreData : CCommonUserData? = nil
	var m_userAchievementData : CCommonUserData? = nil
	
	
	
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
			old.ExitMode()
		}
		
		m_mode = newMode
		if let general = m_general[m_mode]
		{
			general.EnterMode()
			let skView = m_viewController.view as SKView
			
			let transition = SKTransition.crossFadeWithDuration(0.1)
			skView.presentScene(general,transition: transition)
		}
	}
	
	public func onUpdate(currentTime: CFTimeInterval)
	{
	}
	
	public func checkActive() -> Bool
	{
		if !m_active || m_iAd || m_inGamecenter
		{
			return false
		}
		return true
	}
	
	
	public func onActive(flag : Bool)
	{
		m_active = flag
	}
	
	public func inGameCenter(flag: Bool)
	{
		if flag
		{
		}
		else
		{
		}
		
		m_inGamecenter = flag
	}
	
	func oniAd(flag : Bool)
	{
		m_iAd = flag
	}
	
	public func getSoundControl() -> CCommonSoundControl
	{
		return m_soundControl!
	}
	
	public func playSound(n:Int)
	{
		if let soundControl = m_soundControl
		{
			if m_soundFlag
			{
				soundControl.play(n)
			}
		}
	}
	
	public func getSoundFlag() -> Bool
	{
		return m_soundFlag
	}

	public func setSoundFlag(flag:Bool)
	{
		m_soundFlag = flag
	}
	
	public func getGamecenterFlag() -> Bool
	{
		return m_gamecenterFlag
	}
	
	public func setGamecenterFlag(flag:Bool)
	{
		m_gamecenterFlag = flag
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
			}
		)
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
			}
		)
	}

	public func createCommonHighscoreAndAchievement(#highscoreNameList:[String] , achievementNameList:[String])
	{
		m_gamecenterControl?.addIdentifiers(highscoreNameList, scoreTypeFlag: true)
		m_gamecenterControl?.addIdentifiers(achievementNameList, scoreTypeFlag: false)
		
		m_userHighScoreData = CCommonUserData(filename: "userHighscore.dat")
		m_userHighScoreData?.addNames(highscoreNameList)
		m_userHighScoreData?.loadData()
		
		m_userAchievementData = CCommonUserData(filename: "userAchievement.dat")
		m_userAchievementData?.addNames(achievementNameList)
		m_userAchievementData?.loadData()
	}
}
