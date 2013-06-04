//
//  PMSplineMaker.m
//  PathMaker
//
//  Created by 马 俊 on 13-5-30.
//  Copyright (c) 2013年 马 俊. All rights reserved.
//

#import "PMSplineMaker.h"


#define B_SPLINE(u, u_2, u_3, cntrl0, cntrl1, cntrl2, cntrl3) \
( \
 ( \
  (-1*u_3 + 3*u_2 - 3*u + 1) * (cntrl0) + \
  ( 3*u_3 - 6*u_2 + 0*u + 4) * (cntrl1) + \
  (-3*u_3 + 3*u_2 + 3*u + 1) * (cntrl2) + \
  ( 1*u_3 + 0*u_2 + 0*u + 0) * (cntrl3)   \
  ) / 6 \
 )

#define CATMULL_ROM_SPLINE(u, u_2, u_3, cntrl0, cntrl1, cntrl2, cntrl3) \
( \
 ( \
  (-1*u_3 + 2*u_2 - 1*u + 0) * (cntrl0) + \
  ( 3*u_3 - 5*u_2 + 0*u + 2) * (cntrl1) + \
  (-3*u_3 + 4*u_2 + 1*u + 0) * (cntrl2) + \
  ( 1*u_3 - 1*u_2 + 0*u + 0) * (cntrl3)   \
  ) / 2 \
 )


#define SPLINE  B_SPLINE


@implementation PMSplineMaker

- (BOOL)build :(NSArray*)controlPoints
{
    int division;
    int maxDivision = 0;
    float u, u_2, u_3;
    int cpCount = (int)[controlPoints count];
    if (cpCount < 4) return NO;
    
    self.spline = [NSMutableArray array];
    
    cpCount -= 3;
    NSPoint cps[4];
    NSPoint curveData;
    for (int i = 0; i < cpCount; ++i)
    {
        cps[0] = NSPointFromString([controlPoints objectAtIndex:i]);
        cps[1] = NSPointFromString([controlPoints objectAtIndex:i+1]);
        cps[2] = NSPointFromString([controlPoints objectAtIndex:i+2]);
        cps[3] = NSPointFromString([controlPoints objectAtIndex:i+3]);
        
        NSPoint startPoint;
        NSPoint endPoint;
        startPoint.x = SPLINE(0.f, 0.f, 0.f,
                                cps[0].x,
                                cps[1].x,
                                cps[2].x,
                                cps[3].x);
        startPoint.y = SPLINE(0.f, 0.f, 0.f,
                                cps[0].y,
                                cps[1].y,
                                cps[2].y,
                                cps[3].y);
        
        
        endPoint.x = SPLINE(1.f, 1.f, 1.f,
                              cps[0].x,
                              cps[1].x,
                              cps[2].x,
                              cps[3].x);
        endPoint.y = SPLINE(1.f, 1.f, 1.f,
                              cps[0].y,
                              cps[1].y,
                              cps[2].y,
                              cps[3].y);
        
        division = MAX(abs(startPoint.x-endPoint.x), abs(startPoint.y-endPoint.y));
        if (division > maxDivision)
        {
            maxDivision = division;
        }
        for(int j = 0; j < division; j++)
        {
            
			u = (float)j / division;
			u_2 = u * u;
			u_3 = u_2 * u;
            

            // Position
            curveData.x = SPLINE(u, u_2, u_3,
                                   cps[0].x,
                                   cps[1].x,
                                   cps[2].x,
                                   cps[3].x);
            
            curveData.y = SPLINE(u, u_2, u_3,
                                   cps[0].y,
                                   cps[1].y,
                                   cps[2].y,
                                   cps[3].y);
            
            [_spline addObject:NSStringFromPoint(curveData)];
        }
    }
    NSLog(@"max division: %d", maxDivision);
    
    return YES;
}




@end
