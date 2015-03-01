//
//  AppDelegate.swift
//  colors
//
//  Created by Tinyan on 2014/08/11.
//  Copyright (c) 2014 bugnekosoft. All rights reserved.
//

import UIKit


public class CCommonAppDelegate: UIResponder , UIApplicationDelegate{
	
	public var window: UIWindow?
	public var m_game : CCommonGame?
	
	public override init()
	{
		super.init()
		m_game = nil
	}
	
	public func setGame(lpGame : CCommonGame)
	{
		m_game = lpGame
	}

	
	
	public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}
	
	public func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
		m_game?.onActive(false)
	}
	
	public func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	public func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	public func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		m_game?.onActive(true)
	}
	
	public func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	
}

