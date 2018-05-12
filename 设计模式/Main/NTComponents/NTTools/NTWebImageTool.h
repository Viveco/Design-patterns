//
//  XWWebImageTool.h
//  TryLrc
//
//  Created by wazrx on 16/7/11.
//  Copyright © 2016年 wazrx. All rights reserved.
//  默认在内存警告和进入后台的时候回会清理内存

#import <UIKit/UIKit.h>
#import <YYWebImage/YYWebImageManager.h>
@class MKAnnotationView;

NS_ASSUME_NONNULL_BEGIN

@interface NTWebImageTool : NSObject

#pragma mark - CALayer

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL;

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL placeholder:(nullable UIImage *)placeholder;

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL options:(YYWebImageOptions)options;

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;


+ (void)nt_layerImageWith:(CALayer *)layer URL:(nullable NSString *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(nullable YYWebImageManager *)manager
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_layerCancelCurrentImageRequest:(CALayer *)layer;

#pragma mark - UIImageView

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL;

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL placeholder:(nullable UIImage *)placeholder;

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL options:(YYWebImageOptions)options;

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
               completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
                 progress:(nullable YYWebImageProgressBlock)progress
                transform:(nullable YYWebImageTransformBlock)transform
               completion:(nullable YYWebImageCompletionBlock)completion;


+ (void)nt_imageViewImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
                  manager:(nullable YYWebImageManager *)manager
                 progress:(nullable YYWebImageProgressBlock)progress
                transform:(nullable YYWebImageTransformBlock)transform
               completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL;

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL placeholder:(nullable UIImage *)placeholder;

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL options:(YYWebImageOptions)options;

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
                  placeholder:(nullable UIImage *)placeholder
                      options:(YYWebImageOptions)options
                   completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
                  placeholder:(nullable UIImage *)placeholder
                      options:(YYWebImageOptions)options
                     progress:(nullable YYWebImageProgressBlock)progress
                    transform:(nullable YYWebImageTransformBlock)transform
                   completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_imageViewHighlightedImageWith:(UIImageView *)imageView URL:(nullable NSString *)imageURL
                  placeholder:(nullable UIImage *)placeholder
                      options:(YYWebImageOptions)options
                      manager:(nullable YYWebImageManager *)manager
                     progress:(nullable YYWebImageProgressBlock)progress
                    transform:(nullable YYWebImageTransformBlock)transform
                              completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_imageViewCancelCurrentImageRequest:(UIImageView *)imageView;

+ (void)nt_imageViewCancelCurrentHighlightedImageRequest:(UIImageView *)imageView;

#pragma mark - UIButton

+ (void)nt_buttonImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder;

+ (void)nt_buttonImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                  forState:(UIControlState)state
                   options:(YYWebImageOptions)options;

+ (void)nt_buttonImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_buttonImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_buttonImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(nullable YYWebImageManager *)manager
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_buttonBackgroundImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder;

+ (void)nt_buttonBackgroundImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                             options:(YYWebImageOptions)options;

+ (void)nt_buttonBackgroundImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                          completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_buttonBackgroundImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                            progress:(nullable YYWebImageProgressBlock)progress
                           transform:(nullable YYWebImageTransformBlock)transform
                          completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_buttonBackgroundImageWith:(UIButton *)button URL:(nullable NSString *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                             manager:(nullable YYWebImageManager *)manager
                            progress:(nullable YYWebImageProgressBlock)progress
                           transform:(nullable YYWebImageTransformBlock)transform
                          completion:(nullable YYWebImageCompletionBlock)completion;


+ (void)nt_buttonCancelImageRequestFor:(UIButton *)button state:(UIControlState)state;

+ (void)nt_buttonCancelBackgroundImageRequestFor:(UIButton *)button state:(UIControlState)state;

#pragma mark - MKAnnotationView

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL;

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL placeholder:(nullable UIImage *)placeholder;

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL options:(YYWebImageOptions)options;

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
               completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
                 progress:(nullable YYWebImageProgressBlock)progress
                transform:(nullable YYWebImageTransformBlock)transform
               completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_annotationViewImageWith:(MKAnnotationView *)annotationView URL:(nullable NSString *)imageURL
              placeholder:(nullable UIImage *)placeholder
                  options:(YYWebImageOptions)options
                  manager:(nullable YYWebImageManager *)manager
                 progress:(nullable YYWebImageProgressBlock)progress
                transform:(nullable YYWebImageTransformBlock)transform
               completion:(nullable YYWebImageCompletionBlock)completion;

+ (void)nt_annotationViewCancelCurrentImageRequest:(MKAnnotationView *)annotationView;

#pragma mark - cache （只用于使用全局webImageMgr工具发送请求缓存得到的图片数据获取）

+ (nullable UIImage *)nt_cacheImageForURL:(NSString *)imageURL;

+ (nullable NSData *)nt_cacheImageDataForURL:(NSString *)imageURL;

+ (void)nt_setMaxMemoryCacheSizeWithSize:(CGFloat)maxSize;

+ (void)nt_setMaxDiskCacheSizeWithSize:(CGFloat)maxSize;

+ (void)nt_setMaxCacheAgeWithAge:(CGFloat)age;

+ (void)nt_clearMemory;

+ (void)nt_clearDisk;

+ (void)nt_downLoadImageWithImageURL:(NSString *)imageURL completion:(void(^)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
