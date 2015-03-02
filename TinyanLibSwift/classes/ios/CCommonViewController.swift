//
//  GameViewController.swift
//
//  Created by Tinyan on 2014/08/11.
//  Copyright (c) 2014 bugnekosoft. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import Social

public class CCommonViewController: UIViewController , GKGameCenterControllerDelegate , UINavigationControllerDelegate{
	
	var m_drawType : Int?
	var m_game : CCommonGame!
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		
		let skView = self.view as! SKView
//		skView.showsFPS = true
//		skView.showsNodeCount = true
		/* Sprite Kit applies additional optimizations to improve rendering performance */
		skView.ignoresSiblingOrder = true
		
		/* Set the scale mode to scale to fit the window */
		//     scene.scaleMode = .AspectFill
		
		//   skView.presentScene(scene)
		
//		let game = CGame(viewController: self)
		
	}

	public func setGame(lpGame : CCommonGame )
	{
		m_game = lpGame
		(UIApplication.sharedApplication().delegate as! CCommonAppDelegate).setGame(lpGame)
	}
	
	//
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
	
	
	public func showBanner(title:String , message:String)
	{
		GKNotificationBanner.showBannerWithTitle(title, message: message, completionHandler:
			{() -> Void in }
		)
		
	}
	
	public func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
	{
		self.dismissViewControllerAnimated(true, completion: nil)
		m_game.inGameCenter(false)
	}
	
	override public func shouldAutorotate() -> Bool {
		return true
	}
	
	override public func supportedInterfaceOrientations() -> Int {
		if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
			return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
		} else {
			return Int(UIInterfaceOrientationMask.All.rawValue)
		}
	}
	
	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
	
	override public func prefersStatusBarHidden() -> Bool {
		return true
	}

	public func checkTweetOk() -> Bool
	{
		return SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
	}
	
	public func tweet(text:String , images:[UIImage] , urls:[NSURL])
	{
		if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
		{
			var viewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
			
			
			viewController.completionHandler =
				{
					(result:SLComposeViewControllerResult) -> Void in
					
					if result == SLComposeViewControllerResult.Done
					{
					//	println("Done")
					}
					
					if result == SLComposeViewControllerResult.Cancelled
					{
					//	println("Cancel")
					}
					
					self.dismissViewControllerAnimated(true, completion: nil)
			}
			
			
			viewController.setInitialText(text)
			
			for image in images
			{
				viewController.addImage(image)
			}
			
			for url in urls
			{
				viewController.addURL(url)
			}
			
			
			self.presentViewController(viewController, animated: true, completion: nil)
		}
	}
	
}
