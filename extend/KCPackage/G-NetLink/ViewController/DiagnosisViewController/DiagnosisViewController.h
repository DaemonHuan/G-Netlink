//
//  DiagnosisViewController.h
//  G-NetLink
//
//  Created by 95190 on 14-10-15.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "BaseViewController.h"
#import "DiagnosisView.h"
#import "../DiagnosisViewController/DiagnoseTurntable/DiagnoseTurntableViewDelegate.h"
@interface DiagnosisViewController : BaseViewController<CustomTitleBar_ButtonDelegate,DiagnoseTurntableViewDelegate,DiagnosisViewDelegate>

@end
