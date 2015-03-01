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

public class CCommonOtherApp : CCommonGeneral
{
	convenience required public init(coder aDecoder: NSCoder)
	{
		self.init(coder:aDecoder)
	}
	
	
	override public init(modeNumber:Int , game : CCommonGame, size:CGSize)
	{
		super.init(modeNumber:modeNumber , game:game , size: size)

		m_bgColorRed = 0.1
		m_bgColorGreen = 0.1
		m_bgColorBlue = 0.9
		m_bgColorAlpha = 1.0
		
		if var json = CCommonJsonObject.loadByFilename("init/otherapp")
		{
			getViewParam(json)
		}
		
		self.backgroundColor = UIColor(red: m_bgColorRed, green: m_bgColorGreen, blue: m_bgColorBlue, alpha: m_bgColorAlpha)
		scaleMode = .AspectFit
		
	}
	
	public override func EnterMode()
	{
		super.EnterMode()
	}
	
	public override func ExitMode()
	{
		super.ExitMode()
	}
	
	public override func onUpdate(currentTime: CFTimeInterval)
	{
		super.onUpdate(currentTime)
	}

	
}