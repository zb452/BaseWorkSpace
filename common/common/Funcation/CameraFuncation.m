//
//  CameraFuncation.m
//  Yiguanjia_Paitent
//
//  Created by 张斌 on 16/8/12.
//  Copyright © 2016年 张斌. All rights reserved.
//

#import "CameraFuncation.h"
#import <MobileCoreServices/MobileCoreServices.h>


@implementation CameraFuncation

//相机
+(UIImagePickerController *)takeCamera
{
    //初始化
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //设置类型
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置使用的多媒体类型
    NSArray *mediaTypeArray = [NSArray arrayWithObjects:(NSString *)kUTTypeImage,nil];
    imagePickerController.mediaTypes = mediaTypeArray;
    //设置是否可以管理已经存在的图片或者视频
    imagePickerController.allowsEditing = YES;
    //设置拍照和摄像时的下方的工具栏是否显示
    imagePickerController.showsCameraControls = YES;
    //拍照和摄像时的焦距
    imagePickerController.cameraViewTransform = CGAffineTransformScale(imagePickerController.cameraViewTransform, 1.0, 1.0);
   
    return imagePickerController;

}
//访问相册
+(UIImagePickerController *)takePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSArray *mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    imagePickerController.mediaTypes = mediaTypes;
    
    return imagePickerController;
}

//相册是否可用
+(BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}



@end
