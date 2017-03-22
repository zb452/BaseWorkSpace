//
//  urls.h
//  EPNetWork
//
//  Created by 张斌 on 16/9/8.
//  Copyright © 2016年 陕西医管家医院管理咨询服务有限公司. All rights reserved.
//

#ifndef urls_h
#define urls_h


//#define URLDomainName @"http://www.yiyuanguanjia.com/com.medical.platform.wechat/"  //正式地址
//#define URLDomainName @"http://192.168.0.133:8080/com.medical.platform.wechat/"  //测试地址
//#define URLDomainName @"http://10.11.12.103:8080/com.medical.platform.wechat/"  //测试地址
//#define URLDomainName @"http://1538673or7.51mypc.cn/com.medical.platform.wechat/"  //测试地址
//#define URLDomainName @"http://192.168.0.227/demo/APItest/"  //测试服务器接口模型地址
#define URLDomainName @"http://192.168.0.227/demo/"  //测试服务器接口地址
//#define URLDomainName @"http://1rg6000205.51mypc.cn/demo/"  //测试服务器接口地址

//#define URLDomainName @"http://rap.taobao.org/mockjsdata/13886/"  //mock测试服务器接口模型地址


#define URLImage @"http://www.yiyuanguanjia.com/zbimgs/"  //图片地址
//#define URLImage @"http://1538673or7.51mypc.cn/zbimgs/"  //测试图片地址


#define ALIPUBLIC_BUCKET  @"yiguanjia"
#define ALIENDPOINT  @"https://oss-cn-beijing.aliyuncs.com"
#define ALIURLALiyun  @"https://yiguanjia.oss-cn-beijing.aliyuncs.com"  //阿里的oss图片地址

#define AliyunOSSAccessKey  @"LTAIxCZP4c39Yofq"
#define AliyunOSSSecretKey  @"g48u00uxLDvyopR1JWcZrZziU39zUd"

//token失效
#define NotiTokenInvalid   @"tokenInvalid"



//获取直播的科室列表
#define GetLiveDepartMent         @"departments/searchAll"
#define GetLiveList               @"live/Lives"
#define CreateLive                @"live/createLive"
#define GetLiveDetail             @"live/liveDetails"
#define AddChatRoom               @"live/addchatroomuser"
#define DoctorFinishLive          @"live/deletechatroomuser"
#define UeserQuitRoom             @"live/deleteOneUser"


//登录接口
#define LoginApi         @"user/login"

//注册
#define RegisterForPaitentAPI      @"account/register"
//修改密码
#define ModifyPSW        @"user/password"
//忘记密码
#define ForgetPSW        @"account/forgetpwd"
//获取验证码
#define GetAuthCodeForPaitent        @"captcha/search"

//提交用户信息
#define UpdatePaitentInfo           @"userInfo/update"

//微信登录授权接口
#define WXLoginAuthCode             @"oauth/wechatauth"

//微信登录接口，根据unionId直接登录
#define WXLogin                     @"oauth/wechatlogin"

//根据账号查询用户信息
#define QueryPaitentInfo               @"account/searchaccount"

//微信登录绑定手机号
#define WXBindPhone                 @"account/bindaccount"

//检查手机号是否注册
#define PhoneIsResiter              @"account/isRegister"

//查询预约挂号的医生
#define AppointDoctorList           @"member/searchall"

//查询预约挂号医生的排版
#define AppointDoctoAllot           @"allot/app/register/search"

//添加常用联系人
#define AddContactAPI               @"contact/insert"

//预约挂号下单
#define PostOrderForAppoint         @"order/allot/insertRegister"

//查询常用联系人
#define GetContact                  @"contact/search"

//获取预约挂号医生信息
#define GetDoctorByUid              @"member/searchMemberRegister"

//根据经纬度获取当前位置的城市
#define GetAdressByLocation         @"location/getCityDetail"

//获取省列表
#define GetAllProvince         @"province/search"

//根据省的代码查询市的信息接口
#define GetCityListByProvince         @"city/searchofProvince"

//根据城市的代码查询医院的信息接口
#define GetHospitalListByCity        @"hospital/search"

//获取远程门诊医院排版接口
#define GetRemoteAllotwork        @"allot/search"

//获取远程门诊医生信息
#define GetRemoteDoctorInfo              @"added/search"

//远程门诊下单
#define PostOrderForRemote          @"order/allot/insert"

//我的订单
#define GetMyOrder          @"order/allot/searchAllOrder"


/****************************************************************************************
                                        团队
 ****************************************************************************************/
//我的所有团队列表
#define GetMyTeamList     @"team/myTeamList"
//所有的上线方式
#define GetOnLineWayList      @"doctor/stateList"

//获取某个团队信息
#define GetTeamDetail     @"team/getTeam"

//更新医生和值班信息
#define updatetDoctorStatus @"user/doctorStatus"
//获取我的协作团队
#define GetAboutTeam    @"team/getTeamList"
//获取团队成员列表
#define GetTeamMember    @"team/teamMemberList"

/****************************************************************************************
                                    zoom
 ****************************************************************************************/
//创建会议
#define CreateMeeting   @"meeting/create"

//创建一次性会议
#define CreateOnceMeeting   @"meeting/createOnce"

//获取会议的详情
#define GetZoomMetting   @"meeting/getMoveMeeting"

//更新是否在视频中状态
#define UpdateVideoStatus @"user/changeVideoStatus"

//强制结束会议
#define EndMeeting @"meeting/endMeeting"




#endif /* urls_h */
