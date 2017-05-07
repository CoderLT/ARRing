//
//  ATListCustomItem.h
//  CengFanQu
//
//  Created by CoderLT on 16/2/22.
//  Copyright © 2016年 AT. All rights reserved.
//

#import "ATListItem.h"

@interface ATListCustomItem : ATListItem

/**
 *  自定义cell类名
 */
@property (nonatomic, assign) Class<ATListCellProtocol> cellClass;

@end
