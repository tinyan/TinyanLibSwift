//
//  OALControl.m
//  TinyanLib
//
//  Created by たいにゃん on 10/05/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OALControl.h"
#import "OAL3DVector.h"

#define		DEFAULT_VOLUME	 1.0		// デフォルトのボチューム

// オーディオデータをロードするための関数
void* GetOpenALAudioData(CFURLRef inFileURL, NSString* extension,ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate);


@implementation OALControl


- (id) init
{
	if (self = [super init]) 
	{
		listenerPos		= [[OAL3DVector alloc] init];		// Position
		listenerFace	= [[OAL3DVector alloc] init];		// Forward Vector
		listenerUp		= [[OAL3DVector alloc] init];		// Up Vector

		BOOL b = [self initOpenAL];
        if (!b)
        {
            //
        }
	}
	return self;
}


- (BOOL) initOpenAL
{
	ALCcontext		*context	= NULL;
	ALCdevice		*device		= NULL;
	
	// 新しいOpenALのデバイスを開く
	// 引数NULLはデフォルトの音声出力を使うことを意味する
	device = alcOpenDevice(NULL);
	if (device != NULL){
		// OpenALコンテキストを作る
		// 上で作ったOpenALデバイスに出力される (二つ目の引数でコンテキストの属性を指定する)
		context = alcCreateContext(device, 0);
		if (context != NULL){
			// 作ったコンテキストをアクティブにする
			alcMakeContextCurrent(context);
		} else {
			NSLog(@"Failed to create a new OpenAL Context");
			return NO;
		}
	} else {
		NSLog(@"Failed to create a new OpenAL Device");
		return NO;
	}
	
	// Clear Error Code 
	alGetError();
	
	// リスナーの位置と方向を設定する。
	[self setListenerPosition: 0 : 0 : 0];
	[self setListenerFace: 0 : 1 : 0 up: 0 : 0 : 1];
#ifdef DEBUG	
	NSLog(@"Init Done");
#endif
	return YES;
}


- (void) setListenerPosition: (float) x : (float) y : (float) z
{
	[listenerPos	set: x : y : z];
	
	//set current listener position
	alListener3f(AL_POSITION, x, y, z);
}

- (void) setListenerPosition: (OAL3DVector *) vec
{
	[listenerPos	set: vec];
	
	//set current listener position
	alListenerfv(AL_POSITION, listenerPos.vec);
}



- (void) setListenerFace: (float) fx : (float) fy : (float) fz up: (float) ux : (float) uy : (float) uz
{
	[listenerFace	set: fx : fy : fz];
	[listenerUp		set: ux : uy : uz];
	
	float vec[6];
	vec[0] = fx;	//forward vector x value
	vec[1] = fy;	//forward vector y value
	vec[2] = fz;	//forward vector z value
	vec[3] = ux;	//up vector x value
	vec[4] = uy;	//up vector y value
	vec[5] = uz;	//up vector z value
	
	//set current listener orientation
	alListenerfv(AL_ORIENTATION, vec);
}

- (void) setListenerFace: (OAL3DVector *)face up: (OAL3DVector *)up
{
	[listenerFace	set: face];
	[listenerUp		set: up];
	
	float vec[6];
	vec[0] = face.x;	//forward vector x value
	vec[1] = face.y;	//forward vector y value
	vec[2] = face.z;	//forward vector z value
	vec[3] = up.x;		//up vector x value
	vec[4] = up.y;		//up vector y value
	vec[5] = up.z;		//up vector z value
	
	//set current listener orientation
	alListenerfv(AL_ORIENTATION, vec);
}

- (void) moveListenerForward: (float) dist
{
	OAL3DVector *face	= [listenerFace copy];
	[face scaleTo: dist];
	[listenerPos add: face];	
	[self setListenerPosition: listenerPos];
//	[face release];
}

- (void) rotateListener: (float) degree
{
	float rad = degree * M_PI / 180.0;
	[listenerFace rotateZ:rad];
	[self setListenerFace: listenerFace	up: listenerUp];
}


- (void) dealloc
{
	//Get active context
	ALCcontext *Context = alcGetCurrentContext();
	
	//Get device for active context
	ALCdevice *Device = alcGetContextsDevice(Context);
	
	//Disable context
	alcMakeContextCurrent(NULL);
	
	//Release context(s)
	alcDestroyContext(Context);
	
	//Close device
	alcCloseDevice(Device);
	
//	[listenerPos release]; [listenerFace release]; [listenerUp release];
//	[super dealloc];
}





@end
