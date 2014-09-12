//
//  CCommonUserData.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2014/09/11.
//  Copyright (c) 2014年 bugnekosoft. All rights reserved.
//

import Foundation
//import UIKit





class CCommonUserData
{
	var m_filename : String?
	var m_data  = [String : Int]()
	var m_dataExistFlag = false
	
	init(filename : String)
	{
		m_filename = filename
	}
	
	
	func addName(name : String)
	{
		if m_data[name] != nil
		{
			m_data[name] = 0
		}
	}
	
	
	func addNames(names : [String])
	{
		for name in names
		{
			self.addName(name)
		}
	}
	
	
	func loadData() -> Bool
	{

		let paths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory , .UserDomainMask,true)
		
		if let path = paths[0] as? String
		{
			var fullfilename = path + "/" + m_filename!
			let data = NSKeyedUnarchiver.unarchiveObjectWithFile(fullfilename) as [String : Int]
			
			for (key,value) in data
			{
				m_data[key] = value
			}
			m_dataExistFlag = true
			return true
		}
	
		return false
	}
	
	func saveData() -> Bool
	{
		let paths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory , .UserDomainMask,true)
		
		if let path = paths[0] as? String
		{
			var fullfilename = path + "/" + m_filename!
			NSKeyedArchiver.archiveRootObject(m_data, toFile: fullfilename)
			return true
		}

		return false
	}
	
	func getData(name : String) -> Int
	{
		if (m_data[name] != nil)
		{
			return m_data[name]!
		}
		
		return 0
	}
	
	
	func setData(name : String , data : Int)
	{
		m_data[name] = data
	}
	
	
	func getBoolData(name : String) -> Bool
	{
		var d = self.getData(name)
		if d == 0
		{
			return false
		}
		return true
	}
	
	func setBoolData(name : String , flag : Bool)
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
