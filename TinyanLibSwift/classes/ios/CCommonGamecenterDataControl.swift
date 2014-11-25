//
//  CCommonGamecenterDataControl.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2014/09/11.
//  Copyright (c) 2014 bugnekosoft. All rights reserved.
//

import Foundation
import GameKit

let GAMECENTER_DATA_MAX:Int = 256

public class CCommonGamecenterDataControl
{
	var m_number = 0
	var m_max = GAMECENTER_DATA_MAX
	var m_gamecenterEnableFlag = false
	var localPlayer : GKLocalPlayer? = nil

	var m_identifier = [String?](count: GAMECENTER_DATA_MAX, repeatedValue: nil)
	var m_scoreTypeFlag = [Bool](count: GAMECENTER_DATA_MAX, repeatedValue: false)
	var m_gamecenterDataExistFlag = [Bool](count: GAMECENTER_DATA_MAX, repeatedValue: false)
	var m_gamecenterScore = [Int64](count: GAMECENTER_DATA_MAX, repeatedValue: 0)
	var m_gamecenterScoreExistFlag = [Bool](count: GAMECENTER_DATA_MAX, repeatedValue: false)
	var m_gamecenterAchievement = [Double](count: GAMECENTER_DATA_MAX, repeatedValue: 0.0)
	
	var m_achievementLoadFlag = false
	var m_achievementLoadError = false
	var m_achievementLoadingFlag = false
	
	public init()
	{
		for i in 0 ..< GAMECENTER_DATA_MAX
		{
			m_identifier[i] = nil
			m_scoreTypeFlag[i] = false
			m_gamecenterDataExistFlag[i] = false
			m_gamecenterScore[i] = 0
			m_gamecenterScoreExistFlag[i] = false
			m_gamecenterAchievement[i] = 0.0
		}
	}
	
	public func setGamecenterEnable(flag : Bool)
	{
		m_gamecenterEnableFlag = flag
	}
	
	public func authenticateLocalPlayer()
	{
//		println("authenticateLocalPlayer:1")
		if !m_gamecenterEnableFlag
		{
			return
		}
		
		localPlayer = GKLocalPlayer.localPlayer()
		
		localPlayer?.authenticateHandler =
		{
			(viewController : UIViewController!,error : NSError!) in
			
			
			if viewController != nil
			{
				UIApplication.sharedApplication().delegate?.window??.rootViewController?.presentViewController(viewController, animated: true,completion:nil)
//				[[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:viewController animated:YES completion:nil];
				
			}
			else if self.localPlayer!.authenticated
			{
				
			}
			else
			{
				
			}
			
		}
	}
	
	public func addIdentifier(identifier : String , scoreTypeFlag : Bool) ->Bool
	{
		if m_number >= m_max
		{
			return false
		}
		
		m_identifier[m_number] = identifier
		m_scoreTypeFlag[m_number] = scoreTypeFlag
		
		m_number++
		return true
	}
	
	public func addIdentifiers(identifiers : [String] , scoreTypeFlag : Bool) -> Bool
	{
		var returnFlag = true
		
		for identifier in identifiers
		{
			if !addIdentifier(identifier, scoreTypeFlag: scoreTypeFlag)
			{
				returnFlag = false
			}
		}
		
		return returnFlag
	}
	
	public func getGamecenterDataExistFlag(identifier : String) -> Bool
	{
		if let n = searchIdentifier(identifier)
		{
			return m_gamecenterDataExistFlag[n]
		}
		
		return false
	}
	
	public func setGamecenterDataExistFlag(identifier : String , flag : Bool)
	{
		if let n = searchIdentifier(identifier)
		{
			m_gamecenterDataExistFlag[n] = flag
		}
	}
	
	public func setGamecenterScore(identifier : String , score : Int64)
	{
		if let n = searchIdentifier(identifier)
		{
			if m_scoreTypeFlag[n]
			{
				m_gamecenterScore[n] = score
				m_gamecenterScoreExistFlag[n] = true
			}
		}
	}
	
	public func setGamecenterAchievement(identifier : String , percent : Double)
	{
		if let n = searchIdentifier(identifier)
		{
			if !m_scoreTypeFlag[n]
			{
				m_gamecenterAchievement[n] = percent
				m_gamecenterDataExistFlag[n] = true
			}
		}
	}
	
	public func setGamecenterAchievements(achievements : [GKAchievement])
	{
		for achievement in achievements
		{
			setGamecenterAchievement(achievement.identifier, percent: achievement.percentComplete)
		}
	}

	public func loadGamecenterAchievement()
	{
		if !m_gamecenterEnableFlag || m_achievementLoadFlag || m_achievementLoadError || m_achievementLoadingFlag
		{
			return
		}
		
		
		if GKLocalPlayer.localPlayer().authenticated
		{
			m_achievementLoadingFlag = true
		
			GKAchievement.loadAchievementsWithCompletionHandler({
			
				(achievements : [AnyObject]! , error : NSError!) in

				if (error != nil)
				{
					self.m_achievementLoadError = true
					self.m_achievementLoadingFlag = false
				}
				else
				{
					for i in 0 ..< self.m_number
					{
						if self.m_identifier[i] != nil
						{
							if !self.m_scoreTypeFlag[i]
							{
								self.m_gamecenterDataExistFlag[i] = true
							}
						}
					}
				}
				
				self.setGamecenterAchievements(achievements as [GKAchievement])
				
				self.m_achievementLoadFlag = true
				self.m_achievementLoadingFlag = false
			
			})
		}
	}
	
	public func getGamecenterScore(identifier : String) -> Int64
	{
		if let n = searchIdentifier(identifier)
		{
			if m_scoreTypeFlag[n] && m_gamecenterDataExistFlag[n]
			{
				return m_gamecenterScore[n]
			}
		}
		
		return 0
	}
	
	public func getGamecenterAchievement(identifier : String) -> Double
	{
		if let n = searchIdentifier(identifier)
		{
			if !m_scoreTypeFlag[n] && m_gamecenterDataExistFlag[n]
			{
				return m_gamecenterAchievement[n]
			}
		}
		
		return 0.0
	}
	
	
	
	public func searchIdentifier(identifier : String) -> Int?
	{
		for i in 0 ..< m_number
		{
			if m_identifier[i] != nil
			{
				if m_identifier[i]! == identifier
				{
					return i
				}
			}
		}
		
		return nil
	}
	
	
	
	
	
	
}