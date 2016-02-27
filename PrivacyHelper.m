//
//  PrivacyHelper.m
//  BossZP
//
//  Created by 奎章 on 15/9/28.
//  Copyright © 2015年 com.dlnu.*. All rights reserved.
//

#import "PrivacyHelper.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
@import AVFoundation;



@implementation PrivacyHelper
+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
#pragma mark - 9.0以前版本适用
    if (YES) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (ALAuthorizationStatusDenied == authStatus ||
            ALAuthorizationStatusRestricted == authStatus) {
            [PrivacyHelper showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”选项中,允许your APP访问你的相册。"];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        showAlertMessage(@"该设备不支持拍照");
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [PrivacyHelper showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”选项中,允许your APP访问你的相机。"];
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)checkVideoAuthorizationStatus:(EventHandler)cancelBlock
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        showAlertMessage(@"该设备不支持拍照");
        return NO;
    }
    
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    __block BOOL canAcceptAudio = NO;
    BOOL canAcceptCamera = NO;
    NSString *alertStr = @"请在iPhone的“设置->隐私->相机”选项中,允许your APP访问你的相机。";
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [avSession requestRecordPermission:^(BOOL available) {
            if (available) {
                canAcceptAudio = YES;
            }
            else
            {
                canAcceptAudio = NO;
            }
            
        }];
        
    }
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            canAcceptCamera = NO;
        }else{
            canAcceptCamera = YES;
        }
    }
    
    if (!canAcceptCamera||!canAcceptAudio) {
        if (!canAcceptAudio&&!canAcceptCamera) {
            alertStr = @"请在iPhone的“设置->隐私”选项中,允许your APP访问你的摄像头和麦克风。";
        }else if (!canAcceptAudio){
            alertStr = @"请在iPhone的“设置->隐私->麦克风”选项中,允许your APP访问你的麦克风。";
        }
        //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            CTAlertView *alert = [[CTAlertView shareCTAlert] initWithTitle:@"提示" message:alertStr DelegateBlock:^(UIAlertView *alert, int index) {
                if (index == 1) {
                    UIApplication *app = [UIApplication sharedApplication];
                    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([app canOpenURL:settingsURL]) {
                        [app openURL:settingsURL];
                    }
                }else if (index == 0){
                    BlockCallWithOneArg(cancelBlock, nil);
                }
                
            } cancelButtonTitle:@"取消" otherButtonTitles:@"设置"];
            [alert show];
        }else{
            showAlertMessage(alertStr);
        }
        return NO;
    }
    return YES;
}

+ (void)showSettingAlertStr:(NSString *)tipStr{
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        CTAlertView *alert = [[CTAlertView shareCTAlert] initWithTitle:@"提示" message:tipStr DelegateBlock:^(UIAlertView *alert, int index) {
            if (index == 1) {
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([app canOpenURL:settingsURL]) {
                    [app openURL:settingsURL];
                }
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"设置"];
        [alert show];
    }else{
        showAlertMessage(tipStr);
    }
}


+ (BOOL)checkAudioAuthorizationStatus
{
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    __block BOOL canAccept = NO;
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        [avSession requestRecordPermission:^(BOOL available) {
            if (available) {
                //completionHandler
                canAccept = YES;
            }
            else
            {
                canAccept = NO;
                [PrivacyHelper showSettingAlertStr:@"请在iPhone的“设置->隐私->麦克风”选项中,允许your APP访问你的麦克风。"];
            }
            
        }];
        
    }
    return canAccept;
}
@end
