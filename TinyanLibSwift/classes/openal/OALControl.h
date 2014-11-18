//
//  OALControl.h
//  TinyanLib
//
//  Created by Tinyan on 10/05/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenAL/al.h>
#import <OpenAL/alc.h>

#import <AudioToolbox/AudioToolbox.h>


@class OAL3DVector;



@interface OALControl : NSObject 
{
	BOOL		isInited;
	OAL3DVector	*listenerPos, *listenerFace, *listenerUp;
}

-(id)init;
-(BOOL)initOpenAL;

- (void) setListenerPosition: (float) x : (float) y : (float) z;
- (void) setListenerPosition: (OAL3DVector *) vec;
- (void) setListenerFace: (float) fx : (float) fy : (float) fz up: (float) ux : (float) uy : (float) uz;
- (void) setListenerFace: (OAL3DVector *) face up: (OAL3DVector *) up;

- (void) moveListenerForward: (float) dist;
- (void) rotateListener: (float) degree;

-(void)dealloc;



@end
