//
//  MainViewController.m
//  图片查看器
//
//  Created by 李自杨 on 17/2/9.
//  Copyright © 2017年 View. All rights reserved.
//

#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height


#import "MainViewController.h"

@interface MainViewController ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *picScrollerView;
@property (nonatomic , strong) UIPageControl *pageControl;
@property (nonatomic , strong) dispatch_source_t timer;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Main";
    self.view.backgroundColor = [UIColor whiteColor];
    //创建图片轮播器
    [self createScrollerView];
    
    
    //定时器
    __block int count = 0;
    
    //获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建一个定时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置定时器的各种属性(几时开始任务，每隔多久执行一次)
    //gcd的时间参数一般为纳秒(1秒 == 10的9次方纳秒)
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(2.0 *NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"%@",[NSThread currentThread]);
        
        _picScrollerView.contentOffset = CGPointMake(KWidth * count, -64);
        
        count++;
        if (count == 13) {
            //取消定时器
//            dispatch_cancel(self.timer);
//            self.timer = nil;
            count = 0;
            _picScrollerView.contentOffset = CGPointMake(KWidth * count, -64);
        }
        
    });
    
    //启动定时器
    dispatch_resume(self.timer);
    
}

-(void)createScrollerView{

    //创建UIScrollView
    _picScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KWidth, KHeight - 164)];
    [self.view addSubview:_picScrollerView];
    _picScrollerView.delegate = self;
    _picScrollerView.backgroundColor = [UIColor blackColor];
    
    //设置内容大小,不允许垂直滚动
    _picScrollerView.contentSize = CGSizeMake(KWidth * 12, 0);
    //设置是否分页
    _picScrollerView.pagingEnabled = YES;
    //隐藏水平滚动条
    _picScrollerView.showsHorizontalScrollIndicator = NO;
    //隐藏垂直滚动条
    _picScrollerView.showsVerticalScrollIndicator = NO;

    
    for (int i = 0; i < 12; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(KWidth * i, -64, KWidth, KHeight - 164)];
        image.image= [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        
        [_picScrollerView addSubview:image];
    }
    
    //创建UIPageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _picScrollerView.bounds.size.height, KWidth, 50)];
    [self.view addSubview:_pageControl];
    
    //显示的页数
    _pageControl.numberOfPages = 12;
    //当前页
    _pageControl.currentPage = 0;
    //背景颜色
    _pageControl.backgroundColor = [UIColor clearColor];
    //当前点的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    //未被选中点的颜色
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //只有一页的时候隐藏
    _pageControl.hidesForSinglePage = YES;
    //点击事件
    [_pageControl addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)onClick:(UIPageControl *)sender{
    
    NSLog(@"这是第%ld张图片",sender.currentPage);
    _picScrollerView.contentOffset = CGPointMake(sender.currentPage * KWidth, -64);
    
}

#pragma mark -- ScrollerView代理方法
//scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.pageControl.currentPage = scrollView.contentOffset.x / KWidth;
    
}


// 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
// decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    CGPoint offset = _picScrollerView.contentOffset;
    CGRect bounds = _picScrollerView.frame;
    [_pageControl setCurrentPage:offset.x / bounds.size.width];
    
}


@end
