//
//  OALData.h
//  TinyanLib
//
//  Created by Tinyan on 10/05/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <OpenAL/al.h>
#import <OpenAL/alc.h>

#import <AudioToolbox/AudioToolbox.h>

//#import "OALModel.h"
#import "OAL3DVector.h"

@interface OALData : NSObject {
	//OALModel	*model;
	
	OAL3DVector	*position;
	OAL3DVector	*velocity;
	OAL3DVector	*direction;
	
	unsigned int	alSourceID;
	unsigned int	alBufferID;
	
	BOOL			isLoaded;		
}

@property (readonly) BOOL isLoaded;
@property (readwrite, getter=isLooped) BOOL looped;
@property (readonly) BOOL isPlaying;
@property (readwrite, assign) OAL3DVector *position;
@property (readwrite, assign) OAL3DVector *velocity;
@property (readwrite, assign) OAL3DVector *direction;

- (id) initWithFile: (NSString *) filename ofType: (NSString *) extension;

- (void) loadFile: (NSString *) filename ofType: (NSString *) extension;

- (void) setPosition: (float) x : (float) y : (float) z;
- (void) setDirection: (float) x : (float) y : (float) z;
- (void) setVelocity: (float) x : (float) y : (float) z;

- (void) setReferenceDistance: (float) dist;

- (void) play;
- (void) stop;
- (BOOL) isPlaying;

- (void) setLooped: (BOOL) looped;
- (BOOL) isLooped;

- (void) setVolume: (float) vol;
- (float) volume;

@end
