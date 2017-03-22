//
//  LiveViewController.m
//  Ep_Doctor
//
//  Created by 张斌 on 2016/11/1.
//  Copyright © 2016年 陕西医管家医院管理咨询服务有限公司. All rights reserved.
//

#import "LiveViewController.h"
#import <QPLive/QPLive.h>
#import "DoctorMsgTableViewCell.h"
#import "BGSever+Live.h"

#define IMName @"name"   //用户昵称
#define IMAccount @"acctounName" //用户账号
#define IMIsDoctor @"isDoctor"  //是否是医生
#define IMIsJoinRoom @"isJoinRoom"  //是否是用户进入聊天室的消息

#define IMMessage @"message"    //用户发送的消息

#define LiveJoinRoom    @"JoinRoom"  //加入聊天室的消息


#define RoomID  @"259905395940655528"

#define CMDJoinRoom @"joinRoom"   //加入聊天室的cmd消息


@interface LiveViewController ()<QPLiveSessionDelegate,UIAlertViewDelegate,EMChatroomManagerDelegate,EMChatManagerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(weak,nonatomic)IBOutlet UITableView *tableview;
@property(weak,nonatomic)IBOutlet UICollectionView *collectionView;
@property(weak,nonatomic)IBOutlet UIView *backView;
@property(weak,nonatomic)IBOutlet UIImageView *headImageView;
@property(weak,nonatomic)IBOutlet UILabel *labelName;
@property(weak,nonatomic)IBOutlet UILabel *labelNum;

@property(weak,nonatomic)IBOutlet UIView *liveEndView;//直播结束显示的页面
@property(weak,nonatomic)IBOutlet UILabel *labelLiveEndNum;
@property(weak,nonatomic)IBOutlet UIButton *btnBack;

@property(strong,nonatomic)NSString *pushUrl;//推流url
@property(strong,nonatomic)NSString *roomId; //聊天室编号
@property(strong,nonatomic)NSString *cId; //聊天室id
@property(strong,nonatomic)QPLiveSession *liveSession;
@property(assign,nonatomic)AVCaptureDevicePosition currentPosition;

@property(strong,atomic)NSMutableArray *aryChatData;  //聊天内容
@property(strong,nonatomic)NSMutableArray *aryChatPeopleData; //直播间的人

@property(weak,nonatomic)IBOutlet UILabel *labelFinishLive;
//
//弹出键盘的带出的view
@property(weak,nonatomic)IBOutlet UIView *keyBoardView;
@property(weak,nonatomic)IBOutlet UITextField *textFiled;

@property(assign,nonatomic)CGFloat liveNum; //浏览的人数
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.labelFinishLive.adjustsFontSizeToFitWidth = YES;
    
    [self initUI];
    [self initData];
    [self startPush];
    
    self.tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url ChatRoomId:(NSString *)roomId cId:(NSString *)cid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _pushUrl = url;
    _roomId = roomId;
    _cId = cid;
    return self;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- lazingLoad
//-(NSMutableArray *)aryChatData
//{
//    if (!_aryChatData)
//    {
//        _aryChatData = [NSMutableArray array];
//    }
//
//    return _aryChatData;
//}
-(NSMutableArray *)aryChatPeopleData
{
    if (!_aryChatPeopleData)
    {
        _aryChatPeopleData = [NSMutableArray array];
    }
    return _aryChatPeopleData;
}

#pragma mark- 初始化UI
-(void)initUI
{
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.backView.clipsToBounds = YES;
    self.backView.layer.cornerRadius = 20;
    self.headImageView.clipsToBounds = YES;
    self.headImageView.layer.cornerRadius = 16.f;
    
    NSString *url = [DoctorInfo shareDoctorInfo].member.headPic;
    
    if ([url hasPrefix:@"http"])
    {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    }
    else
    {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URLDomainName,url]] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    }
    
