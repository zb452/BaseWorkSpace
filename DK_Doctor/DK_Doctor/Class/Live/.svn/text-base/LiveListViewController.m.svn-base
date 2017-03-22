//
//  LiveListViewController.m
//  Ep_Paitent
//
//  Created by 张斌 on 2016/10/18.
//  Copyright © 2016年 陕西医管家医院管理咨询服务有限公司. All rights reserved.
//

#import "LiveListViewController.h"
#import <QPLive/QPLive.h>
#import "LiveListTableViewCell.h"
#import "MJRefresh.h"
#import "LiveViewController.h"
#import "Department.h"
#import "BGSever+Live.h"
#import "HMSegmentedControl.h"
#import "LiveDetailViewController.h"
#import "ExceptionStatusView.h"
#import "LiveDetail.h"


typedef enum
{
    DoctorLiveType =0, //医生直播
    DoctorPreachType    //宣讲
}LiveType;


#define kQPDomain @"http://duanqulive.s.qupai.me"//域名使用控制台空间管理自己的域名

@interface LiveListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, copy) NSString* pushUrl;
@property(nonatomic, copy) NSString* pullUrl;
@property(nonatomic, copy) NSString* recordUrl;

@property(weak,nonatomic)IBOutlet UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *aryDepartment; //所有的科室
@property(strong,nonatomic)NSMutableArray *aryLiveData; //直播数据源

@property(assign,nonatomic)NSInteger page;  //当前页面
@property(assign,nonatomic)NSInteger lastPage; //最大的页面
//@property(assign,nonatomic)NSMutableArray *aryLivePage;//所有科室直播的当前页
//@property(assign,nonatomic)NSMutableArray *aryLastPage;//所有科室直播的最后一页
//
@property(assign,nonatomic)NSInteger currnetIndex;//当前显示的科室直播索引
//@property(assign,nonatomic)NSMutableArray *aryIsGetData;//保存每一个科室是否已经请求过数据，  防止一次太多请求，需要的时候才去请求
@property(strong,nonatomic)ExceptionStatusView *errorView;//状态view

@end

@implementation LiveListViewController

