//
//  PMSplineMaker.h
//  PathMaker
//
//  Created by 马 俊 on 13-5-30.
//  Copyright (c) 2013年 马 俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMSplineMaker : NSObject
{
}

@property (retain)NSMutableArray* spline;

- (BOOL)build :(NSArray*)controlPoints;

@end
