//
//  ViewController.m
//  UIScrollView
//
//  Created by zhangys on 15/12/19.
//  Copyright © 2015年 zhangys. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView1;//用于滚动一张图片
@property (nonatomic, strong) UIScrollView * scrollView2;//用于滚动多张图片
@property (nonatomic, strong) UIScrollView * scrollView3;//用于缩放一张图片

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self scrollOneImage];
    [self scrollManyImages];
    [self scaleOneImage];
}

/**
 *  1：一张超过scrollView尺寸图片的滚动（其实是imageView）
 */
- (void)scrollOneImage
{
    //1：实例化scrollView和UIImageView，并把imageView添加到scrollView上面
    //准备一张大尺寸图片，并把它放在imageView上，且要注意，如果图片尺寸太大，可能不显示
    UIImage * image = [UIImage imageNamed:@"apple3"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    self.scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 100)];//scrollView本身还是那么大，通过属性设置一共的滚动范围
    [self.scrollView1 addSubview:imageView];
    
    //2：设置必须设置的属性
    self.scrollView1.contentSize = imageView.bounds.size;//滚动范围，和图片的尺寸一样
    
    //3：把imageView添加到scrollView上，把scrollView添加到self.view上
    [self.view addSubview:self.scrollView1];
    
    //0：可选设置的属性
    self.scrollView1.scrollEnabled = YES;//默认为YES，如果要暂时关闭拖动，可以设置为NO
    self.scrollView1.contentOffset = CGPointZero;//偏移量，默认为0
    self.scrollView1.showsHorizontalScrollIndicator = NO;//水平滚动条，默认打开
    self.scrollView1.showsVerticalScrollIndicator = NO;//竖直滚动条，默认打开
    self.scrollView1.bounces = NO;//设置是否回弹，默认是YES
    //0：如果需要可以设置代理
    self.scrollView1.delegate = self;

}

/**
 *  2：多张图片的滚动
 */
- (void)scrollManyImages
{
    //1：实例化scrollView和UIImageView，并把imageView添加到scrollView上面
    //注意scrollView的frame，就是展示给用户的大小。可以理解为一个窗口，后面有很多imageView待展示。
    self.scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 360, self.view.frame.size.width, self.view.frame.size.height - 360)];
    for (int i = 1; i <= 5; i++) {
        NSString * imageName = [NSString stringWithFormat:@"scrollView%d.jpg", i];
        UIImage * image = [UIImage imageNamed:imageName];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i - 1) * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 360)];
        imageView.image = image;
        [self.scrollView2 addSubview:imageView];
    }
    
    //2：设置必须设置的属性
    self.scrollView2.contentSize = CGSizeMake(self.view.frame.size.width * 5, 0);//滚动范围
    //pagingEnabled属性意义是如果设置为YES，则在一个视图的边界或者倍数的时候会停下来，如果不设置，它就会把5张图片当成一张处理，停在哪看你滚动的力度。
    self.scrollView2.pagingEnabled = YES;
    
    //3：父视图来添加
    [self.view addSubview:self.scrollView2];

    //0：最好关掉的属性
    self.scrollView2.showsHorizontalScrollIndicator = NO;
    self.scrollView2.showsVerticalScrollIndicator = NO;
    //0：如果需要可以设置代理
    self.scrollView2.delegate = self;
    
}


/**
 *  3：缩放一张图片
 */
- (void)scaleOneImage
{
    //1：实例化scrollView和UIImageView，并把imageView添加到scrollView上面
    UIImage * image = [UIImage imageNamed:@"headImage"];//准备一张图片
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    self.scrollView3 = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 200, 150, 150)];
    [self.scrollView3 addSubview:imageView];
    
    //2：设置必须设置的属性
    self.scrollView3.maximumZoomScale = 5;
    self.scrollView3.minimumZoomScale = 0.5;
    
    //3：设置代理
    self.scrollView3.delegate = self;
    
    //4：添加
    [self.view addSubview:self.scrollView3];

    //0：如果代理中那么使用，这两个必须关掉
    self.scrollView3.showsHorizontalScrollIndicator = NO;
    self.scrollView3.showsVerticalScrollIndicator = NO;//这两个必须关掉，不然它是scrollView的子视图
}







#pragma mark - UIScrollVIewDelegate

//1：第一种用法和第三种用法的代理方法，实现一张图片的拖动，或者多张图片的滚动（本质一样）

//将要开始拖动调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"willBeginDrag");
}
//拖动过程中调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"didScroll");
}
//将要结束拖动时调用
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"willEndDrag");
}
//已经结束拖动时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"didEndDrag");
}




//2：第三种用法的代理方法：实现图片的放大缩小

/**
 *  当在scrollView的子view上使用捏合手势时，会自动调用这个方法
 *
 *  @param scrollView 如果有多个scrollView，这个参数就是在哪个scrollView上进行操作
 *
 *  @return 返回的就是要缩放的那张图片（imageView）
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scrollView3.subviews.lastObject;
}

/**
    开始缩放的时候调用此方法
 */
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    NSLog(@"willBeginZooming");
}
/**
    缩放过程中调用此方法
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"didZoom");
}

/**
    结束缩放的时候调用此方法
 */
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"didEndZooming");
}

























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
