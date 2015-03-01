//
//  CCommonJsonObject.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2/18/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameKit

public class CCommonJsonObject
{
	init()
	{
	}
	
	public var m_json : AnyObject! = nil
	public var m_errorPrintFlag = false
	
	public class func loadByFilename(filename:String,ofType:String = "json",errorPrintFlag:Bool = false) -> CCommonJsonObject?
	{
		if let path : String = NSBundle.mainBundle().pathForResource(filename, ofType: ofType)
		{
			if let fileHandle : NSFileHandle = NSFileHandle(forReadingAtPath: path)
			{
				let data : NSData = fileHandle.readDataToEndOfFile()
				
				if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
				{
					var myClass = CCommonJsonObject()
					myClass.m_json = jsonObject
					myClass.m_errorPrintFlag = errorPrintFlag
					return myClass
				}
				else
				{
					if errorPrintFlag
					{
						println("no json data:\(filename)")
					}
				}
			}
			else
			{
				if errorPrintFlag
				{
					println("file handle error:\(filename)")
				}
			}
		}
		else
		{
			if errorPrintFlag
			{
				println("path error:\(filename).\(ofType)")
			}
		}
		
	
		return nil
	}
	
	/*
	public func getAnyObject(name:String) -> AnyObject?
	{
		if m_json != nil
		{
			return m_json!.valueForKey(name)
		}
		
		return nil
	}
	*/
	
	public func getObject<T>(name:String) -> T?
	{
		if var obj : AnyObject = getAnyObject(name)
		{
			return obj as? T
		}

		return nil
	}

	public func getObject<T>(keyArray:[String]) -> T?
	{
		if var obj : AnyObject = getAnyObject(keyArray)
		{
			return obj as? T
		}
		return nil
	}
	
	public func getObject<T>(#keyList:String...) -> T?
	{
		if var obj : AnyObject = getAnyObject(keyList)
		{
			return obj as? T
		}
		return nil
	}
	
	
	public func getArrayObject<T>(name:String) -> [T]?
	{
		var nameArray = name.componentsSeparatedByString(".")
		return getArrayObject(nameArray)
	}
	
	public func getArrayObject<T>(keyArray:[String]) -> [T]?
	{
		if var obj : AnyObject = getAnyObject(keyArray)
		{
			var p = obj as! [AnyObject]
			if p.count > 0
			{
				var ret : [T] = []
				for i  in 0 ..< p.count
				{
					ret.append(p[i] as! T)
				}
				return ret
			}
		}
		return nil
	}
	
	public func getArrayObject<T>(#keyList:String...) -> [T]?
	{
		return getArrayObject(keyList)
	}
	
	
	
	
	public func getCGVectorObject(name:String) -> CGVector?
	{
		if var point = getCGPointObject(name)
		{
			return CGVector(dx:point.x,dy:point.y)
		}
		
		return nil
	}

	public func getCGVectorObject(keyArray:[String]) -> CGVector?
	{
		if var point = getCGPointObject(keyArray)
		{
			return CGVector(dx:point.x,dy:point.y)
		}
		return nil
	}
	
	public func getCGVectorObject(#keyList:String...) -> CGVector?
	{
		if var point = getCGPointObject(keyList)
		{
			return CGVector(dx:point.x,dy:point.y)
		}
		return nil
	}
	

	public func getCGSizeObject(name:String) -> CGSize?
	{
		if var point = getCGPointObject(name)
		{
			return CGSize(width:point.x,height:point.y)
		}
		return nil
	}
	
	public func getCGSizeObject(keyArray:[String]) -> CGSize?
	{
		if var point = getCGPointObject(keyArray)
		{
			return CGSize(width:point.x,height:point.y)
		}
		return nil
	}
	
	public func getCGSizeObject(#keyList:String...) -> CGSize?
	{
		if var point = getCGPointObject(keyList)
		{
			return CGSize(width:point.x,height:point.y)
		}
		return nil
	}
	
	
	
	public func getCGPointObject(name:String) -> CGPoint?
	{
		if var obj: AnyObject = getAnyObject(name)
		{
			var p = obj as! [Int]
			if p.count < 2
			{
				return nil
			}
				
			return CGPoint(x:p[0],y:p[1])
		}
		
		return nil
	}
	
	public func getCGPointObject(keyArray:[String]) -> CGPoint?
	{
		if var obj: AnyObject = getAnyObject(keyArray)
		{
			var p = obj as! [Int]
			if p.count < 2
			{
				return nil
			}
			
			return CGPoint(x:p[0],y:p[1])
		}
		
		return nil
	}
	
	
	
	public func getCGPointObject(#keyList:String...) -> CGPoint?
	{
		if var obj: AnyObject = getAnyObject(keyList)
		{
			var p = obj as! [Int]
			if p.count < 2
			{
				return nil
			}
			
			return CGPoint(x:p[0],y:p[1])
		}
		
		return nil
	}
	

	//common
	
	public func getAnyObject(keyArray:[String]) -> AnyObject?
	{
		if m_json != nil
		{
			var k = 0
			if keyArray.count > 0
			{
				if var obj: AnyObject = m_json!.valueForKey(keyArray[k])
				{
					k++
					while k < keyArray.count
					{
						if var subObj : AnyObject = obj.valueForKey(keyArray[k])
						{
							obj = subObj
						}
						else
						{
							if m_errorPrintFlag
							{
								println("not found json name list[\(k)]:\(keyArray[k])")
							}
							return nil
						}
						
						k++
					}
					
					return obj
				}
				else
				{
					if m_errorPrintFlag
					{
						println("not found json name top:\(keyArray[k])")
					}
				}
			}
		}
		
		return nil
	}

	public func getAnyObject(#keyList:String...) -> AnyObject?
	{
		return getAnyObject(keyList)
	}
	
	public func getAnyObject(keys:String) -> AnyObject?
	{
		var keyArray = keys.componentsSeparatedByString(".")
		return getAnyObject(keyArray)
	}
	
}
