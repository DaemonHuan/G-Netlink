//
//  BusinessHttpConnectWithNtspHeader.h
//  G_NetLink
//
//  Created by 95190 on 14-3-21.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseBusinessHttpConnect.h"
@class NtspHeader;
@interface BusinessHttpConnectWithNtspHeader : BaseBusinessHttpConnect
@property(strong,nonatomic) NtspHeader * ntspHeaderJLH;

@end
