//
//  GameViewController.swift
//  colors
//
//  Created by たいにゃん on 2014/08/11.
//  Copyright (c) 2014年 bugnekosoft. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit


public class CCommonViewController: UIViewController , GKGameCenterControllerDelegate , UINavigationControllerDelegate{
	
	var m_drawType : Int?
	var m_game : CCommonGame?
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		/* Pick a size for the scene */
		//        let scene = GameScene(fileNamed:"GameScene")
		//		let scene = GameScene()
		// Configure the view.
		let skView = self.view as SKView
		skView.showsFPS = true
		skView.showsNodeCount = true
		
		/* Sprite Kit applies additional optimizations to improve rendering performance */
		skView.ignoresSiblingOrder = true
		
		/* Set the scale mode to scale to fit the window */
		//     scene.scaleMode = .AspectFill
		
		//   skView.presentScene(scene)
		
//		let game = CGame(viewController: self)
		
	}

	public func setGame(lpGame : CCommonGame )
	{
		(UIApplication.sharedApplication().delegate as CCommonAppDelegate).setGame(lpGame)
	}
	
	//
	//6以降はよばれない,かわりに
	//-(NSUInteger)supportedInterfaceOrientations
	//
	/*
	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
	// Return YES for supported orientations
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	return YES;
	}
	}
	*/
	
	
	
	override public func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation)
	{
		//	[m_game onRotate:self.interfaceOrientation from:fromInterfaceOrientation];

	}
	
	override public func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
	{
		//	[m_game willRotate:self.interfaceOrientation to:toInterfaceOrientation duration:duration];

		
	}
	
	
	func showBanner(title:String , message:String)
	{
		GKNotificationBanner.showBannerWithTitle(title, message: message, completionHandler:
			{() -> Void in }
		)
		
	}
	
	public func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
	{
		self.dismissViewControllerAnimated(true, completion: nil)
		m_game?.inGameCenter(false)
	}
	
	override public func shouldAutorotate() -> Bool {
		return true
	}
	
	override public func supportedInterfaceOrientations() -> Int {
		if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
			return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
		} else {
			return Int(UIInterfaceOrientationMask.All.toRaw())
		}
	}
	
	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
	
	override public func prefersStatusBarHidden() -> Bool {
		return true
	}
}