#pragma mark- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initUI
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LiveListTableViewCell"];
  
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPullUpData)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getPullDownData)];
}
-(void)initData
{
    self.page = 1;
    [self getliveDepartment];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

#pragma mark- loadLazing


-(ExceptionStatusView *)errorView
{
    if (!_errorView)
    {
        _errorView = [ExceptionStatusView errorView];
    }
    
    return _errorView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray *ary = [self.aryLiveData objectAt:self.currnetIndex];
//    if (!ary)
//    {
//        return ary.count;
//    }
//    
//    return 0;
    
    
    return self.aryLiveData.count;
  //  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id data = [self.aryLiveData objectAt:indexPath.row];
    LiveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveListTableViewCell" forIndexPath:indexPath];
    [cell configWith:data];
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (310.f/370.f)*ScreenWidth+60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LiveDetailViewController *liveDetailVC = [[LiveDetailViewController alloc] initWithNibName:@"LiveDetailViewController" bundle:nil url:@"rtmp://play.lss.qupai.me/yiguanjia/yiguanjia-2188P?auth_key=1478694656-0-2866-44803d5864bd1ae8c00991f54a1fe585"];
//    [self.navigationController presentViewController:liveDetailVC animated:YES completion:nil];
}


#pragma mark- ************HTTP************
//上拉刷新
-(void)getPullUpData
{
  //  [self.tableView.mj_header beginRefreshing];
    self.page = 0;
    if (self.aryLiveData.count>0)
    {
        [self.aryLiveData removeAllObjects];
    }
    
    [self getLiveList];
}
//下拉刷新
-(void)getPullDownData
{
//    [self.tableView.mj_footer beginRefreshing];
//    [self getData];
    
     [self getLiveList];
}
//获取正在直播的数据
-(void)getData
{
    [self.tableView reloadData];
}
-(void)getliveDepartment
{
    __weak typeof (self)weakSelf = self;
    [BGSever getLiveDepartMentWithSuccess:^(NSDictionary *getDic) {
        
       [self.errorView dismiss];
        NSMutableArray *aryTitle = [NSMutableArray array];
        if ([getDic[@"code"] intValue] == 0)
        {
            
             NSMutableArray *mutableAry = [NSMutableArray array];
            if (getDic[@"data"] && [getDic[@"data"] isKindOfClass:[NSArray class]])
            {
               
                for (id data in getDic[@"data"])
                {
                    if ([data isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *dic = (NSDictionary *)data;
                        
                        Department *departMent = [Department modelObjectWithDictionary:dic];
                        
                        [aryTitle addObject:departMent.name];
                        
                        [mutableAry addObject:departMent];
                    }
                }
            }
            
            weakSelf.aryDepartment = [NSMutableArray arrayWithArray:mutableAry];
        }
        else
        {
            if ([getDic[@"data"] isKindOfClass:[NSString class]])
            {
                [MBProgressHUD showHideMessage:getDic[@"data"]];

            }
            else
            {
                [MBProgressHUD showHideMessage:@"获取直播的科室失败"];

            }
        }
        
        
        if (aryTitle.count>0)
        {
            HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:aryTitle];
            [segmentedControl setFrame:CGRectMake(0, 0, ScreenWidth-20*2, 40)];
            
            segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
            segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            segmentedControl.selectionIndicatorColor =[UIColor whiteColor];;
            segmentedControl.selectionIndicatorHeight = 3.0;
            segmentedControl.backgroundColor = [UIColor clearColor];
            segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
            segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:22]};
            
            self.navigationItem.titleView = segmentedControl;
            
            __weak typeof (self)weakSelf = self;
            [segmentedControl setIndexChangeBlock:^(NSInteger index) {
                
                weakSelf.page = 1;
                weakSelf.currnetIndex = index;
                
                [self getLiveList];
//                if (![[weakSelf.aryIsGetData objectAt:index] boolValue])
//                {
//                    [self getLiveList];
//                }
//                else
//                {
//                    [weakSelf.tableView reloadData];
//                }
                
            }];
            
            
            self.currnetIndex = 0;
            [self getLiveList];
        }
        else
        {
            //没有直播的科室
            self.title = @"直播";
            
            [self.errorView showInView:self.view type:ExceptionStatusTypeNoLive target:self action:nil];
        }
        
    } Process:nil Fail:^(NSError *error) {
        
        [MBProgressHUD showHideMessage:@"获取直播数据失败，请检查网络链接"];
      //  [self.errorView showInView:self.view type:ExceptionStatusTypeNoNetWork target:self action:@selector(getliveDepartment)];
    }];
}
-(void)getLiveList
{
    Department *department = [self.aryDepartment objectAt:self.currnetIndex];
    
    __weak typeof (self)weakSelf = self;
    
    [BGSever getLivelistWithDepartMent:[NSString stringWithFormat:@"%d",(int)department.departmentIdentifier] liveType:@"103101" Page:self.page Limit:5 Success:^(NSDictionary *getDic) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if ([getDic[@"code"] intValue] == 0)
        {
            weakSelf.page++;
            if ([getDic[@"data"] isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dic in getDic[@"data"])
                {
                    if ([dic isKindOfClass:[NSDictionary class]])
                    {
                        LiveDetail *model = [LiveDetail modelObjectWithDictionary:dic];
                        [weakSelf.aryLiveData addObject:model];
                    }
                }
                
                [weakSelf.tableView reloadData];
            }
            
            [weakSelf.tableView reloadData];
            //[weakSelf.aryIsGetData replaceObjectAtIndex:weakSelf.currnetIndex withObject:[NSNumber numberWithBool:YES]];
            
        }
        else
        {
            if ([getDic[@"data"] isKindOfClass:[NSString class]])
            {
                [MBProgressHUD showHideMessage:getDic[@"data"]];
                
            }
            else
            {
                [MBProgressHUD showHideMessage:@"获取直播数据失败"];
                
            }

        }
    } Process:nil Fail:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showHideMessage:@"获取直播数据失败，请检查网络链接"];
     //   [self.errorView showInView:self.view type:ExceptionStatusTypeNoNetWork target:self action:@selector(getliveDepartment)];
    }];

}

#pragma mark- Action
//开启直播
-(IBAction)startLive:(id)sender
{
    
    [BGSever createLiveWithMemberId:[NSString stringWithFormat:@"%d",(int)[DoctorInfo shareDoctorInfo].member.internalBaseClassIdentifier] Success:^(NSDictionary *getDic) {
        
        NSLog(@"%@",getDic);
        if ([getDic[@"code"] intValue] == 0)
        {
            NSString *url = getDic[@"data"][@"push"];
            if (url && ![url isEqualToString:@""])
            {
//                LiveViewController *liveVC = [[LiveViewController alloc] initWithNibName:@"LiveViewController" bundle:nil url:url];
//                
//                [self.navigationController presentViewController:liveVC animated:YES completion:nil];
            }
            else
            {
                [MBProgressHUD showHideMessage:@"创建直播失败"];
                
            }
        }
        else
        {
            if ([getDic[@"data"] isKindOfClass:[NSString class]])
            {
                [MBProgressHUD showHideMessage:getDic[@"data"]];
            }
            else
            {
                [MBProgressHUD showHideMessage:@"创建直播失败"];
            }
        }
        
    } Process:^(NSProgress *process) {
        
    } Fail:^(NSError *error) {
        
    }];
}

@end
