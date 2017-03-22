//
//  LiveDetailViewController.m
//  Ep_Paitent
//
//  Created by 张斌 on 2016/11/2.
//  Copyright © 2016年 陕西医管家医院管理咨询服务有限公司. All rights reserved.
//

#import "LiveDetailViewController.h"
#import <IJKMediaFramework/IJKFFMoviePlayerController.h>
#import "DoctorMsgTableViewCell.h"
#import "BGSever+Live.h"

#define IMName @"name"   //用户昵称
#define IMAccount @"acctounName" //用户账号
#define IMIsDoctor @"isDoctor"  //是否是医生
#define IMIsJoinRoom @"isJoinRoom"  //是否是用户进入聊天室的消息

#define LiveJoinRoom    @"JoinRoom"  //加入聊天室的消息

#define IMMessage @"message"    //用户发送的消息

#define RoomID  @"259905395940655528"

@interface LiveDetailViewController ()<EMChatroomManagerDelegate,EMChatManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(weak,nonatomic)IBOutlet UITableView *tableview;
@property(weak,nonatomic)IBOutlet UICollectionView *collectionView;
@property(weak,nonatomic)IBOutlet UIView *backView;
@property(weak,nonatomic)IBOutlet UIImageView *headImageView;
@property(weak,nonatomic)IBOutlet UILabel *labelName;
@property(weak,nonatomic)IBOutlet UILabel *labelNum;


@property(weak,nonatomic)IBOutlet UIView *liveEndView;//直播结束显示的页面
@property(weak,nonatomic)IBOutlet UILabel *labelLiveEndNum;
@property(weak,nonatomic)IBOutlet UIButton *btnBack;

@property(strong,nonatomic)NSString *pullUrl;//拉流url
@property(nonatomic,strong)IJKFFMoviePlayerController * player;

@property(strong,atomic)NSMutableArray *aryChatData;  //聊天内容
@property(strong,nonatomic)NSMutableArray *aryChatPeopleData; //直播间的人

@property(strong,nonatomic)UIImageView *bgImageView;
//
//弹出键盘的带出的view
@property(weak,nonatomic)IBOutlet UIView *keyBoardView;
@property(weak,nonatomic)IBOutlet UITextField *textFiled;

@property(strong,nonatomic)LiveDetail *liveDetail;

@property(weak,nonatomic)IBOutlet UILabel *labelFinishLive;


@property(assign,nonatomic)CGFloat liveNum; //房间的人数
@property(assign,nonatomic)CGFloat browerNum; //浏览的人数

@end

@implementation LiveDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.labelName.text = self.liveDetail.name;
    
    self.labelFinishLive.adjustsFontSizeToFitWidth = YES;
    
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.backView.clipsToBounds = YES;
    self.backView.layer.cornerRadius = 20;
    self.headImageView.clipsToBounds = YES;
    self.headImageView.layer.cornerRadius = 16.f;
    
    self.btnBack.layer.cornerRadius = 20.f;
    self.btnBack.layer.borderWidth = 1.f;
    self.btnBack.layer.borderColor = NavitionBarColor.CGColor;
    self.btnBack.clipsToBounds = YES;
    
    //注册tableviewcell
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DoctorMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"DoctorMsgTableViewCell"];
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
     [self.view insertSubview:self.bgImageView atIndex:0];

    
    NSString *url = self.liveDetail.headPic;
    
    if ([url hasPrefix:@"http"])
    {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    }
    else
    {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URLDomainName,url]] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    }

    
