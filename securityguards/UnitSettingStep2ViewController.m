//
//  UnitSettingStep2ViewController.m
//  securityguards
//
//  Created by Zhao yang user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep2ViewController.h"
#import "UnitSettingStep3ViewController.h"
#import "TipsLabel.h"
#import "TTTAttributedLabel.h"

@interface UnitSettingStep2ViewController ()

@end

@implementation UnitSettingStep2ViewController

- (void)initUI{
    [super initUI];
    self.topbarView.title = @"第二步:设置前准备";

    CGFloat offsetXOfTipsLabel = 40;
    CGFloat offsetXOfContentLabel = 50;

    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, self.topbarView.frame.size.height + 9)];
    [self.view addSubview:lblLine1];

    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, self.topbarView.frame.size.height + 11, 220, 25)];
    lblLine1Content.text = @"请接通智能卫士电源";
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:15.f];
    lblLine1Content.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine1.frame.origin.y + lblLine1.frame.size.height + 5)];
    [self.view addSubview:lblLine2];
    
    TTTAttributedLabel *lblLine2Content = [[TTTAttributedLabel alloc] initWithFrame:
            CGRectMake(offsetXOfContentLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height, 220, 75)];
    lblLine2Content.numberOfLines = 3;
    lblLine2Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine2Content.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString * tttstring = [[NSMutableAttributedString alloc] initWithString:@"打开智能卫士，30-60秒后将听到“滴滴滴”三声，表示智能卫士自检已完成"];
    
    UIFont *italicFont = [UIFont italicSystemFontOfSize:15.f];
    CTFontRef italicCTFont = CTFontCreateWithName((CFStringRef)italicFont.fontName, italicFont.pointSize, NULL);
    [tttstring addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicCTFont range:NSMakeRange(0, tttstring.length)];
    [tttstring addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor darkGrayColor] CGColor] range:NSMakeRange(0,tttstring.length)];
    [tttstring addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor appBlue] CGColor] range:NSMakeRange(17, 3)];
    lblLine2Content.text = tttstring;
    [self.view addSubview:lblLine2Content];
    
    UILabel *lblLine3 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel,lblLine2.frame.origin.y + lblLine2.frame.size.height + 30)];
    [self.view addSubview:lblLine3];
    TTTAttributedLabel *lblLine3Content = [[TTTAttributedLabel alloc] initWithFrame:
        CGRectMake(offsetXOfContentLabel, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height - 5, 220, 75)];
    lblLine3Content.backgroundColor = [UIColor clearColor];
    lblLine3Content.numberOfLines = 4;
    lblLine3Content.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString * line3Text = [[NSMutableAttributedString alloc] initWithString:@"在自检声响起后，请按下面板上的“手/自”按钮超过3秒，并听到“滴嘟”一声后，点击“下一步”继续配置过程"];
    [line3Text addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicCTFont range:NSMakeRange(0, line3Text.length)];
    [line3Text addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor darkGrayColor] CGColor] range:NSMakeRange(0,line3Text.length)];
    [line3Text addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor appBlue] CGColor] range:NSMakeRange(22, 4)];
    lblLine3Content.text = line3Text;
    [self.view addSubview:lblLine3Content];
    
    UIImageView *imgTips = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLine3Content.frame.origin.y + lblLine3Content.frame.size.height, 513 / 2, 361 / 2)];
    imgTips.image = [UIImage imageNamed:@"image_setting_step2"];
    imgTips.center = CGPointMake(self.view.center.x - 10, imgTips.center.y);
    [self.view addSubview:imgTips];
    
    UIButton *btnNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, imgTips.frame.origin.y + imgTips.frame.size.height + 15, 500 / 2, 66 / 2)];
    btnNextStep.center = CGPointMake(self.view.center.x, btnNextStep.center.y);
    [btnNextStep setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
    [btnNextStep addTarget:self action:@selector(btnNextStepPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNextStep];
}
    
- (void)btnNextStepPressed:(UIButton *)sender{
    [self.navigationController pushViewController:[[UnitSettingStep3ViewController alloc] init] animated:YES];
}

@end
