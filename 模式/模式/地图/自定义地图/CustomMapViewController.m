//
//  CustomViewController.m
//  设计模式
//
//  Created by viveco on 2018/4/9.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "CustomMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CLLocation+Sino.h"

@interface CustomMapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationM;

@property (strong, nonatomic) MKMapView *mapView;

@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) UIButton *gecode;

@property (nonatomic, assign) CLLocationCoordinate2D myPlace;

@property (nonatomic, assign) CLLocationCoordinate2D finishPlace;

@end

@implementation CustomMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.geocoder = [[CLGeocoder alloc]init];
    
    self.gecode = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gecode setTitle:@"地理编码" forState:UIControlStateNormal];
    [self.gecode setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.gecode addTarget:self action:@selector(gecode:) forControlEvents:UIControlEventTouchUpInside];
    self.gecode.frame = CGRectMake(10, 600, 100, 30);
    [self.view addSubview:self.gecode];
    
    [self creatMap];
    [self location];
}
- (void)creatMap{
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 80, 375, 375)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(24 , 118), 300, 194) animated:YES];
    [self.view addSubview:self.mapView];
    
    UILongPressGestureRecognizer *gest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    [self.mapView addGestureRecognizer:gest];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender{

    //获取触摸的点
    CGPoint point = [sender locationInView:self.mapView];
    //通过触摸的点获取经纬度
    CLLocationCoordinate2D coord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    self.finishPlace = coord;
    //组装参数
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    //获取信息
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //获取位置
        if (placemarks.count != 0) {
            CLPlacemark *placeMark = placemarks.firstObject;

            NSArray *addressArray = placeMark.addressDictionary[@"FormattedAddressLines"];

            //拼接地址
            NSMutableString *address = [[NSMutableString alloc] init];

            for (int i = 0; i < addressArray.count; i ++) {
                [address appendString:addressArray[i]];
            }

            MKPointAnnotation *anno = [[MKPointAnnotation alloc] init];
            anno.title = placeMark.name;
            anno.subtitle = address;
            anno.coordinate = coord;
            [self.mapView addAnnotation:anno];
        }

    }];
}
- (void)gecode:(UIButton * )sender{
    
//    [self.geocoder geocodeAddressString:@"重庆" completionHandler:^(NSArray *placemarks, NSError *error) {
//        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
//        CLPlacemark *placemark=[placemarks firstObject];
//        CLLocation *location=placemark.location;//位置
//        CLRegion *region=placemark.region;//区域
//        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
//        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
//    }];
    
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.myPlace addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:self.finishPlace addressDictionary:nil];
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    [self findDirectionsFrom:fromItem to:toItem];
}
-(void)findDirectionsFrom:(MKMapItem *)from to:(MKMapItem *)to{
    
//    NSDictionary *launchDic = @{
//                                MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
//                                MKLaunchOptionsMapTypeKey : @(MKMapTypeHybridFlyover),
//                                MKLaunchOptionsShowsTrafficKey : @(YES),
//                                };
//    [MKMapItem openMapsWithItems:@[from,to] launchOptions:launchDic]; // 调用系统自带的方法
    
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = from;
    request.destination = to;
    request.transportType = MKDirectionsTransportTypeWalking;

    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    //ios7获取绘制路线的路径方法
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error info:%@", error.userInfo[@"NSLocalizedFailureReason"]);
        }
        else {
            [response.routes enumerateObjectsUsingBlock:^(MKRoute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.mapView addOverlay:obj.polyline];
                [obj.steps enumerateObjectsUsingBlock:^(MKRouteStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSLog(@"%@",obj.instructions);
                }];
            }];
            
//            for (MKRoute *route in response.routes) {
//
//                //                MKRoute *route = response.routes[0];
//                for(id<MKOverlay> overLay in self.mapView.overlays) {
//                    [self.mapView removeOverlay:overLay];
//                }
//
//                [self.mapView addOverlay:route.polyline level:0];
//                double lat = self.mapView.region.center.latitude;
//                double lon = self.mapView.region.center.longitude;
//                double latDelta = self.mapView.region.span.latitudeDelta * 100000;
//                double lonDelta = self.mapView.region.span.longitudeDelta * 100000;
//                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(lat , lon), 200, 126)
//                                   animated:YES];
//            }

        }
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    

    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    [_mapView setRegion:region animated:true];
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    self.myPlace = point.coordinate;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation{

    MKPinAnnotationView *annotationView =(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN"];
    if(annotationView==nil) {
        annotationView =(MKPinAnnotationView *)[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN"];
    }

    UIImageView *imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    imageView.frame=CGRectMake(0,0,50,50);
    annotationView.leftCalloutAccessoryView=imageView;
    annotationView.canShowCallout=YES;
    annotationView.animatesDrop=YES;
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0,0,30,30)];
    label.text=@">>";
    annotationView.rightCalloutAccessoryView=label;

    annotationView.pinTintColor = [UIColor greenColor];

    return annotationView;

}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"%@",[view.annotation title]);
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"%@",[view.annotation title]);
}
//
////覆盖物的回调方法

-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5;
    renderer.strokeColor = HEX_RGBA(0xf26f5f, 1);
    return renderer;
}





- (void)location{
    _locationM = [[CLLocationManager alloc] init];
    [_locationM requestWhenInUseAuthorization];
    _locationM.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationM.distanceFilter = 10.0;
    _locationM.delegate = self;
    
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [_locationM requestAlwaysAuthorization];
    }
    [_locationM startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        CLLocation * location = [locations firstObject];
        [location locationMarsFromEarth];
        NSLog(@"%@",[NSString stringWithFormat:@"%3.5f",location.coordinate.latitude]);
        NSLog(@"%@",[NSString stringWithFormat:@"%3.5f",location.coordinate.longitude]);
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            // 用户还未决定
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定");
            break;
        }
            // 问受限
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
            // 定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled])
            {
                NSLog(@"定位开启，但被拒");
            }else
            {
                NSLog(@"定位关闭，不可用");
            }
            //            NSLog(@"被拒");
            break;
        }
            // 获取前后台定位授权
        case kCLAuthorizationStatusAuthorizedAlways:
            //        case kCLAuthorizationStatusAuthorized: // 失效，不建议使用
        {
            NSLog(@"获取前后台定位授权");
            break;
        }
            // 获得前台定位授权
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台定位授权");
            break;
        }
        default:
            break;
    }
}

@end
