//
//  UserFeedbackViewController.m
//  G-NetLink
//
//  Created by liuxiaobo on 14-4-29.
//  Copyright (c) 2014年 95190. All rights reserved.
//

#import "UserFeedbackViewController.h"
#import "UserFeedbackView.h"
#import "User.h"
#import "StringUtils.h"
@interface UserFeedbackViewController ()
{
    User * _user;
    UserFeedbackView *userFeedbackView;
}
@end

@implementation UserFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    user.observer = self;
    NSString * textFieldString = [self.parentNode getNodeOfSaveDataAtKey:@"saveStrngTextField" ];
    if (textFieldString && textFieldString.length>0)
    {
        userFeedbackView.phoneFileld.text = textFieldString;
    }
    NSString * textViewString = [self.parentNode getNodeOfSaveDataAtKey:@"saveStrngTextView" ];
    if (textViewString && textViewString.length>0)
    {
        userFeedbackView.textView.text = textViewString;
    }
   
	// Do any additional setup after loading the view.
}
-(void)loadView
{
    userFeedbackView=[[UserFeedbackView alloc] initWithFrame:[self createViewFrame]];
    userFeedbackView.customTitleBar.buttonEventObserver = self;
    userFeedbackView.feedDelegate=self;
    userFeedbackView.textView.delegate = self;
    userFeedbackView.phoneFileld.delegate = self;
    self.view=userFeedbackView;
}
-(BOOL)isValidateQQ:(NSString*)stirng
{
    [NSCharacterSet decimalDigitCharacterSet];
    
    if ([stirng stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length> 0)
    {
//        NSLog(@"不是纯数字");
    }else{
         if (userFeedbackView.phoneFileld.text.length >= 5&& userFeedbackView.phoneFileld.text.length<=10   )
         {
             return YES;
         }
    }
    return NO;
}
-(void)submitDelegate
{
    if ([userFeedbackView.phoneFileld.text isValidateEmail])
    {
        NSLog(@"Email");
        [self FeedBackMethod];
        return;
    }
    else if([userFeedbackView.phoneFileld.text isValidateMobile]){
        NSLog(@"phone");
        [self FeedBackMethod];
        return;
    }
    else if ([self isValidateQQ:userFeedbackView.phoneFileld.text])
    {
        NSLog(@"qq");
        [self FeedBackMethod];
        return;
    }
    else if (userFeedbackView.phoneFileld.text.length >= 1 )
    {
        NSString * message=@"您的联系方式有误，请重新填写！";
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
       return;
    }
    else{
        NSString * message=@"您的联系方式为空，请填写！";
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}

-(void)FeedBackMethod{
    if (userFeedbackView.textView.text.length>500) {
        NSString * message=@"您提交的内容长度已经超过500，请您删除一些，以保证提交成功";
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:message  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (userFeedbackView.textView.text.length <= 0)
    {
        NSString * message=@"请您填写反馈意见。";
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:message  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {

        [self delegateCommitFeed:userFeedbackView.textView.text withContract:userFeedbackView.phoneFileld.text];
    }
}


-(void)settingViewControllerId
{
    _viewControllerId = VIEWCONTROLLER_USERFEEDBACK;
}

-(void)delegateCommitFeed:(NSString *)feed withContract:(NSString *)contact{
    [user commitFeed:feed withContract:contact];
}
-(void)didDataModuleNoticeSucess:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID{
    [super didDataModuleNoticeSucess:baseDataModule forBusinessType:businessID];
    if (businessID== BUSINESS_COMMITFEEDBACK) {
        [userFeedbackView.phoneFileld resignFirstResponder];
        [userFeedbackView.textView resignFirstResponder];
        userFeedbackView.phoneFileld.text = @"";
       userFeedbackView.phoneFileld.placeholder = NSLocalizedStringFromTable(@"user_feedback_phone_textField_text", Res_String, @"");
        userFeedbackView.textView.text = NSLocalizedStringFromTable(@"user_feedback_textView_text", Res_String, @"");
        [userFeedbackView.phoneFileld resignFirstResponder];
        [userFeedbackView.textView resignFirstResponder];
        [self.parentNode clearChildNodeSaveData];
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"提交成功，我们会及时处理您的反馈" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        alert.delegate=self;
        [alert show];
       
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_USERMANAGEMENT;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}

-(void)didDataModuleNoticeFail:(BaseDataModule*)baseDataModule forBusinessType:(enum BusinessType)businessID forErrorCode:(int)errorCode forErrorMsg:(NSString*)errorMsg;{
    [super didDataModuleNoticeFail:baseDataModule forBusinessType:businessID forErrorCode:errorCode forErrorMsg:errorMsg];
    NSString *error = @""; //= @"failMessage:";
    if(errorMsg==nil)
        return;
    error = [error stringByAppendingString:errorMsg];
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"提交失败，建议您检查一下你的网络连接" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    [alert show];
}
-(void)leftButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_USERMORE;
    msg.commandID=MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER;
    [self sendMessage:msg];
}
-(void)rightButton_onClick:(id)sender{
    Message *msg=[[Message alloc] init];
    msg.receiveObjectID=VIEWCONTROLLER_HALL;
    msg.commandID=MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER;
    [self sendMessage:msg];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidEndEditingSave:(NSString *)saveStrng
{
   
}
-(void)textViewDidEndEditingSave:(NSString *)saveStrng
{
    [self.parentNode addNodeOfSaveData:@"saveStrngTextView" forValue:saveStrng];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.placeholder = @"";
    [self.parentNode addNodeOfSaveData:@"saveStrngTextField" forValue:textField.text];
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.parentNode addNodeOfSaveData:@"saveStrngTextView" forValue:textView.text];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString * string = NSLocalizedStringFromTable(@"user_feedback_textView_text", Res_String, @"");
    if ([userFeedbackView.textView.text isEqual:string])
    {
        userFeedbackView.textView.text = @"";
    }
      string = NSLocalizedStringFromTable(@"user_feedback_phone_textField_text", Res_String, @"");
    if ([userFeedbackView.phoneFileld.placeholder isEqual:string]&& userFeedbackView.phoneFileld.text.length == 0)
    {
        userFeedbackView.phoneFileld.text = @"";
        userFeedbackView.phoneFileld.placeholder = @"";
    }else
    {
        userFeedbackView.phoneFileld.placeholder = @"";
    }
//    textField.text=@"";
//    textField.placeholder = @"";
    textField.textColor=[UIColor colorWithRed:44.0f/255.0f green:50.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSString * string = NSLocalizedStringFromTable(@"user_feedback_phone_textField_text", Res_String, @"");
    if ([userFeedbackView.phoneFileld.placeholder isEqual:string]&& userFeedbackView.phoneFileld.text.length == 0)
    {
        userFeedbackView.phoneFileld.text = @"";
        userFeedbackView.phoneFileld.placeholder = @"";
    }
      string = NSLocalizedStringFromTable(@"user_feedback_textView_text", Res_String, @"");
    if ([userFeedbackView.textView.text isEqual:string])
    {
        userFeedbackView.textView.text = @"";
    }
//    _phoneFileld.text = @"";
//    _phoneFileld.placeholder = @"";
    //    textView.text=@"";
    textView.textColor=[UIColor colorWithRed:44.0f/255.0f green:50.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text length] - range.length + [text length] > 500)
    {
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>=500) {
        NSString * message=@"您输入的内容过多，请你删掉一些，以保证提交成功";
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else{
        int num=textView.text.length;
        userFeedbackView.rightLable.text=[NSString stringWithFormat:@"%@%d%@",@"剩余",500-num,@"字"];
    }
}


@end
