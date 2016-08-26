//
//  ZXYFileEncrypt.h
//  moviePlayerDemo
//
//  Created by 蓝泰致铭        on 16/7/12.
//  Copyright © 2016年 zhixueyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYFileEncrypt : NSObject

//加密文件
+ (void)encryptFileWithFilePath:(NSString*)filePath;

//解密文件
+ (void)decryptFileWithFilePath:(NSString*)filePath;

//是否是加密文件
+ (BOOL)IsEncryptFileWithFilePath:(NSString*)filePath;

@end
