//
//  TPOSTransactionNormalOptionView.m
//  TokenBank
//
//  Created by MarcusWoo on 09/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionNormalOptionView.h"

@interface TPOSTransactionNormalOptionView()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *questionButton;
@property (weak, nonatomic) IBOutlet UILabel *currentValueLabel;
@end

@implementation TPOSTransactionNormalOptionView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)onQuestionButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(TPOSTransactionNormalOptionViewDidTapQuestionBtn)]) {
        [self.delegate TPOSTransactionNormalOptionViewDidTapQuestionBtn];
    }
}

- (IBAction)onSliderDidChanged:(UISlider *)sender {
    CGFloat value = sender.value;
    self.minerFee = value;
    self.currentValueLabel.text = [NSString stringWithFormat:@"%0.8f %@", value, @"ether"];
}

@end
