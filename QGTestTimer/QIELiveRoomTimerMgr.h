//
//  QIETimerTool.h
//  QGTestTimer
//
//  Created by 李超群 on 2019/3/21.
//  Copyright © 2019 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^QIETimerToolCallBackBlock)(void);

@interface QIELiveRoomTimerModel : NSObject

/** 创建计时器
    timeInterval : 调用时间间隔
    repeat : 是否重复
    callback : 计时器到时间的回调 (totalTimeValue : 从开始计时到回调的值的累加)
 */
+(instancetype)creatTimerToolModelWithTimeInterval:(NSTimeInterval)timeInterval repeat:(BOOL)repeat callback:(QIETimerToolCallBackBlock)callback;

@end

@interface QIELiveRoomTimerMgr : NSObject

+(QIELiveRoomTimerModel *)addTimerActionWithTimeInterval:(NSTimeInterval)timeInterval repeat:(BOOL)repeat callback:(QIETimerToolCallBackBlock)callback;

/** 添加一个计时器事件 */
+(void)addTimerToolModel:(QIELiveRoomTimerModel *)timerToolModel;

/** 删除一个计时器的事件 */
+(void)removeTimerToolModel:(QIELiveRoomTimerModel *)timerToolModel;

/** 移除计时器 */
+(void)destoryTimerMgr;

@end