//    if ([DoctorInfo shareDoctorInfo].member.accountId == 47)
//    {
//        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URLImage,@"images/sjz_head.png"]] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
//    }
//    else
//    {
//       
//
//    }
//    
    
    self.labelNum.text = @"1";
    self.labelLiveEndNum.text = @"1";
    self.liveNum = 1;
    
    self.labelName.text = [DoctorInfo shareDoctorInfo].member.name;
    //
    
    self.btnBack.layer.cornerRadius = 20.f;
    self.btnBack.layer.borderWidth = 1.f;
    self.btnBack.layer.borderColor = NavitionBarColor.CGColor;
    self.btnBack.clipsToBounds = YES;
    
    self.liveEndView.hidden = YES;
    
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册tableviewcell
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DoctorMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"DoctorMsgTableViewCell"];
    //注册collectionViewCell
    
    //回复message的view
    [self.keyBoardView setFrame:CGRectMake(0, -50, ScreenWidth, 50)];
    self.keyBoardView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    [self.textFiled setFrame:CGRectMake(5, 0, ScreenWidth-5*2, 40)];
    self.textFiled.backgroundColor = [UIColor whiteColor];
    self.textFiled.placeholder = @"提问或者回复";
    self.textFiled.clipsToBounds = YES;
    self.textFiled.layer.cornerRadius = 8.f;
    self.keyBoardView.hidden = YES;

}
-(void)initData
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    [self.view addGestureRecognizer:tap];

    self.aryChatData = [NSMutableArray array];
    [self addKeyboardNotification];
    
    //加入聊天室
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    EMError *error;
    EMChatroom *chatRoom = [[EMClient sharedClient].roomManager joinChatroom:self.roomId error:&error];
    
    if (!error)
    {
        YGJLog(@"加入聊天室成功");
        self.labelNum.text = [NSString stringWithFormat:@"%zd",chatRoom.membersCount];
        self.labelLiveEndNum.text = [NSString stringWithFormat:@"%zd",chatRoom.membersCount];
    }
}

#pragma mark- 直播
//开始推流
-(void)startPush
{
    QPLConfiguration *configuration = [[QPLConfiguration alloc] init];
    configuration.url = self.pushUrl;
    configuration.videoMaxBitRate = 1500 * 1000;
    configuration.videoBitRate = 600 * 1000;
    configuration.videoMinBitRate = 400 * 1000;
    configuration.audioBitRate = 64 * 1000;
    configuration.videoSize = ScreenSize;// 横屏状态宽高不需要互换
    configuration.fps = 30;
    configuration.preset = AVCaptureSessionPresetiFrame1280x720;
    configuration.screenOrientation = 0;
    
    // 水印
    configuration.waterMaskImage = [UIImage imageNamed:@"water"];
    configuration.waterMaskLocation = 0;
    configuration.waterMaskMarginX = 20;
    configuration.waterMaskMarginY = 20;
    
//    if (_currentPosition) {
//        configuration.position = _currentPosition;
//    } else {
//        configuration.position = AVCaptureDevicePositionFront;
//        _currentPosition = AVCaptureDevicePositionFront;
//    }
    
    _liveSession = [[QPLiveSession alloc] initWithConfiguration:configuration];
    _liveSession.delegate = self;
    _liveSession.enableSkin = YES;
    
    
    [_liveSession startPreview];
    
    [_liveSession updateConfiguration:^(QPLConfiguration *configuration) {
        configuration.videoMaxBitRate = 1500 * 1000;
        configuration.videoBitRate = 600 * 1000;
        configuration.videoMinBitRate = 400 * 1000;
        configuration.audioBitRate = 64 * 1000;
        configuration.fps = 20;
    }];
    
    [_liveSession connectServer];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view insertSubview:[_liveSession previewView] atIndex:0];
    });

}
- (void)destroySession{
    
    [_liveSession disconnectServer];
    
    [_liveSession stopPreview];
    [_liveSession.previewView removeFromSuperview];
    
    _liveSession = nil;
}

#pragma mark- Action
-(IBAction)changeCamera:(id)sender
{
    [_liveSession rotateCamera];
}
-(IBAction)close:(id)sender
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定结束直播？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1001;
    
    [alertView show];
}
-(IBAction)message:(id)sender
{
    [self.textFiled becomeFirstResponder];
}
-(void)tap:(UITapGestureRecognizer *)gesture
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

