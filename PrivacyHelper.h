//
//  PrivacyHelper.h
//  BossZP
//
//  Created by 奎章 on 15/9/28.
//  Copyright © 2015年 com.dlnu.*. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrivacyHelper : NSObject
/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;

/**
 * 检查系统"相机以及麦克风"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开,带cancel回调
 */
+ (BOOL)checkVideoAuthorizationStatus:(EventHandler)cancelBlock;

/**
 * 检查系统"麦克风"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开
 */
+ (BOOL)checkAudioAuthorizationStatus;

+ (void)showSettingAlertStr:(NSString *)tipStr;
@end
