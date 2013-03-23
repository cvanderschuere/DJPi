//
//  NSString+InitialCharaterGrouping.m
//  Scorepad+
//
//  Created by Chris Vanderschuere on 12/26/12.
//
//

#import "NSString+InitialCharaterGrouping.h"

@implementation NSString (InitialCharaterGrouping)

-(NSString*) initialCharacter{
    if (self.length>1) {
        return [self substringToIndex:1];
    }
    return self;
}

@end
