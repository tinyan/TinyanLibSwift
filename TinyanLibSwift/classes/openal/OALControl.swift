//
//  OALControl.swift
//  TinyanLibSwift
//
//  Created by たいにゃん on 2014/08/24.
//  Copyright (c) 2014年 bugnekosoft. All rights reserved.
//

import Foundation
import OpenAL


public class OALControl
{
//	var	isInited : Bool
	var listenerPos : OAL3DVector
	var listenerFace : OAL3DVector
	var listenerUp : OAL3DVector
	
	init()
	{
		listenerPos = OAL3DVector()
		listenerFace = OAL3DVector()
		listenerUp = OAL3DVector()
		
		myInitOpenAL()
	}
	
	func myInitOpenAL() -> Bool
	{
		alGetError()
		
		var context : ALCContext
		return true
	}
	
}