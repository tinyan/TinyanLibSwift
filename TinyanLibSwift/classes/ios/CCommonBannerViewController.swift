//
//  CCommonBannerViewController.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2014/09/10.
//  Copyright (c) 2014 bugnekosoft. All rights reserved.
//

import Foundation
import iAd

public class CCommonBannerViewController : CCommonViewController , ADBannerViewDelegate
{
	var m_type = 0
	var m_banner : ADBannerView!
	var m_dontPrint = false
	
	
	override public func viewDidLoad()
	{
		super.viewDidLoad()
		mySetup()
	}

	public func viewDidLoadWithType(type:Int)
	{
		m_type = type
		super.viewDidLoad()
		mySetup()
	}

	public func mySetup()
	{
		m_banner = ADBannerView(adType: ADAdType.Banner)
		
		var frame = UIScreen.mainScreen().applicationFrame
		var height :CGFloat = m_banner.frame.size.height
		var width = frame.size.width
		if (self.interfaceOrientation == UIInterfaceOrientation.LandscapeLeft) || (self.interfaceOrientation == UIInterfaceOrientation.LandscapeRight)
		{
			width = frame.size.height
		}
		
		m_banner.frame = CGRectMake(0, -height, frame.size.width, height)
		m_banner.autoresizesSubviews = true
		m_banner.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleBottomMargin
		
		m_banner.hidden = true
		self.view.addSubview(m_banner)
		m_banner.delegate = self
		
		
		
		
		/*
		//	m_banner = [[ADBannerView alloc] initWithFrame:CGRectZero];
		//	m_banner = [[ADBannerView alloc] init];
		m_banner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
		
		CGRect frame = [[UIScreen mainScreen]applicationFrame];
		
		NSString* mylog = [NSString stringWithFormat:@"uiscreen mainscreen %d %d",(int)frame.size.width,(int)frame.size.height];
		[CMyDebugMessage OutputDebugMessage:mylog];
		//	NSLog(@"uiscreen mainscreen %d %d",(int)frame.size.width,(int)frame.size.height);
		
		//	[[UIDevice currentDevice] orientation];
		//	[[UIScreen mainScreen]
		
		
		float height = m_banner.frame.size.height;
		float width = frame.size.width;
		if ((self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight))
		{
		width = frame.size.height;
		
		}
		m_banner.frame = CGRectMake(0,-height,frame.size.width,height);
		
		
		
		m_banner.autoresizesSubviews = YES;
		m_banner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		
		
		
		//m_banner.frame
		
		//	adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
		
		
		m_banner.hidden = YES;
		[self.view addSubview:m_banner];
		[m_banner setDelegate:self];
*/
	}
	
	public func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!)
	{
		banner.hidden = true
	}

	public func bannerViewActionDidFinish(banner: ADBannerView!)
	{
		m_game.oniAd(false)
		//	[CMyDebugMessage OutputDebugMessage:@"banner action finish"];
//		[m_game oniAd:NO];
	}
	
	public func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool
	{
		//	[CMyDebugMessage OutputDebugMessage:@"banner should begin"];
//		[m_game oniAd:YES];
		m_game.oniAd(true)
		return true
	}
	
	override public func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
	{
		super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
	/*
		if (0)
		{
		
		CGSize size = [m_game getDeviceScreenSize];
		int width = size.width;
		int height = size.height;
		
		//	int width = 768;
		BOOL landScape = NO;
		if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) landScape = YES;
		if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) landScape = YES;
		if (landScape)
		{
		int tmp = width;
		width = height;
		height = tmp;
		}
		
		int bannerHeight = m_banner.frame.size.height;
		
		m_banner.frame = CGRectMake(0,height-bannerHeight,width,bannerHeight);
		}
		
		[m_game willRotate:self.interfaceOrientation to:toInterfaceOrientation duration:duration];
*/
	}
	
	
	public func bannerViewDidLoadAd(banner: ADBannerView!)
	{
		var bannerSize = banner.frame.size
		var deviceSize = m_game.GetDeviceScreenSize()
		var height = banner.frame.size.height
		var width = deviceSize.width
		
		
		if (self.interfaceOrientation == UIInterfaceOrientation.LandscapeLeft) || (self.interfaceOrientation == UIInterfaceOrientation.LandscapeRight)
		{
			width = deviceSize.height;
		}
		
		banner.frame = CGRect(x:0,y:-height,width:width,height:height)
//		banner.hidden = false
		banner.hidden = m_dontPrint
		
		UIView.beginAnimations(nil, context: nil)
		banner.frame  = CGRect(x:0,y:0,width:width,height:height)
		UIView.commitAnimations()
		
		
		/*
		//	CGSize bannerSize = banner.frame.size;
		
		CGSize size = [m_game getDeviceScreenSize];
		//float height = m_banner.frame.size.height;
		float height = banner.frame.size.height;
		float width = size.width;
		if ((self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight))
		{
			width = size.height;
		}
		
		//NSLog(@"banner size = %d %d",(int)width,(int)height);
		NSString* myLog = [NSString stringWithFormat:@"banner size = %d %d",(int)width,(int)height];
		[CMyDebugMessage OutputDebugMessage:myLog];
		
		
		
		banner.frame = CGRectMake(0,-height,width,height);
		banner.hidden = NO;
		
		[UIView beginAnimations:NULL context:NULL];
		
		
		banner.frame = CGRectMake(0,0,width,height);
		//	banner.frame = CGRectMake(0,768-66,banner.frame.size.width,banner.frame.size.height);
		//	 banner.frame = CGRectOffset(banner.frame,0,[self.view frame].size.height  -  banner.frame.size.height);
		//	 banner.frame = CGRectMake(0,768-66,1024,banner.frame.size.height);
		[UIView commitAnimations];
		
		[CMyDebugMessage OutputDebugMessage:@"banner loaded"];
*/
	}
	
	public func bannerViewWillLoadAd(banner: ADBannerView!)
	{
		
	}
	
	public func setDontPrint(flag : Bool = true)
	{
		m_dontPrint = flag
	}
	
}