-(IBAction)end:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- QPLiveSessionDelegate
- (void)liveSession:(QPLiveSession *)session error:(NSError *)error
{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *msg = [NSString stringWithFormat:@"%zd %@",error.code, error.localizedDescription];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Live Error" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"重新连接", nil];
//        alertView.delegate = self;
//        [alertView show];
//    });
}

- (void)liveSessionNetworkSlow:(QPLiveSession *)session
{
    YGJLog(@"网络太差");
    [MBProgressHUD showHideMessage:@"您的网络太差"];
}

- (void)liveSessionConnectSuccess:(QPLiveSession *)session
{
    YGJLog(@"连接推流器成功");
}

- (void)openAudioSuccess:(QPLiveSession *)session
{
    YGJLog(@"麦克风打开成功");
}

- (void)openVideoSuccess:(QPLiveSession *)session
{
    YGJLog(@"摄像头打开成功");
}


- (void)liveSession:(QPLiveSession *)session openAudioError:(NSError *)error
{
    YGJLog(@"麦克风获取失败");
    [MBProgressHUD showHideMessage:@"请在设置里面打开麦克风"];
}

- (void)liveSession:(QPLiveSession *)session openVideoError:(NSError *)error {
    
    YGJLog(@"摄像头获取失败");
    [MBProgressHUD showHideMessage:@"请在设置里面打开摄像头"];
}

- (void)liveSession:(QPLiveSession *)session encodeAudioError:(NSError *)error
{
    YGJLog(@"音频编码初始化失败");
    [MBProgressHUD showHideMessage:@"直播开启失败"];
}

- (void)liveSession:(QPLiveSession *)session encodeVideoError:(NSError *)error
{
    YGJLog(@"视频编码初始化失败");
    [MBProgressHUD showHideMessage:@"直播开启失败"];
}

- (void)liveSession:(QPLiveSession *)session bitrateStatusChange:(QP_LIVE_BITRATE_STATUS)bitrateStatus
{
    YGJLog(@"%ld",(long)bitrateStatus);
}
#pragma mark -AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1001)
    {
        if (buttonIndex == 1)
        {
            
            __weak typeof (self)weakSelf = self;
            [BGSever doctorFinishLiveWithId:self.cId Success:^(NSDictionary *getDic) {
                
                if ([getDic[@"code"] intValue] == 0)
                {
                    [weakSelf.liveSession disconnectServer];
                    weakSelf.liveSession = nil;
                    
                    weakSelf.liveEndView.hidden = NO;
                }
                else
                {
                    if ([getDic[@"data"] isKindOfClass:[NSString class]])
                    {
                        [MBProgressHUD showHideMessage:getDic[@"data"]];
                    }
                    else
                    {
                        [MBProgressHUD showHideMessage:@"结束直播失败"];
                    }
                }
                
            } Process:nil Fail:^(NSError *error) {
                [MBProgressHUD showHideMessage:@"结束直播失败"];
            }];
            
            

        }
    }
    
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [_liveSession connectServer];
    }
}
#pragma mark - ResignAndBecomeActiveNotification
- (void)appResignActive
{
    [self destroySession];
    
//    // 监听电话
//    _callCenter = [[CTCallCenter alloc] init];
//    _isCTCallStateDisconnected = NO;
//    _callCenter.callEventHandler = ^(CTCall* call) {
//        if ([call.callState isEqualToString:CTCallStateDisconnected])
//        {
//            _isCTCallStateDisconnected = YES;
//        }
//        else if([call.callState isEqualToString:CTCallStateConnected])
//            
//        {
//            _callCenter = nil;
//        }
//    };
    
}

- (void)appBecomeActive
{
    [self startPush];
}

