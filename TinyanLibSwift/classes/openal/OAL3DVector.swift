//
//  OAL3DVector.swift
//  TinyanLibSwift
//
//  Created by たいにゃん on 2014/08/24.
//  Copyright (c) 2014年 bugnekosoft. All rights reserved.
//

import Foundation

public class OAL3DVector
{
	var m_vec : [Float] = [1.0 , 0.0 , 0.0]
	
	init()
	{
		self.set(1.0 , y:0.0 , z:0.0)
	}
	
	init(x:Float , y:Float , z:Float)
	{
		self.set(x , y:y , z:z)
	}

	func set(x:Float , y:Float , z:Float)
	{
		m_vec[0] = x
		m_vec[1] = y
		m_vec[2] = z
	}
	
	func set(vector:OAL3DVector)
	{
		m_vec[0] = vector.m_vec[0]
		m_vec[1] = vector.m_vec[1]
		m_vec[2] = vector.m_vec[2]
	}
	
	func normalize()
	{
		var sum : Float = 0.0
		for var i=0;i<3;i++
		{
			sum += m_vec[i] * m_vec[i]
		}
		var scale = sqrt(sum)
		if scale > 0.0
		{
			for var i=0;i<3;i++
			{
				m_vec[i] /= scale
			}
		}
	}
	
	func distanceFrom(vector : OAL3DVector) -> Float
	{
		var dx = vector.m_vec[0] - m_vec[0]
		var dy = vector.m_vec[1] - m_vec[1]
		var dz = vector.m_vec[2] - m_vec[2]
		
		return sqrt(dx*dx + dy*dy + dz*dz);
	}
	
	func add(vector : OAL3DVector)
	{
		for var i=0;i<3;i++
		{
			m_vec[i] += vector.m_vec[i]
			
		}
	}
	
	func sub(vector : OAL3DVector)
	{
		for var i=0;i<3;i++
		{
			m_vec[i] -= vector.m_vec[i]
		}
	}

	func mul(scale : Float)
	{
		for var i=0;i<3;i++
		{
			m_vec[i] *= scale
		}
	}
	
	func scaleTo(scale : Float)
	{
		self.normalize()
		self.mul(scale)
	}
	
	func scale() ->Float
	{
		var sum : Float = 0.0
		for var i=0;i<3;i++
		{
			sum += m_vec[i] * m_vec[i]
		}
		
		return sqrt(sum);
	}
	
	func rotateZ(radian : Float)
	{
		var x = m_vec[0] * cos(radian) - m_vec[1] * sin(radian);
		var y = m_vec[0] * sin(radian) + m_vec[1] * cos(radian);
		m_vec[0]		= x;
		m_vec[1]		= y;
	}
	

}