//
//  UnitSettingStep2ViewController.m
//  securityguards
//
//  Created by Zhao yang user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep2ViewController.h"
#import "TipsLabel.h"
#import "UnitSettingStep3ViewController.h"
#import "TTTAttributedLabel.h"

@interface UnitSettingStep2ViewController ()

@end

@implementation UnitSettingStep2ViewController

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
	// Do any additional setup after loading the view.
}

- (void)initUI{
    [super initUI];
    self.topbarView.title = NSLocalizedString(@"step2_title", @"");

    CGFloat offsetXOfTipsLabel = 40;
    CGFloat offsetXOfContentLabel = 50;

    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, self.topbarView.frame.size.height + 14)];
    [self.view addSubview:lblLine1];

    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(offsetXOfContentLabel, self.topbarView.frame.size.height + 10, 220, 50)];
    lblLine1Content.text = NSLocalizedString(@"step2_line1", @"");
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:15.f];
    lblLine1Content.numberOfLines = 2;
    lblLine1Content.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel, lblLine1.frame.origin.y + lblLine1.frame.size.height + 20)];
    [self.view addSubview:lblLine2];
    TTTAttributedLabel *lblLine2Content = [[TTTAttributedLabel alloc] initWithFrame:
            CGRectMake(offsetXOfContentLabel, lblLine1Content.frame.origin.y + lblLine1Content.frame.size.height, 220, 50)];
    lblLine2Content.numberOfLines = 2;
    lblLine2Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine2Content.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString * tttstring = [[NSMutableAttributedString alloc] initWithString: NSLocalizedString(@"step2_line2", @"")];
    UIFont *italicFont = [UIFont italicSystemFontOfSize:15.f];
    CTFontRef italicCTFont = CTFontCreateWithName((CFStringRef)italicFont.fontName, italicFont.pointSize, NULL);
    [tttstring addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicCTFont range:NSMakeRange(0, tttstring.length)];
    [tttstring addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor darkGrayColor] CGColor] range:NSMakeRange(0,tttstring.length)];
    [tttstring addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor appBlue] CGColor] range:NSMakeRange(12, 3)];
    lblLine2Content.text = tttstring;
    [self.view addSubview:lblLine2Content];
    
    UILabel *lblLine3 = [TipsLabel labelWithPoint:CGPointMake(offsetXOfTipsLabel,lblLine2.frame.origin.y + lblLine2.frame.size.height + 25)];
    [self.view addSubview:lblLine3];
    TTTAttributedLabel *lblLine3Content = [[TTTAttributedLabel alloc] initWithFrame:
        CGRectMake(offsetXOfContentLabel, lblLine2Content.frame.origin.y + lblLine2Content.frame.size.height, 220, 75)];
    lblLine3Content.backgroundColor = [UIColor clearColor];
    lblLine3Content.numberOfLines = 3;
    lblLine3Content.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString * line3Text = [[NSMutableAttributedString alloc] initWithString: NSLocalizedString(@"step2_line3", @"")];
    [line3Text addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicCTFont range:NSMakeRange(0, line3Text.length)];
    [line3Text addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor darkGrayColor] CGColor] range:NSMakeRange(0,line3Text.length)];
    [line3Text addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor appBlue] CGColor] range:NSMakeRange(22, 4)];
    lblLine3Content.text = line3Text;
    [self.view addSubview:lblLine3Content];
    
    UIImageView *imgTips = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLine3Content.frame.origin.y + lblLine3Content.frame.size.height + 5, 524 / 2, 290 / 2)];
    imgTips.image = [UIImage imageNamed:@"image_setting_step2"];
    imgTips.center = CGPointMake(self.view.center.x, imgTips.center.y);
    [self.view addSubview:imgTips];
    
    UIButton *btnNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, imgTips.frame.origin.y + imgTips.frame.size.height + 10, 500 / 2, 66 / 2)];
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
