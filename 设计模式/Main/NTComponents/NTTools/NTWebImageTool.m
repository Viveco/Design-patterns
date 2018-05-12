//
//  XWWebImageTool.m
//  TryLrc
//
//  Created by wazrx on 16/7/11.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NTWebImageTool.h"
#import "NTCatergory.h"
#import <YYWebImage.h>

#define nt_web_imgURL [NSURL URLWithString:[imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
#define imageCache [YYImageCache sharedCache]
#define imageMgr [YYWebImageManager sharedManager]

@implementation NTWebImageTool

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL {
    layer.yy_imageURL = nt_web_imgURL;
}

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL placeholder:(nullable UIImage *)placeholder {
    [layer yy_setImageWithURL:nt_web_imgURL placeholder:placeholder];
}

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL options:(YYWebImageOptions)options {
    [layer yy_setImageWithURL:nt_web_imgURL placeholder:nil options:options completion:nil];
}

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(nullable YYWebImageCompletionBlock)completion {
    [layer yy_setImageWithURL:nt_web_imgURL placeholder:placeholder options:options completion:completion];
}

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion {
    [layer yy_setImageWithURL:nt_web_imgURL placeholder:placeholder options:options progress:progress transform:transform completion:completion];
}

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(nullable YYWebImageManager *)manager
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                  completion:(nullable YYWebImageCompletionBlock)completion {
    [layer yy_setImageWithURL:nt_web_imgURL placeholder:placeholder options:options manager:manager progress:progress transform:transform completion:completion];
}



+ (void)nt_layerCancelCurrentImageRequest:(CALayer *)layer {
    [layer yy_cancelCurrentImageRequest];
}

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL {
    imageView.yy_imageURL = nt_web_imgURL;
}

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL placeholder:(nullable UIImage *)placeholder {
    [imageView yy_setImageWithURL:nt_web_imgURL placeholder:placeholder];
}

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL options:(YYWebImageOptions)options {
    [imageView yy_setImageWithURL:nt_web_imgURL options:options];
}

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
                   completion:(nullable YYWebImageCompletionBlock)completion {
    [imageView yy_setImageWithURL:nt_web_imgURL placeholder:placeholder options:options completion:completion];
}

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
                 progress:(nullable YYWebImageProgressBlock)progress
                transform:(nullable YYWebImageTransformBlock)transform
                   completion:(nullable YYWebImageCompletionBlock)completion {
    [imageView yy_setImageWithURL:nt_web_imgURL placeholder:placeholder options:options progress:progress transform:transform completion:completion];
}

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
                  manager:(nullable YYWebImageManager *)manager
                 progress:(nullable YYWebImageProgressBlock)progress
                transform:(nullable YYWebImageTransformBlock)transform
                   completion:(nullable YYWebImageCompletionBlock)completion {
    [imageView yy_setImageWithURL:nt_web_imgURL placeholder:placeholder options:options manager:manager progress:progress transform:transform completion:completion];
}

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL {
    imageView.yy_highlightedImageURL = nt_web_imgURL;
}

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL placeholder:(nullable UIImage *)placeholder {
    [imageView yy_setHighlightedImageWithURL:nt_web_imgURL placeholder:placeholder];
}

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL options:(YYWebImageOptions)options {
    [imageView yy_setHighlightedImageWithURL:nt_web_imgURL options:options];
}

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
                  placeholder:(nullable UIImage *)placeholder
                      options:(YYWebImageOptions)options
                   completion:(nullable YYWebImageCompletionBlock)completion {
    [imageView yy_setHighlightedImageWithURL:nt_web_imgURL placeholder:placeholder options:options completion:completion];
}

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
                  placeholder:(nullable UIImage *)placeholder
                      options:(YYWebImageOptions)options
                     progress:(nullable YYWebImageProgressBlock)progress
                    transform:(nullable YYWebImageTransformBlock)transform
                   completion:(nullable YYWebImageCompletionBlock)completion {
    [imageView yy_setHighlightedImageWithURL:nt_web_imgURL placeholder:placeholder options:options progress:progress transform:transform completion:completion];
}

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
                  placeholder:(nullable UIImage *)placeholder
                      options:(YYWebImageOptions)options
                      manager:(nullable YYWebImageManager *)manager
                     progress:(nullable YYWebImageProgressBlock)progress
                    transform:(nullable YYWebImageTransformBlock)transform
                   completion:(nullable YYWebImageCompletionBlock)completion {
    [imageView yy_setHighlightedImageWithURL:nt_web_imgURL placeholder:placeholder options:options manager:manager progress:progress transform:transform completion:completion];
}

+ (void)nt_imageViewCancelCurrentImageRequest:(UIImageView *)imageView {
    [imageView yy_cancelCurrentImageRequest];
}

+ (void)nt_imageViewCancelCurrentHighlightedImageRequest:(UIImageView *)imageView {
    [imageView yy_cancelCurrentHighlightedImageRequest];
}

+ (void)nt_buttonImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder {
    [button yy_setImageWithURL:nt_web_imgURL forState:state placeholder:placeholder];
}

+ (void)nt_buttonImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                  forState:(UIControlState)state
                   options:(YYWebImageOptions)options {
    [button yy_setImageWithURL:nt_web_imgURL forState:state options:options];
}

