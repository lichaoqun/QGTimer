//
//  ViewController.m
//  QGTestTimer
//
//  Created by 李超群 on 2019/3/21.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "ViewController.h"
#import "QIELiveRoomTimerMgr.h"



@interface ViewController ()

/**  */
@property (nonatomic, strong) NSHashTable *hashTab;

/** <#注释#> */
@property (nonatomic, strong) id model;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger i = 0; i < 10; i++) {
        QIELiveRoomTimerModel *model1  = [QIELiveRoomTimerModel creatTimerToolModelWithTimeInterval:0.1 repeat:YES callback:^{
            QIELiveRoomTimerModel *model2  = [QIELiveRoomTimerModel creatTimerToolModelWithTimeInterval:0.1 repeat:YES callback:nil];
            [QIELiveRoomTimerMgr addTimerToolModel:model2];
            NSLog(@"callback....");
        }];
        [QIELiveRoomTimerMgr addTimerToolModel:model1];
        NSLog(@"forforfor.....");
    };
    
//    [QIETimerTool addTimerActionWithTimeInterval:0.1 repeat:YES callback:^{
//        NSLog(@"1111111");
//        [NSThread sleepForTimeInterval:3];
//    }];
}

-(void)onClick:(UIButton *)sender{
    [QIELiveRoomTimerMgr removeTimerToolModel:self.model];
}

-(void)onTimerDo{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end

