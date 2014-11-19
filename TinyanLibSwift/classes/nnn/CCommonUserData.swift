//
//  CCommonUserData.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2014/09/11.
//  Copyright (c) 2014 bugnekosoft. All rights reserved.
//

import Foundation
//import UIKit





public class CCommonUserData
{
	var m_filename : String?
	var m_data  = [String : Int]()
	var m_dataExistFlag = false
	
	public init(filename : String)
	{
		m_filename = filename
	}
	
	
	public func addName(name : String)
	{
		if m_data[name] != nil
		{
			m_data[name] = 0
		}
	}
	
	
	public func addNames(names : [String])
	{
		for name in names
		{
			self.addName(name)
		}
	}
	
	
	
	public func loadData() -> Bool
	{

		let paths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory , .UserDomainMask,true)
//		let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory , .UserDomainMask,true)[0] as String
		
	//	NSLog("loaddata:")
	//	NSLog(paths[0] as String)
		
		
		if let path = paths[0] as? String
		{
			
	//		NSLog("loaddata2:")
			
			var fullfilename = path + "/" + m_filename!

			if NSFileManager.defaultManager().fileExistsAtPath(fullfilename)
			{
			
				let data = NSKeyedUnarchiver.unarchiveObjectWithFile(fullfilename) as [String : Int]
			
			//	NSLog("loaddata3:")
			
				for (key,value) in data
				{
					m_data[key] = value
				}
				m_dataExistFlag = true
				return true
			}
		}
	
		return false
	}
	
	public func saveData() -> Bool
	{
		let paths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory , .UserDomainMask,true)
//		let paths : [AnyObject] = NSSearchPathForDirectoriesInDomains(.DocumentDirectory , .UserDomainMask,true)

		if let path = paths[0] as? String
		{
			var fullfilename = path + "/" + m_filename!
			NSKeyedArchiver.archiveRootObject(m_data, toFile: fullfilename)
			return true
		}

		return false
	}
	
	public func getData(name : String) -> Int
	{
		if (m_data[name] != nil)
		{
			return m_data[name]!
		}
		
		return 0
	}
	
	
	public func setData(name : String , data : Int)
	{
		m_data[name] = data
	}
	
	
	public func getBoolData(name : String) -> Bool
	{
		var d = self.getData(name)
		if d == 0
		{
			return false
		}
		return true
	}
	
	public func setBoolData(name : String , flag : Bool)
	{
		if flag
		{
			setData(name , data: 1)
		}
		else
		{
			setData(name , data: 0)
		}
	}
	
	
	
//	func dmy()
//	{
//		var path = "aaa"
//		NSKeyedArchiver.archiveRootObject(m_data, toFile: path)
//	}
	
}
