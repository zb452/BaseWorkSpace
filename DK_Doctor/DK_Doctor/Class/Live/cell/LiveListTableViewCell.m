//
//  LiveListTableViewCell.m
//  Ep_Doctor
//
//  Created by 张斌 on 2016/11/3.
//  Copyright © 2016年 陕西医管家医院管理咨询服务有限公司. All rights reserved.
//

#import "LiveListTableViewCell.h"
#import "liveDetail.h"
#import "UIImageView+WebCache.h"
#import "NSString+RTSizeWithFont.h"

@interface LiveListTableViewCell()

@property(weak,nonatomic)IBOutlet UIImageView *headImage;
@property(weak,nonatomic)IBOutlet UIImageView *imgView;

@property(weak,nonatomic)IBOutlet UILabel  *labelName;
@property(weak,nonatomic)IBOutlet UILabel  *labelNum;
@property(weak,nonatomic)IBOutlet UIButton *btnLocation;
@property(weak,nonatomic)IBOutlet UILabel  *labelHospital;

@property(weak,nonatomic)IBOutlet UIButton *btnLiving;


@property(weak,nonatomic)IBOutlet NSLayoutConstraint *hositalWidth;

@end

@implementation LiveListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configWith:(id)data
{
    if ([data isKindOfClass:[LiveDetail class]])
    {
        LiveDetail *model = data;
        
        
        NSString *url = @"";
        
        if ([model.headPic containsString:@"http"])
        {
            url = model.headPic;
        }
        else
        {
            if ([model.headPic hasSuffix:@".png"] || [url hasSuffix:@".jpg"])
            {
                NSArray *aryPath = [model.headPic componentsSeparatedByString:@"/"];
                
                NSString *path =@"";
                if (aryPath.count>1)
                {
                    path = [aryPath objectAt:aryPath.count-1];
                }
                else
                {
                    path = model.headPic;
                }
                
                NSString *szType = [path substringFromIndex:path.length-4];
                url = [path substringToIndex:path.length-4];
                
                
                url = [NSString stringWithFormat:@"%@%@_body_2x%@",URLImage,url,szType];
                
            }
            else
            {
                url = [NSString stringWithFormat:@"%@%@",URLImage,model.headPic];
            }
        }
        
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
        
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default"]];

//
//        if (model.accountId == 47)
//        {
//            [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URLImage,@"images/sjz_head.png"]] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
//            
//            [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URLImage,@"sjz_head_body_2x.png"]] placeholderImage:[UIImage imageNamed:@"default"]];
//            
//        }
//        else
//        {
//            
//        }
//
        self.labelName.text = model.name;
        self.labelNum.text = [NSString stringWithFormat:@"%d",(int)model.chatroomCount];
        self.labelHospital.text = model.areaName;
        
        CGSize size = [model.areaName rtSizeWithFont:[UIFont systemFontOfSize:16]];
        self.hositalWidth.constant = size.width+20;
        
        
        [self.btnLocation setTitle:model.cityName forState:UIControlStateNormal];
    }
}

-(void)initUI
{
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 22;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.btnLiving.clipsToBounds = YES;
    self.btnLiving.layer.cornerRadius = 10;
    self.labelHospital.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.labelHospital.clipsToBounds = YES;
    self.labelHospital.layer.cornerRadius = 10;
}



@end