#pragma mark - KeyboardNotification
- (void)addKeyboardNotification
{
    //键盘将要出现
    if([self respondsToSelector:@selector(keyboardWillShow:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    //    //输入法已经改变
    //    if([self respondsToSelector:@selector(keyboardDidChange:)]) {
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    //    }
    //键盘将要隐藏
    if([self respondsToSelector:@selector(keyboardWillHide:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    //程序是否激活
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

}
//键盘将要出现
- (void)keyboardWillShow:(NSNotification* )notification
{
    NSDictionary* userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo [UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardHeight = [value CGRectValue].size.height;
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        
        [weakSelf.keyBoardView setFrame:CGRectMake(0, ScreenHeight-keyBoardHeight-50, ScreenWidth, 50)];
        
    } completion:^(BOOL finished) {
        
        weakSelf.keyBoardView.hidden = NO;
    }];
}
//键盘将要消失
- (void)keyboardWillHide:(NSNotification* )notification
{
    NSDictionary* userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo [UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    __weak typeof (self)weakSelf = self;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        
        [weakSelf.keyBoardView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
        
    } completion:^(BOOL finished) {
        
       weakSelf.keyBoardView.hidden = YES;
    }];
    
}
#pragma mark- UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFiled resignFirstResponder];
    NSString *msg = self.textFiled.text;
    self.textFiled.text = @"";
    //发送消息
    if (![msg isEqualToString:@""])
    {
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:msg];
        NSString *from = [[EMClient sharedClient] currentUsername];
        
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:UESERNAME];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],IMIsDoctor,user,IMAccount,nil];
        
        [dic setObject:[DoctorInfo shareDoctorInfo].member.name forKey:IMName];
        
        
        //生成Message
        EMMessage *message = [[EMMessage alloc] initWithConversationID:self.roomId from:from to:self.roomId body:body ext:dic];
        message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
        
        
        __weak typeof (self)weakSelf = self;
        
        [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
            
            if (!error)
            {
                NSMutableDictionary *mutableDic =[NSMutableDictionary dictionaryWithDictionary:dic];
                [mutableDic setObject:msg forKey:IMMessage];
                [weakSelf.aryChatData addObject:mutableDic];
                
                if (weakSelf.aryChatData.count>50)
                {
                    [weakSelf.aryChatData removeObjectsInRange:NSMakeRange(0, 10)];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //消息列表始终滚动到最后一个消息
                    [weakSelf.tableview reloadData];
                    [weakSelf.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.aryChatData.count-1+10 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                });

            }
            
        }];
    }
    
    return YES;
}

#pragma mark- EMChatroomManagerDelegate
/*!
 *  接收到有用户加入聊天室
 *
 *  @param aChatroom    加入的聊天室
 *  @param aUsername    加入者username
 */
- (void)didReceiveUserJoinedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername
{
    
    self.labelNum.text = [NSString stringWithFormat:@"%zd",(aChatroom.membersCount/2)+1];
    self.liveNum = self.liveNum+0.5;
    self.labelLiveEndNum.text = [NSString stringWithFormat:@"%d",(int)ceilf(self.liveNum)];
}

/*!
 *  接收到有用户离开聊天室
 *
 *  @param aChatroom    离开的聊天室
 *  @param aUsername    离开者username
 */
- (void)didReceiveUserLeavedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername
{
    self.labelNum.text = [NSString stringWithFormat:@"%zd",(aChatroom.membersCount/2)+1];
   // self.labelLiveEndNum.text = [NSString stringWithFormat:@"%zd",[self.labelLiveEndNum.text intValue]-1];
}

/*!
 *  接收到被踢出聊天室
 *
 *  @param aChatroom    被踢出的聊天室
 *  @param aReason      被踢出聊天室的原因
 */
- (void)didReceiveKickedFromChatroom:(EMChatroom *)aChatroom
                              reason:(EMChatroomBeKickedReason)aReason
{
  //  self.labelNum.text = [NSString stringWithFormat:@"%zd",[self.labelNum.text intValue]+1];
}
#pragma mark- EMChatManagerDelegate
/*!
 *  \~chinese
 *  收到消息
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 *  \~english
 *  Delegate method will be invoked when receiving new messages
 *
 *  @param aMessages  Receivecd message list<EMMessage>
 */
