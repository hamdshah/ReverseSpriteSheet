//
//  HelloWorldLayer.h
//  ReverseSpriteSheet
//
//  Created by HamdullahShah on 17/01/2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface ConversionLayer : CCLayer
{
    NSString *ouputPath;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
