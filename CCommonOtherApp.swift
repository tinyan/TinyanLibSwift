//
//  CCommonOtherApp.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2/18/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

let OTHERAPP_EXIT_BUTTON = 0

public class CCommonOtherApp : CCommonGeneral
{
	convenience required public init(coder aDecoder: NSCoder)
	{
		self.init(coder:aDecoder)
	}
	
	public var m_appName : [String] = []
	public var m_link : [String] = []
	public var m_comment : [[String]] = []
	public var m_picFilename : [String] = []
	public var m_size : [CGSize] = []
	public var m_point : [CGPoint] = []
	public var m_ssPicFilename : [String] = []
	public var m_ssPoint : [CGPoint] = []
	public var m_ssSize : [CGSize] = []
	
	public var m_appButton : [CCommonButton] = []
	
	
	public var m_fontName = "Helvetica-Bold"
	public var m_fontSize : CGFloat = 64.0
	
	public var m_commentFontName = "Helvetica-Bold"
	public var m_commentFontSize : CGFloat = 32.0
	
	public var m_commentPoint = CGPoint(x:500,y:200)
	public var m_commentNext = CGVector(dx:0,dy:-40)
	
	override public init(modeNumber:Int , game : CCommonGame, size:CGSize)
	{
		super.init(modeNumber:modeNumber , game:game , size: size)

		m_bgColorRed = 0.1
		m_bgColorGreen = 0.1
		m_bgColorBlue = 0.9
		m_bgColorAlpha = 1.0
		
		if var json = CCommonJsonObject.loadByFilename("init/otherapp")
		{
			getCommonParam(json)
			m_commonMenu = CCommonMenu(general: self, json: json, menu: "menu")
			self.addChild(m_commonMenu)
			
			if var dummy : AnyObject = json.getAnyObject("common")
			{
				var top = "common"
				getInitParam(json, name: &m_fontName, keyList: top,"fontName")
				getInitParam(json, name: &m_fontSize, keyList: top,"fontSize")
				getInitParam(json, name: &m_commentFontName, keyList: top,"commentFontName")
				getInitParam(json, name: &m_commentFontSize, keyList: top,"commentFontSize")
				
				getInitParam(json, name: &m_commentPoint, keyList: top,"commentPoint")
				getInitParam(json, name: &m_commentNext, keyList: top,"commentNext")
			}
			
			
			getInitArray(json, name: &m_appName, keyList: "applist")
			for i in 0 ..< m_appName.count
			{
				var top = m_appName[i]
				m_link.append("")
				getInitParam(json, name: &m_link[i], keyList: top,"link")
				m_picFilename.append("")
				getInitParam(json,name: &m_picFilename[i], keyList: top,"picFilename")
				m_size.append(CGSize(width: 400, height: 400))
				getInitParam(json, name: &m_size[i], keyList: top,"size")
				m_point.append(CGPoint(x:0,y:0))
				getInitParam(json, name: &m_point[i], keyList: top,"point")
				m_comment.append([])
				getInitArray(json, name: &m_comment[i], keyList: top,"comment")
				m_ssPicFilename.append("")
				getInitParam(json,name: &m_ssPicFilename[i], keyList: top,"ssPicFilename")
				m_ssSize.append(CGSize(width: 400, height: 400))
				getInitParam(json, name: &m_ssSize[i], keyList: top,"ssSize")
				m_ssPoint.append(CGPoint(x:0,y:0))
				getInitParam(json, name: &m_ssPoint[i], keyList: top,"ssPoint")
			}
		}
		
		self.backgroundColor = UIColor(red: m_bgColorRed, green: m_bgColorGreen, blue: m_bgColorBlue, alpha: m_bgColorAlpha)
		scaleMode = .AspectFit
		
	}
	
	public override func EnterMode()
	{
		super.EnterMode()
		createAppButton()
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
			if cmd == OTHERAPP_EXIT_BUTTON
			{
				m_game.changeMode(TITLE_MODE)
			}
			else if cmd != -1
			{
				var app = cmd - 3
				if app >= 0 && app < m_appName.count
				{
					printDebugMessage("url start?")
					if var url = NSURL(string:m_link[app])
					{
						UIApplication.sharedApplication().openURL(url)
					}
					else
					{
						printDebugMessage("url error")
					}
				}
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
					m_commonLastCount = 1
					
//					var tm = 1.0
//					var turnAction = SKAction.rotateByAngle(3.14, duration: tm)
//					var fadeoutAction = SKAction.fadeOutWithDuration(tm)
//					var scaleAction = SKAction.scaleTo(3.0, duration: tm)
//					var groupAction = SKAction.group([turnAction,fadeoutAction,scaleAction])
					
					var button = menu.m_button[number]
					var sound = button.m_sound
					m_game.playSound(sound)
					
//					button.runAction(groupAction)
				}
			}
			
			if number >= 3
			{
				m_commonCommand = number
				m_commonLastCount = 1
				
				//					var tm = 1.0
				//					var turnAction = SKAction.rotateByAngle(3.14, duration: tm)
				//					var fadeoutAction = SKAction.fadeOutWithDuration(tm)
				//					var scaleAction = SKAction.scaleTo(3.0, duration: tm)
				//					var groupAction = SKAction.group([turnAction,fadeoutAction,scaleAction])
				
				var button = m_appButton[number-3]
				var sound = button.m_sound
				m_game.playSound(sound)
				
			}
		}
	}

	public func createAppButton()
	{
		for button in m_appButton
		{
			button.removeFromParent()
		}
		m_appButton = []
		
		
		for i in 0 ..< m_appName.count
		{
			var texture = SKTexture(imageNamed: m_picFilename[i])
			var button = CCommonButton(general: self, texture: texture, size: m_size[i])
			button.position = m_point[i]
			button.setNumber(i+3)
			button.zPosition = COMMON_BUTTON_LAYER_Z
			
			var label = SKLabelNode(text: m_appName[i])
			label.fontName = m_fontName
			label.fontSize = m_fontSize
			label.fontColor = UIColor.cyanColor()
			label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
			label.position = CGPoint(x:0,y:m_size[i].height / 2.0 + m_fontSize / 2.0)
			button.addChild(label)
			
			if m_ssPicFilename[i] != ""
			{
				var ssSprite = SKSpriteNode(imageNamed: m_ssPicFilename[i])
				ssSprite.size = m_ssSize[i]
				ssSprite.position = m_ssPoint[i]
				button.addChild(ssSprite)
			}
			
			//comment
			var commentList = m_comment[i]
			if commentList.count > 0
			{
				for k in 0 ..< commentList.count
				{
					var commentPoint = m_commentPoint
					commentPoint.x += m_commentNext.dx * CGFloat(k)
					commentPoint.y += m_commentNext.dy * CGFloat(k)
					
					var commentLabel = SKLabelNode(text:commentList[k])
					commentLabel.fontName = m_commentFontName
					commentLabel.fontSize = m_commentFontSize
					commentLabel.fontColor = UIColor.cyanColor()
					commentLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Baseline
					commentLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
					commentLabel.position = commentPoint
					button.addChild(commentLabel)
					
					printDebugMessage("comment:\(commentList[k]) \(commentPoint)")
					
				}
			}
			
			
			
			self.addChild(button)
			m_appButton.append(button)
		}
	}
	
}