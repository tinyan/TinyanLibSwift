//
//  CCommonSoundControl.swift
//  TinyanLibSwift
//
//  Created by たいにゃん on 2014/08/24.
//  Copyright (c) 2014年 bugnekosoft. All rights reserved.
//

import Foundation


let MY_OAL_SOUND_MAX = 256

public class CCommonSoundControl
{
	var m_soundMax : Int
	
	var m_openALControl : OALControl?
	var m_openALData = [OALData?](count: MY_OAL_SOUND_MAX, repeatedValue: nil)
	
	public init()
	{
		m_soundMax = MY_OAL_SOUND_MAX
		m_openALControl = OALControl()
	}
	
	public func loadAiff(n : Int , name : String) -> Bool
	{
		return self.load(n , name:name , ofType:"aiff")
	}
	
	public func load(n : Int , name : String , ofType : String) -> Bool
	{
		if (n < 0) || (n >= m_soundMax) {return false}
		
		if m_openALData[n] != nil {return false}
		
		m_openALData[n] = OALData(file: name , ofType : ofType)
		
		return true
	}
	
	public func setPositon(n : Int , position : [Float])
	{
		if (n>=0) && (n<m_soundMax)
		{
			m_openALData[n]?.setPosition(position[0]  ,position[1]  ,position[2])
		}
	}
	
	
	public func setVolume(n : Int , volume : Float)
	{
		if (n>=0) && (n<m_soundMax)
		{
			m_openALData[n]?.setVolume(volume)
		}
	}
	
	public func play(n : Int)
	{
		if (n>=0) && (n<m_soundMax)
		{
			m_openALData[n]?.play()
		}
	}
	
	public func stop(n : Int)
	{
		if (n>=0) && (n<m_soundMax)
		{
			m_openALData[n]?.stop()
		}
	}
	
}

