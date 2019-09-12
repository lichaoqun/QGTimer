//
//  ViewController.m
//  QGTestTimer
//
//  Created by 李超群 on 2019/3/21.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "ViewController.h"
#import "QIETimerTool.h"



@interface ViewController ()

/**  */
@property (nonatomic, strong) NSHashTable *hashTab;

/** <#注释#> */
@property (nonatomic, strong) id model;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(90, 90, 90, 90)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    QIETimerToolModel *model1  = [QIETimerToolModel creatTimerToolModelWithTimeInterval:5 repeat:YES syncCallback:^{
        NSLog(@"-============");
    } asyncCallback:nil];
    NSLog(@"-========");
    [QIETimerTool addTimerToolModel:model1];
    
    self.model =  [QIETimerTool addTimerActionWithTimeInterval:0.5 repeat:YES syncCallback:^{
        NSLog(@"-XXXX");
    } asyncCallback:nil];

//    QIETimerToolModel *model3  = [QIETimerToolModel creatTimerToolModel:0.3 repeat:YES callback:^(void) {
//        NSLog(@"0.3--0.3-0.3--0.3--0.3--0.3--0.3--0.3");
//    }];
//    [[QIETimerTool shareTimerTool] addTimerToolModel:model3];

}

-(void)onClick:(UIButton *)sender{
    [QIETimerTool removeTimerToolModel:self.model];
}

-(void)onTimerDo{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end

