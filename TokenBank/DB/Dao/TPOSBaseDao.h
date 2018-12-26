//
//  TPOSBaseDao.h
//  TokenBank
//
//  Created by MarcusWoo on 21/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPOSDataBaseManager.h"

@interface TPOSBaseDao : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;

@end
