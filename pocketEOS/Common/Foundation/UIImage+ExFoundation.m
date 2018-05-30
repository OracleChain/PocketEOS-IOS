//
//  UIImage+ExFoundation.m
//  Giivv
//
//  Created by Xiong, Zijun on 16/4/16.
//  Copyright © 2016 Youdar . All rights reserved.
//

#import "UIImage+ExFoundation.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (ExFoundation)
#pragma mark - color turn to image
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - The compressed images under 12M
- (NSData *)compressedImgLess12M:(UIImage*)image{
    NSData *imageData = UIImageJPEGRepresentation(image,1);
    int i = 1;
    while ([imageData length]>12000000 && i < 100)
    {
        imageData = UIImageJPEGRepresentation(image,(double)(100-i)/100.0f);
        i++;
    }
    return imageData;
}

#pragma mark adjust iamge size
- (UIImage *)imageCompressForWidth:(CGFloat)defineWidth{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [self drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark 高斯模糊（毛玻璃）
+ (UIImage *)gaussBlur:(CGFloat)blurLevel{
    //获取当前屏幕的快照
    UIGraphicsBeginImageContextWithOptions(WINDOW.bounds.size, NO, 1.0);
    [WINDOW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    blurLevel = MIN(1.0,MAX(0.0, blurLevel));
    //int boxSize = (int)(blurLevel * 0.1 * MIN(self.size.width, self.size.height));
    int boxSize = 40;//模糊度。
    boxSize = boxSize - (boxSize % 2) + 1;
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1);
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    CGImageRef img = tmpImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *CGImageGetHeight(img));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    NSInteger windowR = boxSize/2;
    CGFloat sig2 = windowR / 3.0;
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    int32_t  sum = 0;
    for(NSInteger i=0; i<boxSize; ++i){
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        sum += kernel[i];
    }
    free(kernel);
    // convolution
    error = vImageConvolve_ARGB8888(&inBuffer, &outBuffer,NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend);
    error = vImageConvolve_ARGB8888(&outBuffer, &inBuffer,NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
    outBuffer = inBuffer;
    if (error) {
        //NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGBitmapAlphaInfoMask &kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef =CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    return returnImage;
}

#pragma mark - 第2种高斯模糊的方法
+ (UIImage *)gaussBlurMethod2: (UIView *) view{
    //获取当前屏幕的快照
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 1.0);
    [WINDOW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //高斯模糊
    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *inputImage = [[CIImage alloc] initWithImage: currentImage];
//    // create gaussian blur filter
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:inputImage forKey:kCIInputImageKey];
//    [filter setValue:[NSNumber numberWithFloat: 0.1f] forKey:@"inputRadius"];
//    // blur image
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    CGImageRelease(cgImage);
//    return image;
    CIImage *inputImage = [CIImage imageWithCGImage: currentImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage,                                         @"inputRadius", @(5.0f), nil];
    CIImage *outputImage = filter.outputImage;
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}

//- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
//    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage,                                         @"inputRadius", @(blur), nil];
//    CIImage *outputImage = filter.outputImage;
//    CGImageRef outImage = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
//    return [UIImage imageWithCGImage:outImage];

//}

+ (UIImage*)convertViewToImage:(UIView*)view{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
