//
//  ProtocolViewController.m
//  G-NetLink-v1.0
//
//  Created by jk on 12/9/15.
//  Copyright © 2015 jk. All rights reserved.
//

#define SPACE_XX 12.0f

#import "ProtocolViewController.h"
#import "public.h"

@interface ProtocolViewController () {
    
}

@end

@implementation ProtocolViewController {
    IBOutlet UIScrollView * m_centorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_return"] style: UIBarButtonItemStylePlain target:(UINavigationController *)self.navigationController action:@selector(popViewControllerAnimated:)];
    [leftItem setTintColor: [UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"用户协议";

    CGFloat wx = [UIScreen mainScreen].bounds.size.width;
    CGFloat appendY = 0.0f;
    CGFloat yy = 0.0f;
    UILabel * one = [self newTitleLable:@"吉利G-Netlink用户服务协议"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 80.0f)];
    [m_centorView addSubview: one];
    yy += 80.0f;
    
    one = [self newNameLable:@"第一条.服务条款的确认和接受"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t欢迎您使用吉利G-Netlink软件及服务，吉利G-Netlink软件为浙江吉利控股集团有限公司（以下简称“吉利”）提供的出行服务产品，为明确吉利和用户之间的权利、义务关系，请仔细阅读和理解《吉利G-Netlink用户服务协议》（以下简称“本协议”），特别是免除或者限制责任的条款。您一旦安装、复制、下载或以其它方式使用吉利G-Netlink软件（以下简称“本软件”)，即视为您已阅读并同意接受本协议各项条款的约束。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"第二条.知识产权"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t2.1吉利是本软件的知识产权权利人。本软件的一切著作权、商标权、专利权、商业秘密等知识产权，以及与本软件相关的所有信息内容（包括但不限于文字、图片、音频、视频、图表、界面设计、版面框架、有关数据或电子文档等）均受中华人民共和国法律法规和相关的国际合约保护，吉利享有上述知识产权，但相关权利人依照法律规定应享有的权利除外。\n\t2.2未经吉利或相关权利人书面同意，用户不得对通过本服务获得的任何信息自行或允许任何第三人进行任何复制、变更、销售或出版以及其他形式用户正常使用之外的其他目的。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"第三条.用户信息管理"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t3.1登录的账号是吉利识别用户身份的有效手段。\n\t3.2用户发生下列情形之一，吉利将不承担任何责任：\n（1）用户将账号信息转让或出借给任何第三方使用，导致用户利益受到损害的；\n（2）用户的账号信息被他人盗用给用户造成损害的；\n（3）用户使用服务时，因无法提供正确的账号等身份验证信息，导致无法使用服务的。\n\t3.3在法律、法规许可的前提下，用户授权吉利在以下范围内使用用户的信息：\n（1）发送有关汽车出行服务的通知；\n（2）为提升汽车出行服务质量进行的满意度调查；\n（3）为提供服务或改进产品进行的车辆数据采集；\n（4）为提供服务或改善服务质量进行的电话、住所等数据采集；\n（5）为提供服务获取的用户地理位置信息；\n（6）其他在服务提供过程中，为保证服务质量，必须使用的信息。\n\t3.4吉利会尽最大努力防止用户信息泄露、丢失。但因法律或行政、司法机关的强制规定必须披露相关信息时，吉利将按强制性规定处理。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"第四条.禁止事项"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t用户不得通过使用吉利提供的服务进行任何违反法律、法规、规章的行为。因上述行为导致的一切责任，由用户自行承担。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"第五条.隐私权保护"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t5.1保护用户的个人信息安全是吉利的一项基本原则，吉利将会采取合理的措施保护用户的个人信息。除法律法规规定的情形外，未经用户许可吉利不会向第三方公开、透露用户个人信息。\n\t5.2若国家法律、法规或政策有特殊规定的，用户需要提供真实的身份信息，若用户不提供或提供的信息不完整，则无法使用本服务或在使用过程中受到限制。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"第六条.免责与责任限制"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t您充分了解并同意，服务可能存在缺陷，您必须对使用本软件所查询的结果自行加以判断，并承担因使用本软件而引起的所有风险。吉利不对本软件所查询的结果的安全性、准确性、及时性、完整性、实用性等做任何明示或默示的保证，吉利不对用户使用本软件而导致的任何损失或损害承担责任。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"第七条.损害赔偿"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t因用户违反本协议或因其他不当、违法行为损害吉利权益或导致吉利遭到第三方诉讼、索赔以及其他权益受损的，用户应独自承担全部责任。吉利有权采取以下措施，包括但不限于：停止提供服务、限制使用等，并有权要求用户赔偿由此给吉利造成的一切损失。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"第八条.第三方服务及技术"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t8.1用户在使用本软件中第三方提供的产品或服务时，除遵守本协议约定外，还应遵守第三方的用户使用协议。\n\t8.2用户确认知晓：因用户使用本软件或要求吉利提供特定服务时，本软件可能会调用第三方系统或者通过第三方来支持用户的使用或访问。使用或访问的结果由该第三方提供，吉利不保证通过第三方提供的服务及内容或支持实现结果的安全性、准确性、有效性，以上结果可能存在其他不确定的风险，由此若引发的任何争议或损害，由用户与第三方协商解决，与吉利无关，吉利不承担任何责任。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    one = [self newNameLable:@"第九条.法律及争议解决"];
    [one setFrame:CGRectMake(SPACE_XX, yy, wx - (2 * SPACE_XX), 30.0f)];
    [m_centorView addSubview: one];
    yy += 30.0f;
    
    one = [self newContextLable:SPACE_XX Y:yy Title:@"\t9.1本协议的成立、生效、履行、解释及纠纷解决，适用中华人民共和国法律。\n\t9.2因本协议引起的或与本协议有关的任何争议，各方应友好协商解决。协商不成的，任何一方均可将争议提交吉利所在地杭州市滨江区有管辖权的人民法院解决。"];
    appendY = CGRectGetHeight(one.bounds);
    [m_centorView addSubview: one];
    yy += appendY + 10.0f;
    
    m_centorView.contentSize = CGSizeMake(wx, yy + 100.0f);
}

- (void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissSelfView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *) newTitleLable:(NSString *)title {
    UILabel * label = [[UILabel alloc]init];
    [label setTextColor:[UIColor colorWithHexString:WORD_COLOR]];
    [label setFont: [UIFont fontWithName:FONT_MM size:20.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:title];
    
    return label;
}

- (UILabel *) newNameLable:(NSString *)title {
    UILabel * label = [[UILabel alloc]init];
    [label setFont: [UIFont fontWithName:FONT_MM size:18.0f]];
    [label setTextColor:[UIColor colorWithHexString:@"00A0E9"]];
    [label setText:title];
    
    return label;
}

- (UILabel *) newContextLable:(CGFloat)xx Y:(CGFloat)yy Title:(NSString *)title {
    UILabel * label = [[UILabel alloc]init];
    [label setFont: [UIFont fontWithName:FONT_MM size:17.0f]];
    [label setTextColor:[UIColor whiteColor]];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [label setNumberOfLines:0];
    [label setText:title];
    CGSize size = [label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - (2 * SPACE_XX), 1000.0f)];
    [label setFrame:CGRectMake(xx, yy, size.width, size.height + 20.0f)];
    
    return label;
}
@end
