//
//  config.h
//  Yiguanjia_Paitent
//
//  Created by 张斌 on 16/8/10.
//  Copyright © 2016年 张斌. All rights reserved.
//

#ifndef config_h
#define config_h


#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenSize [UIScreen mainScreen].bounds.size
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define NavigationHeight    64

//认证信息页面控件frame信息
#define AUTH_BTNSUBMIT_HEIGHT  40
#define AUTH_TABLEVIEW_HEIGHT  440
#define AUTH_TBNSUBMIT_EAGE    18
#define AUTH_TBNSUBMIT_TOP     29



//navigation bar上面按钮的宽和高
#define NAVITATION_BARITEM_WIDTH  28
#define NAVITATION_BARITEM_HEIGHT  28

//tableview Section的默认高度
#define SectionHeight   10
//tableview 默认cell的高度
#define DefaultCellHeight   44


//请求视频通话的消息参数
#define CallUserName @"CallUserName"
//请求视频通话消息
#define CallVideo   @"CallVideo"


//当前的团队信息
#define DKTeam  @"Team"
//当前的登录方式
#define DKLine  @"OnLine"

//忘记密码消息
#define ForGetPSWNote @"forgetPsw"

//微信回调信息
#define WXCode  @"WXCode"

//用户信息
#define UserDoctor  @"Dcotor"


//保存密码和账号在本地，第二次不用在登录
#define UESERNAME  @"userName"
#define UESERPASSWORD  @"userPassword"

//每个环信账号的密码
#define AccountPsw  @"123456"
//微信登录后保存的unionId
#define WXUnionID  @"WXUnionId"

//定位的省code
#define LOCALPROVINCE   @"localProvince"
//定位的省名字
#define LOCALPROVINCENAME   @"localProvinceName"

//定位的市code
#define LOCALCITY   @"localCity"
//定位的市名字
#define LOCALCITYNAME   @"localCityName"

//默认消息中心
#define DefaultNotificationCenter  [NSNotificationCenter defaultCenter]

//banner高度
#define ImageCellHeight     (ScreenWidth/375.f)*150

//cell的header或者footer不需要高度
#define SectionNoHeight     0.0000001


//环信服务器收到消息的时间和本地收到消息的时间的最大时间差
#define DKHyTimeDiff    5


//网络不好的时候显示的文字和图片, 刷新按钮的图片
#define NetWorkBadWord  @"哎呦不好，网络跑丢了"
#define NetWorkBadImage @"netWorkBad"
#define NetWorkBadBtnImage @"needRefresh"

#ifdef DEBUG
#	define DKLog(fmt, ...) NSLog((@"%s #%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DKJLog(...)
#endif

////定义UIImage对象
//#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]




#endif /* config_h */
