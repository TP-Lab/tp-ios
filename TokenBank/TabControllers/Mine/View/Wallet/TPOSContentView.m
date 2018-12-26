//
//  ContentView.m
//  DemoView
//
//  Created by yf on 08/02/2018.
//  Copyright © 2018 TokenBank. All rights reserved.
//

#import "TPOSContentView.h"
#import "UIColor+Hex.h"

#define Space 10.f

#define BTN_HEIGHT 28.f

#define KEYNAME @"key"
#define KEYWIDTH @"size"

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   (1 / [UIScreen mainScreen].scale)

@interface TPOSContentView(){
    int _lineNum; //行
    int _rawNum; //列
    int _lineWidth;
    
    CGFloat _lastLineWordNumber;
    
//    NSMutableArray *_wordKeyArrayCopy;
    
    int _rawJudgeNum;
    
    CGFloat _ownViewHeight;
    
    NSMutableArray *_selectedPrivateKeys;
}
@end

@implementation TPOSContentView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _lineNum = 1; //行
        _rawNum = 1; //列
        _lineWidth = 0;
        
        _lastLineWordNumber = 0;
        
        _rawJudgeNum = 0;
        
        _ownViewHeight = frame.size.height;
        _selectedPrivateKeys = [NSMutableArray array];
        
//        _wordKeyArrayCopy = [NSMutableArray array];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
}

- (CGFloat)createPrivateKeyButtonsWithArray:(NSArray *)privateKeyWord{
    
    self.wordArray = [privateKeyWord mutableCopy];
    return  [self addView:self.frame withArray:self.wordArray];
}

- (CGFloat)addView:(CGRect)rect withArray:(NSArray *)keyWordArray{
    NSMutableArray *tempWordKeyArray = [NSMutableArray array];
    for (NSString *keyWord in self.wordArray) {
        NSDictionary *dict = @{KEYNAME:keyWord, KEYWIDTH:[NSNumber numberWithFloat:[self caculateStringSize:keyWord andFont:16.0f].width]};
        [tempWordKeyArray addObject:dict];
    }
    
    CGFloat viewWidth = rect.size.width;
    
    for (int i = 0; i < self.wordArray.count; i++) {
        NSString *word = [self.wordArray objectAtIndex:i];
        CGSize wordSize = [self caculateStringSize:word andFont:16.0f];
        CGFloat width = wordSize.width + 8;
        CGFloat height = 28;
        
        _lineWidth += width;
        
        if (_lineWidth <= viewWidth-10) {
            
        }else{
            _rawNum = 1;
            _lineNum += 1;
            
            _lineWidth = 0;
            _lineWidth += width;
            
            if (_lineNum > 1) {
                _rawJudgeNum = _lastLineWordNumber;
            }
        }
        
        int mutilpleX = _rawNum - 1;
        int mutilpleY = _lineNum - 1;
        
        CGFloat lastBtns_Width = 0;
        
        for (int j = _rawJudgeNum; j < i; j++) {
            CGFloat gap = 4;
            if (self.viewMode == PrivateKeyConfirmMode) {
                gap = 6;
            }
            NSDictionary *wordDictionary = [tempWordKeyArray objectAtIndex:j];
            CGFloat wordKeyWidth = [wordDictionary[KEYWIDTH] floatValue] + gap;
            lastBtns_Width += wordKeyWidth;
        }
        
        CGFloat x = Space * (mutilpleX + 1) + lastBtns_Width;
        CGFloat y = 0;
        if (self.viewMode == PrivateKeyConfirmMode) {
            y = Space + (Space + BTN_HEIGHT) * mutilpleY;
        } else {
            y = Space + (Space + 20) * mutilpleY;
        }
        
        UIButton *wordBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        wordBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [wordBtn setTitle:word forState:UIControlStateNormal];
        [wordBtn setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        wordBtn.layer.cornerRadius = 2;
        wordBtn.layer.masksToBounds = YES;
        [self addSubview:wordBtn];
        [wordBtn addTarget:self action:@selector(clickPrivateButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //给button加下边框
        if (self.viewMode == PrivateKeyConfirmMode) {
            CALayer *bottomLine = [CALayer layer];
            bottomLine.frame = CGRectMake(0, height-SINGLE_LINE_ADJUST_OFFSET, width,SINGLE_LINE_WIDTH);
            bottomLine.backgroundColor = [UIColor lightGrayColor].CGColor;
            [wordBtn.layer addSublayer:bottomLine];
        }else{
            [wordBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
            wordBtn.selected = YES;
        }
        
        _lineWidth = x + width;
        _rawNum += 1;
        _lastLineWordNumber += 1;
    }
    
    _ownViewHeight = _lineNum * BTN_HEIGHT + (_lineNum - 1) * Space;
    if (_lineNum == 2) {
        _ownViewHeight += Space;
    }
    
    return _ownViewHeight;
}

- (CGSize)caculateStringSize:(NSString *)caculateString andFont:(CGFloat)fontSize{
    
    CGSize size = [caculateString sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    CGSize adjustedSize = CGSizeMake(ceilf(size.width+8), ceilf(28));
    return adjustedSize;
}

- (void)clickPrivateButton:(UIButton *)sender{
    
    if (self.viewMode == PrivateKeyConfirmMode) {
        if (sender.isSelected) {
            sender.selected = NO;
            sender.backgroundColor = [UIColor clearColor];
            [sender setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        }else{
            sender.selected = YES;
            sender.backgroundColor = [UIColor colorWithHex:0x79BAFF alpha:1];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [_selectedPrivateKeys addObject:sender];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickConfirmPrivateKeyButton:andPrivateKeyButton:)]) {
            [self.delegate didClickConfirmPrivateKeyButton:self andPrivateKeyButton:sender];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickContentPrivateKeyButton:andPrivateKeyButton:)]) {
            [self.delegate didClickContentPrivateKeyButton:self andPrivateKeyButton:sender];
        }
        
    }
}

- (void)resetAllProperty{
    _lineNum = 1; //行
    _rawNum = 1; //列
    _lineWidth = 0;
    
    _lastLineWordNumber = 0;
    
    _rawJudgeNum = 0;
    
    _ownViewHeight = self.frame.size.height;
}

- (void)showSelectedButton{
    
}

@end
