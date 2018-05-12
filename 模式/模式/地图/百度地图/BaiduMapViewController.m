//
//  BaiduMapViewController.m
//  设计模式
//
//  Created by viveco on 2018/4/9.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "BaiduMapViewController.h"
#import "CLLocation+Sino.h"
#import "BMKClusterManager.h"


/*
 *点聚合Annotation
 */
@interface ClusterAnnotation : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, assign) NSInteger size;

@end

@implementation ClusterAnnotation

@synthesize size = _size;

@end


/*
 *点聚合AnnotationView
 */
@interface ClusterAnnotationView : BMKPinAnnotationView {
    
}

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ClusterAnnotationView

@synthesize size = _size;
@synthesize label = _label;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:11];
        _label.textAlignment = NSTextAlignmentCenter;
       
        [self addSubview:_label];
        self.alpha = 0.85;
    }
    return self;
}

- (void)setSize:(NSInteger)size {
    _size = size;
    if (_size == 1) {
        self.label.hidden = YES;
        self.pinColor = BMKPinAnnotationColorRed;
        return;
    }
    self.label.hidden = NO;
    if (size > 20) {
        self.label.backgroundColor = [UIColor redColor];
    } else if (size > 10) {
        self.label.backgroundColor = [UIColor purpleColor];
    } else if (size > 5) {
        self.label.backgroundColor = [UIColor blueColor];
    } else {
        self.label.backgroundColor = [UIColor greenColor];
    }
    _label.text = [NSString stringWithFormat:@"%ld", size];
}

@end










@interface BaiduMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate>

{
    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
}

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) BMKLocationService *locService;

@property (strong, nonatomic) BMKPointAnnotation *pointAnnotation;


@end

@implementation BaiduMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self creatMap];
    [self creatLocService];
//    [self pathPlanning];
    [self clusterCaches];
}

- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
}
- (void)viewDidDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}
- (void)creatMap{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 80, 375, 400)];
    [_mapView setMapType:BMKMapTypeStandard];
    [_mapView setTrafficEnabled: YES];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    [self.view addSubview:self.mapView];
    

//    BMKLocationViewDisplayParam *userlocationStyle = [[BMKLocationViewDisplayParam alloc] init];
//    userlocationStyle.accuracyCircleStrokeColor = [UIColor redColor];//精度圈 边框颜色
//    userlocationStyle.accuracyCircleFillColor = [UIColor cyanColor];//精度圈 填充颜色
//    userlocationStyle.locationViewImgName = @"15.png";//定位图标名称，需要将该图片放到 mapapi.bundle/images 目录下
//    [_mapView updateLocationViewWithParam:userlocationStyle];
//
//    _pointAnnotation = [[BMKPointAnnotation alloc] init];
//    _pointAnnotation.title = @"您的位置";
//    _pointAnnotation.subtitle = @"当前所在位置";
//    [_mapView addAnnotation:self.pointAnnotation];
//
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    annotation.coordinate = CLLocationCoordinate2DMake(39.915, 116.404);
//    annotation.title = @"这里是北京";
//    [_mapView addAnnotation:annotation];
//
}
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        BMKPinAnnotationView*annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil) {
//            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        annotationView.pinColor = BMKPinAnnotationColorPurple;
//        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
//        // 设置图片
////        annotationView.image = [UIImage imageNamed:@"位置.png"];
//        // 设置paopao
////        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
////        label.text = @">>";
////        label.textColor = [UIColor greenColor];
////        BMKActionPaopaoView * popo = [[BMKActionPaopaoView alloc] initWithCustomView:label];
////        annotationView.paopaoView = popo;
//        return annotationView;
//    }else{
//        return nil;
//    }
//}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView * polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = CFBridgingRelease([UIColor redColor].CGColor);
        polylineView.lineWidth = 2.0;
        return polylineView;
    }else{
        return nil;
    }
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"%lf",mapView.zoomLevel);
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    NSLog(@"点击了")
}
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    NSLog(@"长按了");
}
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState fromOldState:(BMKAnnotationViewDragState)oldState{
    NSLog(@"拖动大头针了");
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"%@",view.annotation.title);
}



#pragma mark --定位==================================================================
- (void)creatLocService{
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    _locService.distanceFilter = 100;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.headingFilter = kCLHeadingFilterNone;
    [_locService startUserLocationService];
}

- (void)willStartLocatingUser{
    
}
- (void)didStopLocatingUser;{
    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    
    
    
    //从manager获取左边
    CLLocation *location = userLocation.location;
    [location locationMarsFromEarth];
    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
    self.pointAnnotation.coordinate = coordinate;
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.02f, 0.02f));
    viewRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:viewRegion animated:YES];
  
    
}
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"%@",error);
}

#pragma mark --  路线规划 问题
- (void)pathPlanning{
    
    BMKRouteSearch * routeSearhe =[[BMKRouteSearch alloc] init];
    //设置delegate，用于接收检索结果
    routeSearhe.delegate = self;

    BMKPlanNode* start = [[BMKPlanNode alloc] init];
    start.name = @"北京";
    start.cityName = @"天安门";
//    start.pt.x start.pt.y  经纬度
    
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.name = @"天津";
    end.cityName = @"天津站";
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc] init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [routeSearhe walkingSearch:walkingRouteSearchOption];
    if (flag) {
        NSLog(@"walk检索发送成功");
    } else{
        NSLog(@"walk检索发送失败");
    }
}

-(void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error {
        NSLog(@"onGetWalkingRouteResult error:%d", (int)error);
        if (error == BMK_SEARCH_NO_ERROR) {
            //成功获取结果
        } else {
            //检索失败
        }
}

#pragma mark -- 点聚合管理======================================================================
- (void)clusterCaches{
    
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i < 22; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    
    //点聚合管理类
    _clusterManager = [[BMKClusterManager alloc] init];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(29.5, 106.404);
    //向点聚合管理类中添加标注
    for (NSInteger i = 0; i < 20; i++) {
        double lat =  (arc4random() % 100) * 0.001f;
        double lon =  (arc4random() % 100) * 0.001f;
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        clusterItem.coor = CLLocationCoordinate2DMake(coor.latitude + lat, coor.longitude + lon);
        [_clusterManager addClusterItem:clusterItem];
    }
}

//更新聚合状态
- (void)updateClusters {
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:(_clusterZoom - 3)];
        
        if (clusters.count > 0) {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                ///获取聚合后的标注
                __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (BMKCluster *item in array) {
                        ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        annotation.title = [NSString stringWithFormat:@"我是%ld个", item.size];
                        [clusters addObject:annotation];
                    }
                    [_mapView removeAnnotations:_mapView.annotations];
                    [_mapView addAnnotations:clusters];
                });
            });
        }
    }
}

#pragma mark - BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    NSString *AnnotationViewID = @"ClusterMark";
    ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;
    ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    annotationView.size = cluster.size;
    annotationView.draggable = YES;
    annotationView.annotation = cluster;
    return annotationView;
    
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    if ([view isKindOfClass:[ClusterAnnotationView class]]) {
        ClusterAnnotation *clusterAnnotation = (ClusterAnnotation*)view.annotation;
        if (clusterAnnotation.size > 1) {
            [mapView setCenterCoordinate:view.annotation.coordinate];
            [mapView zoomIn];
        }
    }
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self updateClusters];
}
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel) {
        [self updateClusters];
    }
}

@end
