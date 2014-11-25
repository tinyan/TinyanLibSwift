//
//  OALData.m
//  TinyanLib
//
//  Created by Tinyan on 10/05/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OALData.h"





#define		DEFAULT_VOLUME	 1.0


void* GetOpenALAudioData(CFURLRef inFileURL, NSString* extension,ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate);

@implementation OALData

@synthesize isLoaded;
@dynamic	position;
@dynamic	velocity;
@dynamic	direction;


- (id) init
{
	self = [super init];
	if (self != nil) {

		

		position	= [[OAL3DVector alloc] init];
		velocity	= [[OAL3DVector alloc] init];
		direction	= [[OAL3DVector alloc] init];
	}
	return self;
}


- (id) initWithFile: (NSString *) filename ofType: (NSString *) extension
{
	self	= [self init];
	if (self != nil) {		

		[self loadFile: filename ofType: extension];
		

		[self setVolume: DEFAULT_VOLUME];
	}
	return self;
}


- (void) loadFile: (NSString *) filename ofType: (NSString *) extension
{
	char*	alBuffer;            //data for the buffer
	ALenum	alFormatBuffer;     //for the buffer format
	ALsizei alFreqBuffer;      //for the frequency of the buffer
	ALsizei alBufferLen;          //the bit depth
	

	NSString* path		= [[NSBundle mainBundle] pathForResource: filename ofType: extension];
	if (path == nil){
		return;
	}
	
	const char *fpath	= [path cStringUsingEncoding: NSUTF8StringEncoding];
	CFURLRef fileURL	= CFURLCreateFromFileSystemRepresentation (NULL, (const UInt8 *)fpath, strlen(fpath), false);
	alBuffer = GetOpenALAudioData(fileURL, extension,&alBufferLen, &alFormatBuffer, &alFreqBuffer);
	CFRelease(fileURL);
	if (alBuffer == NULL) return;
	

	alGenSources(1, &alSourceID);
	

	alGenBuffers(1, &alBufferID);
	

	alBufferData(alBufferID, alFormatBuffer, alBuffer, alBufferLen, alFreqBuffer);
	ALenum err = alGetError();
	if (err == AL_OUT_OF_MEMORY)
	{
	}
	else if (err == AL_INVALID_VALUE)
	{
	}
	

	alSourcei(alSourceID, AL_BUFFER, alBufferID);
	

	alSourcef(alSourceID, AL_REFERENCE_DISTANCE, 25.0f);
	

	[self setPosition: 0 : 0 : 0];
	

	isLoaded	= YES;
}


- (void) dealloc
{	
	if (isLoaded){

		alSourceStop(alSourceID);
		

		alDeleteSources(1, &alSourceID);
		

		alDeleteBuffers(1, &alBufferID);
	}
	

}





- (void) setPosition: (float) x : (float) y : (float) z
{
	[position set: x : y: z];
	

	alSource3f(alSourceID, AL_POSITION, x, y, z);
}

- (void) setPosition: (OAL3DVector *) vector
{
	[self setPosition: vector.x : vector.y : vector.z];
}

- (OAL3DVector *) position { return position; }



- (void) setVelocity: (float) x : (float) y : (float) z
{
	[velocity set: x : y: z];
	
	alSource3f(alSourceID, AL_VELOCITY, x, y, z);
}

- (void) setVelocity: (OAL3DVector *) vector
{
	[self setVelocity: vector.x : vector.y: vector.z];
}

- (OAL3DVector *) velocity { return velocity; }



- (void) setDirection: (OAL3DVector *) vector
{
	[self setDirection: vector.x : vector.y : vector.z];
}

- (void) setDirection: (float) x : (float) y : (float) z
{
	[direction set: x : y: z];
	
	alSource3f(alSourceID, AL_DIRECTION, x, y, z);
}

- (OAL3DVector *) direction { return direction; }


- (void) play {
	alSourcePlay(alSourceID);	
}

- (void) stop
{
	alSourceStop(alSourceID);
}

- (BOOL) isPlaying
{
	int playing; 
	alGetSourcei(alSourceID, AL_SOURCE_STATE, &playing);
	return (BOOL)(playing == AL_PLAYING);
}

- (void) setLooped: (BOOL) looped
{
	//tell the sound to loop continuously
	if (looped) alSourcei(alSourceID, AL_LOOPING, AL_TRUE);
	else alSourcei(alSourceID, AL_LOOPING, AL_FALSE);
}

- (BOOL) isLooped
{
	int looped; 
	alGetSourcei(alSourceID, AL_LOOPING, &looped);
	return (BOOL)looped;
}

- (void) setVolume: (float) vol
{
	alSourcef(alSourceID, AL_GAIN, vol);
}

- (float) volume
{
	ALfloat vol; 
	alGetSourcef(alSourceID, AL_LOOPING, &vol);
	return (float)vol;
}


- (void) setReferenceDistance: (float) dist
{
	// Set Source Reference Distance
	alSourcef(alSourceID, AL_REFERENCE_DISTANCE, dist);
}



