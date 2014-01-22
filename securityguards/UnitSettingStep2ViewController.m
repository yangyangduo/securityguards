//
//  UnitSettingStep2ViewController.m
//  securityguards
//
//  Created by hadoop user account on 14/01/2014.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UnitSettingStep2ViewController.h"
#import "TipsLabel.h"
#import "UnitSettingStep3ViewController.h"
#import "TTTAttributedLabel.h"
#define TOPBAR_HEIGHT self.topbarView.frame.size.height

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
    UILabel *lblLine1 = [TipsLabel labelWithPoint:CGPointMake(60, 20+TOPBAR_HEIGHT)];
    [self.view addSubview:lblLine1];
    UILabel *lblLine1Content = [[UILabel alloc] initWithFrame:CGRectMake(65, lblLine1.frame.origin.y, 200, 40)];
    lblLine1Content.text = NSLocalizedString(@"step2_line1", @"");
    lblLine1Content.textColor = [UIColor darkGrayColor];
    lblLine1Content.backgroundColor = [UIColor clearColor];
    lblLine1Content.font = [UIFont systemFontOfSize:13.f];
    lblLine1Content.numberOfLines = 2;
    lblLine1Content.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:lblLine1Content];
    
    UILabel *lblLine2 = [TipsLabel labelWithPoint:CGPointMake(60, lblLine1.frame.origin.y+lblLine1.frame.size.height+10)];
    [self.view addSubview:lblLine2];
    TTTAttributedLabel *lblLine2Content = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(65, lblLine2.frame.origin.y, 200, 40)];
    lblLine2Content.numberOfLines = 2;
    lblLine2Content.lineBreakMode = NSLineBreakByWordWrapping;
    lblLine2Content.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString * tttstring = [[NSMutableAttributedString alloc] initWithString: NSLocalizedString(@"step2_line2", @"")];
    UIFont *italicFont = [UIFont italicSystemFontOfSize:13.f];
    CTFontRef italicCTFont = CTFontCreateWithName((CFStringRef)italicFont.fontName, italicFont.pointSize, NULL);
    [tttstring addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicCTFont range:NSMakeRange(0, tttstring.length)];
    [tttstring addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor darkGrayColor] CGColor] range:NSMakeRange(0,tttstring.length)];
    [tttstring addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor appBlue] CGColor] range:NSMakeRange(13,3)];
    lblLine2Content.text = tttstring;
    [self.view addSubview:lblLine2Content];
    
    UILabel *lblLine3 = [TipsLabel labelWithPoint:CGPointMake(60,lblLine2.frame.origin.y+lblLine2.frame.size.height+10)];
    [self.view addSubview:lblLine3];
    TTTAttributedLabel *lblLine3Content = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(65, lblLine3.frame.origin.y+2, 200, 50)];
    lblLine3Content.backgroundColor = [UIColor clearColor];
    lblLine3Content.numberOfLines = 3;
    lblLine3Content.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString * line3Text = [[NSMutableAttributedString alloc] initWithString: NSLocalizedString(@"step2_line3", @"")];
    [line3Text addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicCTFont range:NSMakeRange(0, line3Text.length)];
    [line3Text addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor darkGrayColor] CGColor] range:NSMakeRange(0,line3Text.length)];
    [line3Text addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor appBlue] CGColor] range:NSMakeRange(23,4)];
    lblLine3Content.text = line3Text;
    [self.view addSubview:lblLine3Content];
    
    UIImageView *imgTips = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblLine3Content.frame.origin.y+lblLine3Content.frame.size.height +5, 524/2, 290/2)];
    imgTips.image = [UIImage imageNamed:@"image_setting_step2.png"];
    imgTips.center = CGPointMake(self.view.center.x, imgTips.center.y);
    [self.view addSubview:imgTips];
    
    UIButton *btnNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, imgTips.frame.origin.y+imgTips.frame.size.height+10, 500/2, 53/2)];
    btnNextStep.center = CGPointMake(self.view.center.x, btnNextStep.center.y);
    [btnNextStep setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue.png"] forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted.png"] forState:UIControlStateHighlighted];
    [btnNextStep setBackgroundImage:[UIImage imageNamed:@"btn_gray.png"] forState:UIControlStateDisabled];
    [btnNextStep addTarget:self action:@selector(btnNextStepPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNextStep];

}
    
- (void)btnNextStepPressed:(UIButton *)sender{
    [self.navigationController pushViewController:[[UnitSettingStep3ViewController alloc] init] animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
