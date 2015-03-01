//
//  CCommonMessage.swift
//  TinyanLibSwift
//
//  Created by Tinayn on 1/24/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


public class CCommonMessage64 : SKSpriteNode
{
	var m_fontSize : CGSize = CGSize(width: 16, height: 16)
	var m_font : CCommonSpriteCutter
	
	convenience public required init(coder aDecoder: NSCoder)
	{
		self.init(coder:aDecoder)
	}

	
	public init(size:CGSize , font:CCommonSpriteCutter)
	{
		let color = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.0)
		m_font = font
		super.init(texture: nil, color: color, size: CGSize(width: 1, height: 1))
		m_fontSize = size
	}
	
	public func print(#point:CGPoint , mes:String , center:Bool = false)
	{
		self.removeAllChildren()
		
		var x:CGFloat = 0
		var y:CGFloat = 0

		if (center)
		{
//			var ln = mes.utf16Count
//			var ln = count(mes)
			var ln = countElements(mes)
			var delta = CGFloat(ln-1) * 0.5
			x -= delta * m_fontSize.width
//			y -= 0.5 * m_fontSize.height
		}
		
		for c in mes.utf8
		{
			var d = Int(c)
			d -= 0x20
			d &= 0x3f

			var nx = d % 8
			var ny = d / 8
			var texture = m_font.cutSprite(x: nx, y: ny)
			var spr = SKSpriteNode(texture: texture, size: m_fontSize)
			spr.position = CGPoint(x:x , y:y)
			self.addChild(spr)
			
			x += m_fontSize.width
		}
		
		self.position = point
	}
}
