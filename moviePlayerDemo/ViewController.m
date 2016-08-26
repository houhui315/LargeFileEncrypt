//
//  ViewController.m
//  moviePlayerDemo
//
//  Created by 蓝泰致铭        on 16/3/18.
//  Copyright © 2016年 zhixueyun. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZXYFileEncrypt.h"

NSString *fileName = @"测试视频文件.mp4";

@interface ViewController (){
    
    NSString *filePath;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"播放视频" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moviePlaye:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(100, 100, 100, 40)];
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"加密" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(encrypt:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrame:CGRectMake(100, 100+100, 100, 40)];
    [button2 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"解密" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(decrypt:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setFrame:CGRectMake(100, 100+200, 100, 40)];
    [button3 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button3];
    
    NSString *filePath1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath1 = [filePath1 stringByAppendingPathComponent:fileName];
    filePath = filePath1;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault objectForKey:@"First"]) {
        
        NSString *filePaths = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        [[NSFileManager defaultManager] copyItemAtPath:filePaths toPath:filePath1 error:nil];
        
        [userDefault setObject:@"yes" forKey:@"First"];
    }
    
}

-(void)moviePlaye:(id)sender{
    
    if ([ZXYFileEncrypt IsEncryptFileWithFilePath:filePath]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"文件已加密" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
    [movie.moviePlayer prepareToPlay];
    [movie.moviePlayer setFullscreen:YES];
    [self presentViewController:movie animated:YES completion:nil];
}

-(void)encrypt:(id)sender{
    
    NSLog(@"加密");
    [ZXYFileEncrypt encryptFileWithFilePath:filePath];
    NSLog(@"encryptFile=%@",filePath);
}

-(void)decrypt:(id)sender{
    
    NSLog(@"解密");
    [ZXYFileEncrypt decryptFileWithFilePath:filePath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