- (void)messagesDidReceive:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages)
    {
        EMMessageBody *msgBody = message.body;
        NSDictionary *dic = message.ext;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [mutableDic setObject:txt forKey:IMMessage];
                [self.aryChatData addObject:mutableDic];
                __weak typeof (self)weakSelf = self;
                
                //最多保存50条消息，防止内存越来越大
                if (self.aryChatData.count>50)
                {
                    [self.aryChatData removeObjectsInRange:NSMakeRange(0, 10)];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //消息列表始终滚动到最后一个消息
                    [self.tableview reloadData];
                    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.aryChatData.count-1+10 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                });
            }
                break;
            case EMMessageBodyTypeImage:
            {
                // 得到一个图片消息body
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                //位置
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                // 音频sdk会自动下载
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                //视频
            }
                break;
            case EMMessageBodyTypeFile:
            {
                //文件
            }
                break;
                
            default:
                break;
        }
        
    }
}

/*!
 *  \~chinese
 *  收到Cmd消息
 *
 *  @param aCmdMessages  Cmd消息列表<EMMessage>
 *
 *  \~english
 *  Delegate method will be invoked when receiving command messages
 *
 *  @param aCmdMessages  Command message list<EMMessage>
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    for (EMMessage *message in aCmdMessages)
    {
        EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
        
        NSDictionary *dic = message.ext;
        if ([body.action isEqualToString:IMIsJoinRoom])
        {
            [self.aryChatData addObject:dic];
            __weak typeof (self)weakSelf = self;
            
            //最多保存50条消息，防止内存越来越大
            if (self.aryChatData.count>50)
            {
                [self.aryChatData removeObjectsInRange:NSMakeRange(0, 10)];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //消息列表始终滚动到最后一个消息
                [self.tableview reloadData];
                [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.aryChatData.count-1+10 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
            });
            
        }
        
    }

}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryChatData.count+10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<10)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        cell.textLabel.text = @"";
        cell.imageView.image = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    NSDictionary *dic = [self.aryChatData objectAt:indexPath.row-10];
    
    //加入聊天室的消息
    if (dic[IMIsJoinRoom] &&[dic[IMIsJoinRoom] boolValue])
    {
        if (dic[IMIsDoctor] && [dic[IMIsDoctor] intValue] == 1)
        {
            //医生
            DoctorMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorMsgTableViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *str = @"";
            //如果有昵称就显示昵称，没有就显示账号
            if (dic[IMName])
            {
                str = dic[IMName];
            }
            else
            {
                //手机号隐藏中间4位
                NSString *phone = dic[IMAccount];
                
                str = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#f7be35"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@进入房间",str];
            
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *str = @"";
            //如果有昵称就显示昵称，没有就显示账号
            if (dic[IMName])
            {
                str = dic[IMName];
            }
            else
            {
                //手机号隐藏中间4位
                NSString *phone = dic[IMAccount];
                
                str = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#f7be35"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@进入房间",str];
            
            return cell;
        }
    }
    
    if (dic[IMIsDoctor] && [dic[IMIsDoctor] intValue] == 1)
    {
        //医生
        DoctorMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorMsgTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *str = @"";
        //如果有昵称就显示昵称，没有就显示账号
        if (dic[IMName])
        {
            str = dic[IMName];
        }
        else
        {
            //手机号隐藏中间4位
            NSString *phone = dic[IMAccount];
            
            str = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@",str,dic[IMMessage]]];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#f7be35"] range:NSMakeRange(0, str.length+1)];
        
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffffff"] range:NSMakeRange(str.length, [[attributedText string] length]-str.length)];
        
        cell.labelMsg.attributedText = attributedText;
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *str = @"";
        //如果有昵称就显示昵称，没有就显示账号
        if (dic[IMName])
        {
            str = dic[IMName];
        }
        else
        {
            //手机号隐藏中间4位
            NSString *phone = dic[IMAccount];
            
            str = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@",str,dic[IMMessage]]];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#f7be35"] range:NSMakeRange(0, str.length+1)];
        
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffffff"] range:NSMakeRange(str.length, [[attributedText string] length]-str.length)];
        
        cell.textLabel.attributedText = attributedText;
        
        return cell;
    }
    
    
    return nil;
}
#pragma mark- UITableViewDelgate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}


@end