@end



void* GetOpenALAudioData(CFURLRef inFileURL, NSString* extension,ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate)
{
	OSStatus						err = noErr;	
	AudioStreamBasicDescription		fileFormat;
	AudioStreamBasicDescription		outputFormat;
	AudioFileID						audioFileID;
	
	void*							theData = NULL;	
	
	// Open the File
	int types = kAudioFileAIFFType;
	if ([extension isEqualToString:@"wav"])
	{
		types = kAudioFileWAVEType;
	}
	
	err	=	AudioFileOpenURL ( inFileURL,
							  0x01, //fsRdPerm,						// read only
							  //							  kAudioFileWAVEType, &audioFileID);
							  types, &audioFileID);
	//							  kAudioFileM4AType, &audioFileID);
	
	
	
	
	if (err) { printf("GetOpenALAudioData: AudioFileOpenURL FAILED, Error = %d\n", (int)err); goto Exit; }
	
	UInt32 sizeOfASBD					= sizeof (fileFormat);
	
	// Get the AudioStreamBasicDescription format for the playback file
	AudioFileGetProperty (audioFileID,  kAudioFilePropertyDataFormat,
						  &sizeOfASBD, &fileFormat);
	if(err) { printf("GetOpenALAudioData: AudioFileGetProperty FAILED, Error = %d\n", (int)err); goto Exit; }
	if (fileFormat.mChannelsPerFrame > 2)  { printf("GetOpenALAudioData - Unsupported Format, channel count is greater than stereo\n"); goto Exit;}
	
	
	int channel = fileFormat.mChannelsPerFrame;
	int bitsPerChannel = fileFormat.mBitsPerChannel;
	
	// Set the client format to 16 bit signed integer (native-endian) data
	// Maintain the channel count and sample rate of the original source format
	outputFormat.mSampleRate = fileFormat.mSampleRate;
	outputFormat.mChannelsPerFrame = channel;
	
	outputFormat.mFormatID = kAudioFormatLinearPCM;
	outputFormat.mBytesPerPacket = (bitsPerChannel / 8) * channel;
	outputFormat.mFramesPerPacket = 1;
	
	outputFormat.mBytesPerFrame = (bitsPerChannel / 8) * channel;
	outputFormat.mBitsPerChannel = bitsPerChannel;
	outputFormat.mFormatFlags = fileFormat.mFormatFlags;
	
	//outputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
	
	//Set the desired client (output) data format
	//	err	= AudioFileSetProperty(audioFileID, kAudioFilePropertyDataFormat, sizeOfASBD, &outputFormat);
	//	if(err) { printf("GetOpenALAudioData: AudioFileSetProperty(kAudioFilePropertyDataFormat) FAILED, Error = %ld\n", err); goto Exit; }
	
	// Get the total frame count	
	SInt64	fileLengthInFrames	= 0;
	UInt32	propertySize		= sizeof(fileLengthInFrames);
	err = AudioFileGetProperty(audioFileID, kAudioFilePropertyAudioDataPacketCount, &propertySize, &fileLengthInFrames);
	if(err) { printf("GetOpenALAudioData: AudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %d\n", (int)err); goto Exit; }
	
	// Read all the data into memory
	UInt32		dataSize	= (UInt32)(fileLengthInFrames * outputFormat.mBytesPerFrame);
	theData					= malloc(dataSize);
	if (theData)
	{
		AudioBufferList		theDataBuffer;
		theDataBuffer.mNumberBuffers = 1;
		theDataBuffer.mBuffers[0].mDataByteSize = dataSize;
		theDataBuffer.mBuffers[0].mNumberChannels = outputFormat.mChannelsPerFrame;
		theDataBuffer.mBuffers[0].mData = theData;
		
		// Read the data into an AudioBufferList
		err = AudioFileReadBytes( audioFileID, false, 0, &dataSize, theData); 
		// ExtAudioFileRead(extRef, (UInt32*)&theFileLengthInFrames, &theDataBuffer);
		if(err == noErr)
		{
			if (types == kAudioFileAIFFType)
			{
				
				char* ptr = (char*)theData;
				for (int i=0;i<dataSize;i+=2)
				{
					char c1 = *ptr;
					char c2 = *(ptr+1);
					*ptr = c2;
					*(ptr+1) = c1;
					ptr += 2;
					
				}
			}
			
			
			// success
			*outDataSize = (ALsizei)dataSize;
			*outDataFormat = (outputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
			*outSampleRate = (ALsizei)outputFormat.mSampleRate;
		}
		else 
		{ 
			// failure
			free (theData);
			theData = NULL; // make sure to return NULL
			printf("GetOpenALAudioData: AudioFileReadBytes FAILED, Error = %d\n", (int)err); goto Exit;
		}	
	}
	
Exit:
	// Dispose the ExtAudioFileRef, it is no longer needed
	if (audioFileID) AudioFileClose(audioFileID);
	return theData;
}


