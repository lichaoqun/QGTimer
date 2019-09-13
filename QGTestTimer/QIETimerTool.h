//
//  QIETimerTool.h
//  QGTestTimer
//
//  Created by 李超群 on 2019/3/21.
//  Copyright © 2019 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QIETimerToolModel;
//void (^ __nullable)(void))completion
typedef void(^callback)(void);
typedef void(^QIETimerToolCallBackBlock)(void);

@interface QIETimerToolModel : NSObject

/** 创建计时器
    timeInterval : 调用时间间隔
    repeat : 是否重复
    callback : 计时器到时间的回调 (totalTimeValue : 从开始计时到回调的值的累加)
 */
+(instancetype)creatTimerToolModelWithTimeInterval:(NSTimeInterval)timeInterval repeat:(BOOL)repeat callback:(QIETimerToolCallBackBlock)callback;

@end

@interface QIETimerTool : NSObject

+(QIETimerToolModel *)addTimerActionWithTimeInterval:(NSTimeInterval)timeInterval repeat:(BOOL)repeat callback:(QIETimerToolCallBackBlock)callback;

/** 添加一个计时器事件 */
+(void)addTimerToolModel:(QIETimerToolModel *)timerToolModel;

/** 删除一个计时器的事件 */
+(void)removeTimerToolModel:(QIETimerToolModel *)timerToolModel;

/** 移除计时器 */
+(void)destoryTimerTool;

@end
