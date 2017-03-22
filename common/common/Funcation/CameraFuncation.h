//
//  CameraFuncation.h
//  Yiguanjia_Paitent
//
//  Created by 张斌 on 16/8/12.
//  Copyright © 2016年 张斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CameraFuncation : NSObject
//相机
+(UIImagePickerController *)takeCamera;
//访问相册
+(UIImagePickerController *)takePhoto;

//相册是否可用
+(BOOL)isPhotoLibraryAvailable;

@end
