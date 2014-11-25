//
//  OAL3DVector.m
//  TinyanLib
//
//  Created by Tinyan on 10/05/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OAL3DVector.h"


@implementation OAL3DVector


@synthesize vec = m_vec;

-(id)init
{
	if ((self = [super init]))
	{
		m_vec = (float*)malloc(sizeof(float)*3);
		[self set:0:0:0];
	}
	return self;
}

- (id) init:(float)_x :(float)_y :(float)_z 
{
	if ((self = [super init]))
	{
		[self set:_x:_y:_z];
	}
	return self;
}


- (void) set: (float) _x : (float) _y : (float) _z 
{
	m_vec[0] = _x;
	m_vec[1] = _y;
	m_vec[2] = _z;
}

- (void) set: (OAL3DVector *) vector
{
	m_vec[0] = [vector x];
	m_vec[1] = [vector y];
	m_vec[2] = [vector z];
}

- (void) normalize
{
	float sum = 0.0;
	for (int i = 0;i <3 ;i++)
	{
		sum += m_vec[i] * m_vec[i];
	}
	
	float scale = sqrt(sum);
	if (scale > 0.0)
	{
		m_vec[0] /= scale;
		m_vec[1] /= scale;
		m_vec[2] /= scale;
	}
}



- (void) rotateZ: (float) radian
{
	float _x	= m_vec[0] * cos(radian) - m_vec[1] * sin(radian);
	float _y	= m_vec[0] * sin(radian) + m_vec[1] * cos(radian);
	m_vec[0]		= _x;
	m_vec[1]		= _y;
}


- (float) distanceFrom: (OAL3DVector *) vector
{	
	float dx = [vector x] - m_vec[0];
	float dy = [vector y] - m_vec[1];
	float dz = [vector z] - m_vec[2];
	return sqrt(dx*dx + dy*dy + dz*dz);
}

-(float)x
{
	return m_vec[0];
}
-(float)y
{
	return m_vec[1];
}
-(float)z
{
	return m_vec[2];
}

-(void)setx:(float)_x
{
	m_vec[0] = _x;
}
-(void)sety:(float)_y
{
	m_vec[1] = _y;
}
-(void)setz:(float)_z
{
	m_vec[2] = _z;
}


- (void) add: (OAL3DVector *) vector
{
	int i;
	for (i = 0; i < 3; i++) m_vec[i] += vector.vec[i];
}

- (void) sub: (OAL3DVector *) vector
{
	int i;
	for (i = 0; i < 3; i++) m_vec[i] -= vector.vec[i];
}

- (void) mul: (float) m
{
	int i;
	for (i = 0; i < 3; i++) m_vec[i] *= m;
}	

- (void) scaleTo: (float) scale
{
	[self normalize];
	[self mul: scale];
}

- (float) scale
{
	int i;
	float sum = 0.0;
	for (i = 0; i < 3; i++) sum += m_vec[i] * m_vec[i];
	return sqrt(sum);
}


- (void) dealloc
{
	free(m_vec);
}





@end
