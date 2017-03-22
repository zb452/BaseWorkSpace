//
//  MettingProtocl.h
//  DK_Doctor
//
//  Created by 张斌 on 2017/2/9.
//  Copyright © 2017年 陕西医管家医院管理咨询服务有限公司. All rights reserved.
//

#ifndef MettingProtocl_h
#define MettingProtocl_h

/*****************************
 患者和医生发起视频的通讯协议
 发起：DKStartMeeting
 同意：DKConsent
 拒绝：DKRejection
 取消：DKCancel
 *****************************/
#define DKStartMeeting @"DKStartMeeting"
#define DKConsent @"DKConsent"
#define DKRejection @"DKRejection"
#define DKCancel @"DKCancel"

///***************************** 暂时不需要了，不去分医生和医生，团队和团队了
// 医生团队发起视频的通讯协议
// 发起：DKTeamStartMeeting
// 同意：DKTeamConsent
// 拒绝：DKTeamRejection
// 取消：DKTeamCancel
// *****************************/
//#define DKTeamStartMeeting @"DKTeamStartMeeting"
//#define DKTeamConsent @"DKTeamConsent"
//#define DKTeamRejection @"DKTeamRejection"
//#define DKTeamCancel @"DKTeamCancel"

/*****************************
 医生个人和个人或者团队和团队发起视频的通讯协议
 发起：DKDoctorStartMeeting
 同意：DKDoctorConsent
 拒绝：DKDoctorRejection
 取消：DKDoctorCancel
 *****************************/
#define DKDoctorStartMeeting @"DKDoctorStartMeeting"
#define DKDoctorConsent @"DKDoctorConsent"
#define DKDoctorRejection @"DKDoctorRejection"
#define DKDoctorCancel @"DKDoctorCancel"



//信息有更新的消息
#define DKRefresh   @"DKRefresh"

//强制下线
#define DKDoctorForceQuit @"DKDoctorForceQuit"

//主动的动作，比如发起视频，都是内部的notifacation
//医生和患者之间的视频
#define DKNotificationStartMeeting   @"NotiFicationStartMeeting"
//自己取消视频会议了
#define DKNotificationCancel   @"NotiFicationCancel"
#define DKNotificationTeamCancel   @"NotiFicationTeamCancel"
#define DKNotificationDoctorCancel   @"NotiFicationDoctorCancel"

//团队和团队之间的视频
#define DKNotificationTeamStartMeeting   @"NotiFicationTeamStartMeeting"

//医生和医生之间的视频
#define DKNotificationDoctorStartMeeting   @"NotiFicationDoctorStartMeeting"
//强制下线
#define DKNotificationDoctorForceQuit   @"NotiFicationForceQuit"
//信息有更新的消息
#define DKNotiFicationRefresh           @"NotificationRefresh"



//参数
#define DKZoomId @"DKZoomId"  //代表会议id的字段
#define DKDoctorName @"DKDoctorName"  //代表发消息人的用户名
#define DKDoctorPic @"DKDoctorPic"  //代表发消息人的头像
#define DKIsTeamMeeting @"DKIsTeamMeeting"//是否是团队消息，1：个人，0:团队
#define DKZoomJoinUrl   @"DKZoomJoinUrl"    //PC端用到，PC端用于加入会议的url
#define DKMeetingId    @"DKMeetingId"  //创建会议的时候的这个会议的id

//这些都是需要本地记录的，只有本地用到
#define DKZoomUid   @"DKZoomUid"
#define DKZoomToken @"DKZoomToken"
#define DKZoomAppId @"DKZoomAppId"
#define DKZoomAppValue @"DKZoomAppValue"


#endif /* MettingProtocl_h */
