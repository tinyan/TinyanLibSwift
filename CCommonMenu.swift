//
//  CCommonMenu.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2/23/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

//let COMMON_TOUCH_LAYER : CGFloat = 50.0


public class CCommonMenu : SKSpriteNode
{
	convenience public required init(coder aDecoder: NSCoder)
	{
		self.init(coder:aDecoder)
	}
	
	var m_parent : CCommonGeneral
	var m_buttonNumber = 0
	var m_button : [CCommonButton] = []
	var m_buttonNameList : [String] = []
	var m_buttonSetup : [CCommonButtonSetup] = []
	var m_buttonStart = CGPoint(x:450,y:1300)
	var m_buttonNext = CGVector(dx:0,dy:-300)
	var m_buttonSize = CGSize(width:500,height:250)
	var m_picNumberX = 1
	var m_picNumberY = 1
	var m_commonButtonSound = -1
	var m_buttonFilename : String!
	var m_buttontexture : CCommonSpriteCutter!
	
	
	public init(general : CCommonGeneral,json:CCommonJsonObject,menu:String = "menu")
	{
		m_parent = general
		let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
		var size = CGSize(width:1,height:1)
		super.init(texture: nil, color: color, size: size)
	
		if var list: AnyObject = json.getAnyObject(keyList: menu,"buttonList")
		{
			var buttonList = list as! [String]
			m_buttonNameList = buttonList
			m_buttonNumber = buttonList.count
			m_picNumberY = m_buttonNumber
		}
		
		if var start : CGPoint = json.getObject(keyList: menu,"start")
		{
			var buttonStart = start
		}
		
		if var next : CGVector = json.getObject(keyList: menu,"next")
		{
			var buttonNext = next
		}
		
		if var size : CGSize = json.getObject(keyList: menu,"size")
		{
			m_buttonSize = size
		}
		
		if var filename : String = json.getObject(keyList: menu,"filename")
		{
			m_buttonFilename = filename
		}
		
		if var sound : Int = json.getObject(keyList: menu,"sound")
		{
			m_commonButtonSound = sound
		}
		
		if var picNumber : [Int] = json.getArrayObject(keyList: menu, "picNumber")
		{
			if picNumber.count > 0
			{
				m_picNumberX = picNumber[0];
			}
			if picNumber.count > 1
			{
				m_picNumberY = picNumber[1];
			}
		}
		
		
		for i in 0 ..< m_buttonNumber
		{
			var setup = CCommonButtonSetup(json: json, buttonName: m_buttonNameList[i])
			m_buttonSetup.append(setup)

			
			
			
		}
		
		if m_buttonFilename != nil
		{
			m_buttontexture = CCommonSpriteCutter(filename: m_buttonFilename, x: m_picNumberX, y: m_picNumberY)
		}
		
		
		createAllButton([])
//		userInteractionEnabled = true
	}
	
	public func createAllButton(status:[Int])
	{
		removeAllChildren()
		m_button = []
		
		for i in 0 ..< m_buttonNumber
		{
			var setup = m_buttonSetup[i]
			var buttonSize = m_buttonSize
			var buttonPoint = m_buttonStart
			buttonPoint.x += m_buttonNext.dx * CGFloat(i)
			buttonPoint.y += m_buttonNext.dy * CGFloat(i)
			var sound = m_commonButtonSound
			
			
			//change by setup
			
			if var point = setup.m_point
			{
				buttonPoint = point
			}
			
			if var sz = setup.m_size
			{
				buttonSize = sz
			}
			
			if var snd = setup.m_sound
			{
				sound = snd
			}

			
			
			var texture : SKTexture! = nil
			if m_buttontexture != nil
			{
				var nx = 0
				if i < status.count
				{
					nx = status[i]
				}
				var ny = i
				
				texture = m_buttontexture.cutSprite(x: nx, y: ny)
			}
			
			
			var button = CCommonButton(general: m_parent, texture: texture, size: buttonSize)
			button.setNumber(i)
			button.position = buttonPoint
			button.zPosition = COMMON_BUTTON_LAYER_Z
			button.m_sound = sound
			
			m_button.append(button)
			self.addChild(button)
		}
	}
	
}