//    if (self.liveDetail.accountId == 47)
//    {
//        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URLImage,@"images/sjz_head.png"]] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
//    }
//    else
//    {
//           }
    
    self.liveEndView.hidden = YES;
    
    __weak typeof (self)weakSelf = self;
    [BGSever queryLiveDetailWithId:[NSString stringWithFormat:@"%d",(int)self.liveDetail.internalBaseClassIdentifier] Success:^(NSDictionary *getDic) {
        
        if ([getDic[@"code"] intValue] == 0)
        {
            if ([getDic[@"data"][@"liveStatus"] isEqualToString:@"102802"])
            {
                weakSelf.pullUrl = weakSelf.liveDetail.pullPath;
                
                [BGSever addChatRoomWithId:[NSString stringWithFormat:@"%d",(int)[DoctorInfo shareDoctorInfo].member.internalBaseClassIdentifier] ChatRoomId:[NSString stringWithFormat:@"%d",(int)self.liveDetail.cId] Success:^(NSDictionary *getDic) {
                    
                        EMError *error;
                       [[EMClient sharedClient].roomManager joinChatroom:self.liveDetail.restId error:&error];
                        
                        if (!error)
                        {
                            YGJLog(@"加入聊天室成功");
                            //self.labelNum.text = [NSString stringWithFormat:@"%zd 人在看",chatRoom.membersCount];
                        }

                    if ([getDic[@"code"] intValue] == 0)
                    {
                        weakSelf.labelNum.text = [NSString stringWithFormat:@"%@",getDic[@"data"][@"chatroomCount"]];
                        weakSelf.liveNum = [getDic[@"data"][@"chatroomCount"] floatValue];
                        weakSelf.browerNum = [getDic[@"data"][@"chatroomCount"] floatValue];
                        weakSelf.labelLiveEndNum.text = [NSString stringWithFormat:@"%@",getDic[@"data"][@"chatroomCount"]];
                    }
                    YGJLog(@"%@",getDic);
                    
                } Process:nil Fail:^(NSError *error) {
                    
                }];
                
                [weakSelf initUI];
                [weakSelf initData];
            }
            else
            {
                self.labelNum.text = [NSString stringWithFormat:@"%@",getDic[@"data"][@"chatroomCount"]];
                self.labelLiveEndNum.text = [NSString stringWithFormat:@"%@",getDic[@"data"][@"chatroomCount"]];
                weakSelf.btnBack.layer.cornerRadius = 20.f;
                weakSelf.btnBack.layer.borderWidth = 1.f;
                weakSelf.btnBack.layer.borderColor = NavitionBarColor.CGColor;
                weakSelf.btnBack.clipsToBounds = YES;
                weakSelf.labelLiveEndNum.text = [NSString stringWithFormat:@"%d",(int)weakSelf.liveDetail.chatroomCount];
                weakSelf.liveEndView.hidden = NO;
            }
            
        }
        else
        {
            [MBProgressHUD showHideMessage:@"查询直播失败"];
//            self.labelNum.text = [NSString stringWithFormat:@"%@",getDic[@"data"][@"chatroomCount"]];
//            self.labelLiveEndNum.text = [NSString stringWithFormat:@"%@",getDic[@"data"][@"chatroomCount"]];

            weakSelf.btnBack.layer.cornerRadius = 20.f;
            weakSelf.btnBack.layer.borderWidth = 1.f;
            weakSelf.btnBack.layer.borderColor = NavitionBarColor.CGColor;
            weakSelf.btnBack.clipsToBounds = YES;
            weakSelf.labelLiveEndNum.text = [NSString stringWithFormat:@"%d",(int)weakSelf.liveDetail.chatroomCount];
            weakSelf.liveEndView.hidden = NO;
        }
    } Process:nil Fail:^(NSError *error) {
        
        [MBProgressHUD showHideMessage:@"查询直播失败"];
        weakSelf.btnBack.layer.cornerRadius = 20.f;
        weakSelf.btnBack.layer.borderWidth = 1.f;
        weakSelf.btnBack.layer.borderColor = NavitionBarColor.CGColor;
        weakSelf.btnBack.clipsToBounds = YES;
        weakSelf.labelLiveEndNum.text = [NSString stringWithFormat:@"%d",(int)weakSelf.liveDetail.chatroomCount];
        weakSelf.liveEndView.hidden = NO;
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImageView *)bgImageView
{
    if (!_bgImageView)
    {
        _bgImageView = [[UIImageView alloc] initWithFrame:ScreenBounds];
        _bgImageView.image = [UIImage imageNamed:@"callBg@2x.png"];
    }
    
    return _bgImageView;
}

-(void)dealloc
{
    if (_player)
    {
        [_player shutdown];
        [_player.view removeFromSuperview];
        _player = nil;
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil LiveDetail:(LiveDetail *)liveDetail
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.liveDetail = liveDetail;
    return self;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.player)
    {
        [self.player prepareToPlay];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
}

#pragma mark- 初始化
-(void)initUI
{

    //播放直播
    IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置
    
    [options setPlayerOptionIntValue:8      forKey:@"framedrop"];  //跳帧
    [options setFormatOptionIntValue:8 forKey:@"skip_frame"];
    [options setPlayerOptionIntValue:0      forKey:@"start-on-prepared"];
    [options setPlayerOptionIntValue:48      forKey:@"skip_loop_filter"];
    [options setPlayerOptionIntValue:200000      forKey:@"analyzeduration"];
    [options setPlayerOptionIntValue:0      forKey:@"packet-buffering"];
    //    [options setFormatOptionValue:@"nobuffer" forKey:@"fflags"];
    [options setFormatOptionIntValue:4096 forKey:@"probsize"];

    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.pullUrl] withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = ScreenBounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
    [self.player prepareToPlay];
    
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    
    self.view.autoresizesSubviews = YES;
    
    [self.view insertSubview:self.player.view atIndex:0];
    
    //回复message的view
    [self.keyBoardView setFrame:CGRectMake(0, -50, ScreenWidth, 50)];
    self.keyBoardView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.f];
    [self.textFiled setFrame:CGRectMake(15, 0, ScreenWidth-15*2, 40)];
    self.textFiled.backgroundColor = [UIColor whiteColor];
    self.textFiled.clipsToBounds = YES;
    self.textFiled.layer.cornerRadius = 8.f;
    self.keyBoardView.hidden = YES;

}
-(void)initData
{
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    [self.view addGestureRecognizer:tap];
    
    self.aryChatData = [NSMutableArray array];

    
    //加入聊天室
    //聊天室
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    //加入聊天室的cmd消息,告诉聊天室的人我进来了
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:LiveJoinRoom];
    
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:UESERNAME];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],IMIsDoctor,user,IMAccount,[NSNumber numberWithBool:YES],IMIsJoinRoom,nil];
    [dic setNoNullObject:[DoctorInfo shareDoctorInfo].member.name forKey:IMName];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.liveDetail.restId from:from to:self.liveDetail.restId body:body ext:dic];
    message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    
    __weak typeof (self)weakSelf = self;
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        
    }];

   //
    //监听键盘消息
    [self addKeyboardNotification];
    [self installMovieNotificationObservers];

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

