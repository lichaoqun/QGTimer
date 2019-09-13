//
//  QIETimerTool.m
//  QGTestTimer
//
//  Created by 李超群 on 2019/3/21.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "QIELiveRoomTimerMgr.h"

@interface QIELiveRoomTimerModel ()

/** 是否重复 */
@property (nonatomic, assign) BOOL repeat;

/** 计时器的时间间隔 */
@property (nonatomic, assign)NSTimeInterval timeInterval;

/** 回调的 block */
@property (nonatomic, copy) QIETimerToolCallBackBlock callback;


/** 这个model 加入到计时器的时间 */
@property (nonatomic, assign)NSTimeInterval  startTimeValue;

@end

@implementation QIELiveRoomTimerModel

/** 初始化方法 */
+(instancetype)creatTimerToolModelWithTimeInterval:(NSTimeInterval)timeInterval repeat:(BOOL)repeat callback:(QIETimerToolCallBackBlock)callback{
    QIELiveRoomTimerModel *model = [[QIELiveRoomTimerModel alloc]init];
    model.timeInterval = timeInterval;
    model.repeat = repeat;
    model.callback = callback;
    return model;
}

@end

@interface QIELiveRoomTimerMgr ()

/** 计时器 */
@property(nonatomic,strong) dispatch_source_t timer;

/** 计时器的线程 */
@property (nonatomic, strong) dispatch_queue_t queue;

/** 累计的时间 */
@property (nonatomic, assign) NSTimeInterval totalTimerValue;

/** 计时器和事件的关系映射表 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableSet *> *timerActionDic;

@end

@implementation QIELiveRoomTimerMgr

/** 初始化方法 */
static QIELiveRoomTimerMgr *timerTool_ = nil;
+(instancetype)shareTimerTool{
    if (!timerTool_) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        if (!timerTool_) {
            timerTool_ = [[QIELiveRoomTimerMgr alloc]init];
            [timerTool_ starTimer];
        }
        dispatch_semaphore_signal(semaphore);
    }
    return timerTool_;
}

+(QIELiveRoomTimerModel *)addTimerActionWithTimeInterval:(NSTimeInterval)timeInterval repeat:(BOOL)repeat callback:(QIETimerToolCallBackBlock)callback{
    QIELiveRoomTimerModel *model = [QIELiveRoomTimerModel creatTimerToolModelWithTimeInterval:timeInterval repeat:repeat callback:callback];
    [self addTimerToolModel:model];
    return model;
}

/** 添加一个计时器事件 */
+(void)addTimerToolModel:(QIELiveRoomTimerModel *)timerToolModel{
    QIELiveRoomTimerMgr *timerTool = [QIELiveRoomTimerMgr shareTimerTool];
    dispatch_block_t block = ^{
        timerToolModel.startTimeValue = timerTool.totalTimerValue + timerToolModel.timeInterval;
        NSString *key = [NSString stringWithFormat:@"%.1f", timerToolModel.startTimeValue];
        NSMutableSet *timerModesSet = [timerTool.timerActionDic objectForKey:key];
        timerModesSet = timerModesSet ? : [NSMutableSet set];
        [timerTool.timerActionDic setObject:timerModesSet forKey:key];
        [timerModesSet addObject:timerToolModel];
    };
    dispatch_async(timerTool.queue, block);
}

/** 删除一个计时器的事件 */
+(void)removeTimerToolModel:(QIELiveRoomTimerModel *)timerToolModel{
    QIELiveRoomTimerMgr *timerTool = [QIELiveRoomTimerMgr shareTimerTool];
    dispatch_block_t block = ^{
        NSString *key = [NSString stringWithFormat:@"%.1f", timerToolModel.startTimeValue];
        NSMutableSet *timerModesSet = [timerTool.timerActionDic objectForKey:key];
        [timerModesSet removeObject:timerToolModel];
        if (timerModesSet.count == 0) [timerTool.timerActionDic removeObjectForKey:key];
    };
    dispatch_async(timerTool.queue, block);
}

/** 开始计时器 */
-(void)starTimer{
    // - 创建计时器和事件的关系映射表
    self.timerActionDic = [[NSMutableDictionary  alloc] init];

    // - 创建一个每0.1s 执行一次的计时器
    NSTimeInterval timeInterval = 0.1;
    _queue = dispatch_queue_create("com.tencent.tv.timerTool.queue", DISPATCH_QUEUE_SERIAL);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(timeInterval * NSEC_PER_SEC);
    dispatch_source_set_timer(_timer, start, interval, 0);
    dispatch_source_set_event_handler(_timer, ^{
        self.totalTimerValue = self.totalTimerValue + timeInterval;
    });
    dispatch_resume(_timer);
}

/** 重写累计时间的 set 方法 */
-(void)setTotalTimerValue:(NSTimeInterval)totalTimerValue{
    _totalTimerValue = totalTimerValue;
    NSString *timerAcitonKey = [NSString stringWithFormat:@"%.1f", (self.totalTimerValue)];
    NSMutableSet *timerModesSet = [self.timerActionDic objectForKey:timerAcitonKey];
    [timerModesSet enumerateObjectsUsingBlock:^(QIELiveRoomTimerModel *pModel, BOOL * _Nonnull stop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !pModel.callback ? : pModel.callback() ;
        });
        [QIELiveRoomTimerMgr removeTimerToolModel:pModel];
        if (pModel.repeat){
            [QIELiveRoomTimerMgr addTimerToolModel:pModel];
        }
    }];
}

/** 销毁计时器 */
+(void)destoryTimerMgr{
    if (timerTool_) {
        [timerTool_.timerActionDic removeAllObjects];
        dispatch_source_cancel(timerTool_.timer);
        timerTool_.timer = nil;
        timerTool_.queue = nil;
        timerTool_ = nil;
    }
}

-(void)dealloc{
    NSLog(@"==========dealloc==============");
}

@end
