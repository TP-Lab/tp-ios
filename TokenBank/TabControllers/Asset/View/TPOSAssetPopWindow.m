//
//  TPOSAssetPopWindow.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/30.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSAssetPopWindow.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSAssetPopWindow() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *windowContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstanit;
@property (nonatomic, strong) NSArray *orderList;

@property (nonatomic, copy) void (^callBack)(NSInteger index);

@end

@implementation TPOSAssetPopWindow

- (void)awakeFromNib {
    [super awakeFromNib];
    _orderList = @[@{@"icon":@"icon_main_scan",@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"scan"]},
                   @{@"icon":@"icon_main_add_wallet_pop",@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"create_wallet"]},
                   ];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 10, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.tableView.frame)) cornerRadius:4];
//    [bezierPath moveToPoint:CGPointMake(0, 14)];
//    [bezierPath addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame) - 14)];
//    [bezierPath addArcWithCenter:CGPointMake(4, CGRectGetHeight(self.frame) - 14) radius:4 startAngle:M_PI endAngle:M_PI+M_PI_2 clockwise:NO];
//    [bezierPath moveToPoint:CGPointMake(4, CGRectGetHeight(self.frame))];
//    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.frame)-10)];
//    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.tableView.frame), 10)];
//    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.tableView.frame)-15, 10)];
    [bezierPath moveToPoint:CGPointMake(CGRectGetWidth(self.tableView.frame)-15, 10)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.tableView.frame)-20, 3)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.tableView.frame)-25, 10)];
//    [bezierPath addLineToPoint:CGPointMake(0, 10)];
    
    shapeLayer.path = bezierPath.CGPath;
    self.windowContainer.layer.mask = shapeLayer;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (kIphoneX) {
        self.topConstanit.constant += 24;
    }
    
    [self addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

+ (void)showInView:(UIView *)view callBack:(void (^)(NSInteger index))callBack {
    TPOSAssetPopWindow *v = [[NSBundle mainBundle] loadNibNamed:@"TPOSAssetPopWindow" owner:self options:0].firstObject;
    v.alpha = 0;
    v.callBack = callBack;
    v.frame = view.bounds;
    [view addSubview:v];
    [UIView animateWithDuration:0.3 animations:^{
        v.alpha = 1;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"TPOSAssetPopWindowID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.textColor = [UIColor colorWithHex:0x333333];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imageView.image = [UIImage imageNamed:[_orderList[indexPath.row] objectForKey:@"icon"]];
    cell.textLabel.text = [_orderList[indexPath.row] objectForKey:@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 41.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    if (_callBack) {
        _callBack(indexPath.row);
    }
}

@end
