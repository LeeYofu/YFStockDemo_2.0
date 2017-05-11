
// KLine

#import <UIKit/UIKit.h>
#import "YFStock_KLineModel.h"

@interface YFKline : UIView

// 绘制
- (void)drawWithDrawKLineModels:(NSArray <YFStock_KLineModel *>*)drawKLineModels;

@end