+ (void)nt_buttonImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(nullable YYWebImageCompletionBlock)completion {
    [button yy_setImageWithURL:nt_web_imgURL forState:state placeholder:placeholder options:options completion:completion];
}

+ (void)nt_buttonImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion {
    [button yy_setImageWithURL:nt_web_imgURL forState:state placeholder:placeholder options:options progress:progress transform:transform completion:completion];
}

+ (void)nt_buttonImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(nullable YYWebImageManager *)manager
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion {
    [button yy_setImageWithURL:nt_web_imgURL forState:state placeholder:placeholder options:options manager:manager progress:progress transform:transform completion:completion];
	
}

+ (void)nt_buttonBackgroundImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder {
    [button yy_setBackgroundImageWithURL:nt_web_imgURL forState:state placeholder:placeholder];
}

+ (void)nt_buttonBackgroundImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                             options:(YYWebImageOptions)options {
    [button yy_setBackgroundImageWithURL:nt_web_imgURL forState:state options:options];
	
}

+ (void)nt_buttonBackgroundImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                          completion:(nullable YYWebImageCompletionBlock)completion {
    [button yy_setBackgroundImageWithURL:nt_web_imgURL forState:state placeholder:placeholder options:options completion:completion];
}

+ (void)nt_buttonBackgroundImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                            progress:(nullable YYWebImageProgressBlock)progress
                           transform:(nullable YYWebImageTransformBlock)transform
                          completion:(nullable YYWebImageCompletionBlock)completion {
    [button yy_setBackgroundImageWithURL:nt_web_imgURL forState:state placeholder:placeholder options:options progress:progress transform:transform completion:completion];
}

+ (void)nt_buttonBackgroundImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                             manager:(nullable YYWebImageManager *)manager
                            progress:(nullable YYWebImageProgressBlock)progress
                           transform:(nullable YYWebImageTransformBlock)transform
                          completion:(nullable YYWebImageCompletionBlock)completion {
    [button yy_setBackgroundImageWithURL:nt_web_imgURL forState:state placeholder:placeholder options:options manager:manager progress:progress transform:transform completion:completion];
	
}

+ (void)nt_buttonCancelImageRequestFor:(UIButton *)button state:(UIControlState)state {
    [button yy_cancelImageRequestForState:state];
}

+ (void)nt_buttonCancelBackgroundImageRequestFor:(UIButton *)button state:(UIControlState)state {
    [button yy_cancelBackgroundImageRequestForState:state];
}

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL {
    annotationView.yy_imageURL = nt_web_imgURL;
}

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL placeholder:(nullable UIImage *)placeholder {
    [annotationView yy_setImageWithURL:nt_web_imgURL placeholder:placeholder];
}

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL options:(YYWebImageOptions)options {
    [annotationView yy_setImageWithURL:nt_web_imgURL options:options];
}

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
               completion:(nullable YYWebImageCompletionBlock)completion {
    [annotationView yy_setImageWithURL:nt_web_imgURL placeholder:placeholder options:options completion:completion];
}

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
                 progress:(nullable YYWebImageProgressBlock)progress
                transform:(nullable YYWebImageTransformBlock)transform
               completion:(nullable YYWebImageCompletionBlock)completion {
    [annotationView yy_setImageWithURL:nt_web_imgURL placeholder:placeholder options:options progress:progress transform:transform completion:completion];
}

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
                  manager:(nullable YYWebImageManager *)manager
                 progress:(nullable YYWebImageProgressBlock)progress
                transform:(nullable YYWebImageTransformBlock)transform
               completion:(nullable YYWebImageCompletionBlock)completion {
    [annotationView yy_setImageWithURL:nt_web_imgURL placeholder:placeholder options:options manager:manager progress:progress transform:transform completion:completion];
}

+ (void)nt_annotationViewCancelCurrentImageRequest:(MKAnnotationView *)annotationView {
    [annotationView yy_cancelCurrentImageRequest];
}

+ (UIImage *)nt_cacheImageForURL:(NSString *)imageURL {
    return [imageCache getImageForKey:[imageMgr cacheKeyForURL:nt_web_imgURL]];
}

+ (NSData *)nt_cacheImageDataForURL:(NSString *)imageURL{
    return [imageCache getImageDataForKey:[imageMgr cacheKeyForURL:nt_web_imgURL]];
}

+ (void)nt_setMaxMemoryCacheSizeWithSize:(CGFloat)maxSize {
    imageCache.memoryCache.costLimit = maxSize;
}

+ (void)nt_setMaxDiskCacheSizeWithSize:(CGFloat)maxSize {
    imageCache.diskCache.costLimit = maxSize;
}

+ (void)nt_setMaxCacheAgeWithAge:(CGFloat)age {
    imageCache.diskCache.ageLimit = age;
}

+ (void)nt_clearMemory {
    [imageCache.memoryCache removeAllObjects];
}

+ (void)nt_clearDisk {
    [imageCache.diskCache removeAllObjects];
}

+ (void)nt_downLoadImageWithImageURL:(NSString *)imageURL completion:(void (^)(UIImage *))completion{
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:imageURL] options:0 progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           NT_BLOCK(completion, image);
        });
    }];
}

@end
