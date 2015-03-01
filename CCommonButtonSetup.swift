//
//  CCommonButtonSetup.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2/23/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


public class CCommonButtonSetup
{
	public var m_point : CGPoint!
	public var m_size :  CGSize!
	public var m_sound : Int!
	public var m_filename : String!
	public var m_customPicFlag = false
	
	public init(json:CCommonJsonObject,buttonName:String="button")
	{
		if var point = json.getCGPointObject(keyList:buttonName,"point")
		{
			m_point = point
		}

		if var buttonSize = json.getCGSizeObject(keyList:buttonName,"size")
		{
			m_size = buttonSize
		}
		
		if var sound : Int = json.getObject(keyList: buttonName,"sound")
		{
			m_sound = sound
		}
		
	}
	
}
