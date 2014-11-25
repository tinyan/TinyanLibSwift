//
//  OAL3DVector.h
//  TinyanLib
//
//  Created by Tinyan on 10/05/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface OAL3DVector : NSObject 
{
	float* m_vec;
    float x,y,z;
}

@property float* vec;


- (id) init;
- (id) init: (float) _x : (float) _y : (float) _z;

- (void) set: (float) _x : (float) _y : (float) _z;
- (void) set: (OAL3DVector *) vector;

- (void) normalize;
- (float) distanceFrom: (OAL3DVector *) vector;

- (void) add: (OAL3DVector *) vector;
- (void) sub: (OAL3DVector *) vector;
- (void) mul: (float) m;
- (void) scaleTo: (float) scale;
- (float) scale;

-(float)x;
-(float)y;
-(float)z;

-(void)setx:(float)_x;
-(void)sety:(float)_y;
-(void)setz:(float)_z;

- (void) rotateZ: (float) radian;

@end
