//
//  ViewControllerPathManager.m
//  ZhiJiaX
//
//  Created by 95190 on 13-6-6.
//  Copyright (c) 2013年 95190. All rights reserved.
//

#import "ViewControllerPathManager.h"

static NSMutableArray *viewControllerPathArray;

@implementation ViewControllerPathManager


+(void)addViewControllerID:(NSNumber*)viewControllerID
{
    if(viewControllerPathArray == nil)
        viewControllerPathArray = [[NSMutableArray alloc] init];
    
    if([viewControllerID intValue] != VIEWCONTROLLER_NONE)
    {
        if([[ViewControllerPathManager getCurrentViewControllerID] intValue]!=[viewControllerID intValue])
            [viewControllerPathArray addObject:viewControllerID];
    }

}
+(NSNumber*)getCurrentViewControllerID
{
    return [viewControllerPathArray lastObject];
}
+(NSNumber*)getPreviousViewControllerID
{
    int index = viewControllerPathArray.count-2;
    if(index<0)
        return nil;
    return [viewControllerPathArray objectAtIndex:index];
}
+(NSNumber*)getPreviousViewControllerIDWithDelete
{
    NSNumber *number = [ViewControllerPathManager getPreviousViewControllerID];
    if(number!=nil)
        [ViewControllerPathManager deleteLastViewControllerID];
    return number;
}
+(void)deleteViewControllerID:(NSNumber*)viewControllerID
{
    [viewControllerPathArray removeObject:viewControllerID];
}
+(void)deleteAllViewControllerID
{
    [viewControllerPathArray removeAllObjects];
}
+(void)deleteLastViewControllerID
{
    [viewControllerPathArray removeLastObject];
}
+(void)deleteViewControllerFromIDLater:(NSNumber*)viewControllerID
{
    int index = [viewControllerPathArray indexOfObject:viewControllerID];
    index++;
    if(index>viewControllerPathArray.count)
        return;
    
    NSRange range;
    range.location = index;
    range.length = viewControllerPathArray.count-index;
    [viewControllerPathArray removeObjectsInRange:range];
}
@end
