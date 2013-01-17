//
//  HelloWorldLayer.m
//  ReverseSpriteSheet
//
//  Created by hamdullashah on 17/01/2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "ConversionLayer.h"

#define PLIST_NAME @"AnimBear.plist"
#define FOLDER_NAME @"OutPutImages/"

@interface ConversionLayer ()
-(void) loadPlist;
-(void) startConversion;
-(NSString*) filePathForName:(NSString*) fileName;
-(void) doneCreatingImages;
@end

@implementation ConversionLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ConversionLayer *layer = [ConversionLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Converting Please Wait..." fontName:@"Marker Felt" fontSize:64];
        label.tag = 1001;

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        
        ouputPath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:FOLDER_NAME]];
        
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:ouputPath withIntermediateDirectories:NO attributes:nil error:&error];
	}
	return self;
}

-(void)onEnter
{
    [super onEnter];
    [self loadPlist];
    [self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:1.5] two:[CCCallFunc actionWithTarget:self selector:@selector(startConversion)]]];
}

-(void)loadPlist
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:PLIST_NAME];
}

-(void)startConversion
{
    NSDictionary *frameDic = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[PLIST_NAME stringByReplacingOccurrencesOfString:@".plist" withString:@""] ofType:@"plist"]] valueForKey:@"frames"];
    NSArray *frameNames = [frameDic allKeys];

    for (NSString *fileName in frameNames) {
        CCSprite *tempSprite = [CCSprite spriteWithSpriteFrameName:fileName];
        tempSprite.anchorPoint = ccp(0, 0);
        
        CCRenderTexture *tempRenderTexture = [CCRenderTexture renderTextureWithWidth:tempSprite.boundingBox.size.width height:tempSprite.boundingBox.size.height];
        [tempRenderTexture beginWithClear:0.0f g:0.0f b:0.0f a:0.0f];
        
        [tempSprite visit];
        
        [tempRenderTexture end];
        
        [tempRenderTexture saveBuffer:[self filePathForName:fileName] format:kCCImageFormatPNG];
    }
    
    [self doneCreatingImages];

    
    NSLog(@"DONE");

}

-(NSString *)filePathForName:(NSString *)fileName
{
    
    NSString* filePath = [ouputPath
                                stringByAppendingPathComponent:fileName];
    NSLog(@"Saving File: %@",fileName);
    return filePath;

}

-(void)doneCreatingImages
{
    [self removeChildByTag:1001 cleanup:YES];
    
    /*Done Images*/
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Converting DONE..." fontName:@"Marker Felt" fontSize:64];
    /*Path*/
    CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Folder Path at LOG :)" fontName:@"Marker Felt" fontSize:50];
    
    label.position = ccp(500, 700);
    label2.position = ccp(500, 500);
    [self addChild:label];
    [self addChild:label2];
    
    NSLog(@"FilePath: %@",ouputPath);
}

- (void) dealloc
{
    [ouputPath release];
		[super dealloc];
}
@end