#pragma mark  Movie Notification Handlers
-(void)installMovieNotificationObservers
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    //程序是否激活
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
}
- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0)
    {
        //  NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        
        [self.bgImageView removeFromSuperview];
        self.bgImageView.hidden = YES;
        
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
        {
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            self.liveEndView.hidden = NO;
            if (_player)
            {
                [self.player shutdown];
                _player = nil;
            }
        }

            break;
            
        case IJKMPMovieFinishReasonUserExited:
        {
             NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            self.liveEndView.hidden = NO;
            if (_player)
            {
                [self.player shutdown];
                _player = nil;
            }
            
        }
           
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
        {
            //直播结束回回调
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            self.liveEndView.hidden = NO;
            if (_player)
            {
                [self.player shutdown];
                _player = nil;
            }
        }
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}
#pragma mark - ResignAndBecomeActiveNotification
- (void)appResignActive
{
    [self.player shutdown];
   // [self.player.view removeFromSuperview];
    _player = nil;
    
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
    
    //    if (_isCTCallStateDisconnected) {
    //        sleep(2);
    //    }
    
    //播放直播
    IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置
    
    [options setPlayerOptionIntValue:8      forKey:@"framedrop"];  //跳帧
    [options setFormatOptionIntValue:8 forKey:@"skip_frame"];
    [options setPlayerOptionIntValue:0      forKey:@"start-on-prepared"];
    [options setPlayerOptionIntValue:48      forKey:@"skip_loop_filter"];
    [options setPlayerOptionIntValue:200000      forKey:@"analyzeduration"];
    [options setPlayerOptionIntValue:0      forKey:@"packet-buffering"];
    //    [options setFormatOptionValue:@"nobuffer" forKey:@"fflags"];
    [options setFormatOptionIntValue:4096 forKey:@"probsize"];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.pullUrl] withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
    self.view.autoresizesSubviews = YES;
    
    [self.view insertSubview:self.player.view atIndex:0];
    [self.player prepareToPlay];
    
}

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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        
        [dic setNoNullObject:[DoctorInfo shareDoctorInfo].member.name forKey:IMName];
        
        //生成Message
        EMMessage *message = [[EMMessage alloc] initWithConversationID:self.liveDetail.restId from:from to:self.liveDetail.restId body:body ext:dic];
        message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
        
        
        __weak typeof (self)weakSelf = self;
        
        [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
            
                NSMutableDictionary *mutableDic =[NSMutableDictionary dictionaryWithDictionary:dic];
            [mutableDic setObject:msg forKey:IMMessage];
                [weakSelf.aryChatData addObject:mutableDic];
                
                if (weakSelf.aryChatData.count>50)
                {
                    [weakSelf.aryChatData removeObjectsInRange:NSMakeRange(0, 10)];
                }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //消息列表始终滚动到最后一个消息
                [self.tableview reloadData];
                [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.aryChatData.count-1+10 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
            });
        
        }];
        
        
        
    }
    
    return YES;
}

#pragma mark- Action
-(IBAction)close:(id)sender
{
    [self.player stop];
    _player = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.player stop];
    _player = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
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
    self.liveNum = self.liveNum+0.5;
    self.browerNum = self.browerNum+0.5;
    self.labelNum.text = [NSString stringWithFormat:@"%d",(int)ceilf(self.liveNum)];
    self.labelLiveEndNum.text = [NSString stringWithFormat:@"%d",(int)ceilf(self.browerNum)];
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
    self.liveNum = self.liveNum-1;
    self.labelNum.text = [NSString stringWithFormat:@"%d",(int)ceilf(self.liveNum)];
 //   self.labelLiveEndNum.text = [NSString stringWithFormat:@"%zd",[self.labelLiveEndNum.text intValue]-1];
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
                     [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.aryChatData.count-1+10 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                     
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
    if (indexPath.row-10)
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
            
            cell.labelMsg.textColor = [UIColor colorWithHexString:@"#f7be35"];
            cell.labelMsg.text = [NSString stringWithFormat:@"%@进入房间",str];
            
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

- (void)willOpenUrl:(IJKMediaUrlOpenData*) urlOpenData
{
    NSLog(@"%@",urlOpenData);
}

@end
