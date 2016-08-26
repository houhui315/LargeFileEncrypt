//
//  ZXYFileEncrypt.m
//  moviePlayerDemo
//
//  Created by 蓝泰致铭        on 16/7/12.
//  Copyright © 2016年 zhixueyun. All rights reserved.
//

#import "ZXYFileEncrypt.h"

static const NSInteger KeyCount = 100;

static char arrayForEncode[KeyCount] = "763251983*dfefaefnok_@(03~!$-=)";

@implementation ZXYFileEncrypt


+ (void)encryptFileWithFilePath:(NSString*)filePath {
    
    if (![self checkFileIsExistWithFilePath:filePath]) {
        NSLog(@"路径为空");
        return;
    }
    
    BOOL isEncrypt = [self IsEncryptFileWithFilePath:filePath];
    if (isEncrypt == YES) {
        
        NSLog(@"文件已加密");
        return;
    }
    
    NSFileHandle *readHandle = [self fileHandleOfFilePath:filePath];
    
    //在文件末尾添加一个固定字符串标记加密文件
    [readHandle seekToEndOfFile];
    NSData *endBuffer = [NSData dataWithBytes:arrayForEncode length:strlen(arrayForEncode)];
    [readHandle writeData:endBuffer];
    [readHandle synchronizeFile];
    [readHandle closeFile];
    
    [self doOtherThingsWithFilePath:filePath];
}

+ (void)decryptFileWithFilePath:(NSString*)filePath {
    
    if (![self checkFileIsExistWithFilePath:filePath]) {
        NSLog(@"路径为空");
        return;
    }
    BOOL isEncrypt = [self IsEncryptFileWithFilePath:filePath];
    if (isEncrypt == NO) {
        
        NSLog(@"文件已解密");
        return;
    }
    
    NSFileHandle *readHandle = [self fileHandleOfFilePath:filePath];
    //去掉末位标记的固定字符串还原文件
    unsigned long long fileSize = [self GetfileSizeWithFilePath:filePath];
    [readHandle truncateFileAtOffset:fileSize - strlen(arrayForEncode)];
    [readHandle synchronizeFile];
    [readHandle closeFile];
    
    [self doOtherThingsWithFilePath:filePath];
}

+ (void)doOtherThingsWithFilePath:(NSString*)filePath {
    
    NSFileHandle *readHandle = [self fileHandleOfFilePath:filePath];
    
    //不管是加密还是解密都需要与或运算
    NSData *readBuffer = [readHandle readDataOfLength:KeyCount];
    unsigned char *cByte = (unsigned char*)[readBuffer bytes];
    for (int index = 0; (index < readBuffer.length) && (index < KeyCount) ; index++, cByte++) {
        *cByte = (*cByte) ^ arrayForEncode[index];
    }
    
    //在文件开始位置覆盖源内容
    [readHandle seekToFileOffset:0];
    [readHandle writeData:readBuffer];
    [readHandle synchronizeFile];
    
    //关闭文件
    [readHandle closeFile];
}

+ (NSFileHandle*)fileHandleOfFilePath:(NSString*)filePath {
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    NSAssert(fileHandle, @"打卡文件失败");
    return fileHandle;
}

+ (BOOL)checkFileIsExistWithFilePath:(NSString*)filePath {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }else{
        return NO;
    }
}

+ (unsigned long long)GetfileSizeWithFilePath:(NSString*)filePath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileDict = [fileManager attributesOfItemAtPath:filePath error:nil];
    unsigned long long fileSize = [fileDict fileSize];
    return fileSize;
}


+ (BOOL)IsEncryptFileWithFilePath:(NSString*)filePath{
    
    //读取文件末尾部分，看是否和全局的相同，相同则说明是加密过后的文件
    unsigned long long fileSize = [self GetfileSizeWithFilePath:filePath];
    unsigned long readLength = strlen(arrayForEncode);
    NSString *globalString = [[NSString alloc] initWithBytes:arrayForEncode length:readLength encoding:NSUTF8StringEncoding];
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    [readHandle seekToFileOffset:fileSize - readLength];
    
    NSData *buffer = [readHandle readDataOfLength:readLength];
    NSString *readBuffString = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
    [readHandle closeFile];
    
    return [readBuffString isEqualToString:globalString];
}

@end
