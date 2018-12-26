//
//  TPOSTransactionEmptyView.m
//  TokenBank
//
//  Created by MarcusWoo on 11/02/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionEmptyView.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSTransactionEmptyView()
@property (weak, nonatomic) IBOutlet UILabel *soonLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;
@end

@implementation TPOSTransactionEmptyView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self changeLanguage];
}

- (void)changeLanguage {
    self.soonLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"soon"];
    self.exchangeLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"de_exchange"];
}

@end
