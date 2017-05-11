

// MALine

#import <UIKit/UIKit.h>
#import "YFStock_KLineModel.h"
#import "YFStock_Header.h"

@interface YFMA_BOLLLine : UIView

// draw method
- (void)drawWithKLineModels:(NSArray <YFStock_KLineModel *>*)drawKLineModels KLineLineType:(YFStockKLineLineType)KLineLineType;

@end
