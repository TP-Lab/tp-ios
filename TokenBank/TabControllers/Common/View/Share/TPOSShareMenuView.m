//
//  TPOSShareView.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/28.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSShareMenuView.h"
#import "TPOSShareCCell.h"
#import "TPOSMacro.h"
#import "WXApi.h"
#import "TPOSShareView.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSShareMenuView() <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSDictionary *> *shareMenu;

@property (nonatomic, copy) void (^complement)(TPOSShareType);

@property (weak, nonatomic) IBOutlet UILabel *shareTitle;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation TPOSShareMenuView

+ (void)showInView:(UIView *)view complement:(void (^)(TPOSShareType))complement {
    TPOSShareMenuView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"TPOSShareMenuView" owner:nil options:nil] firstObject];
    shareView.complement = complement;
    [shareView showWithAnimate:TPOSAlertViewAnimateBottomUp inView:view ?: [UIApplication sharedApplication].keyWindow];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, kScreenWidth, 196);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self registerCell];
    [self.collectionView reloadData];
    
    [self changeLanguage];
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    if (self.safeAreaInsets.bottom > 0 && CGRectGetHeight(self.bounds) == 196) {
        CGRect f = self.frame;
        f.origin.y -= self.safeAreaInsets.bottom;
        f.size.height += self.safeAreaInsets.bottom;
        self.frame = f;
    }
}

- (void)changeLanguage {
    self.shareTitle.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"title_share_to"];
    [self.cancelButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"title_button_cancel"] forState:UIControlStateNormal];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPOSShareCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TPOSShareCCell" forIndexPath:indexPath];
    NSString *imageName = [_shareMenu[indexPath.row] objectForKey:@"icon"];
    NSString *title = [_shareMenu[indexPath.row] objectForKey:@"title"];
    [cell updateWithTitle:title image:[UIImage imageNamed:imageName]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shareMenu.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *action = [_shareMenu[indexPath.row] objectForKey:@"action"];
    [self performSelector:NSSelectorFromString(action)];
    [super hide];
}

- (IBAction)cancelAction {
    [super hide];
}

- (void)shareToWechat {
    if (_complement) {
        _complement(TPOSShareTypeWechatSession);
    }
}

- (void)shareToWechatFriends {
    if (_complement) {
        _complement(TPOSShareTypeWechatTimeline);
    }
}

- (void)shareToQQ {
    if (_complement) {
        _complement(TPOSShareTypeQQSession);
    }
}

- (void)registerCell {
    [self.collectionView registerNib:[UINib nibWithNibName:@"TPOSShareCCell" bundle:nil] forCellWithReuseIdentifier:@"TPOSShareCCell"];
}

- (NSArray *)shareMenu {
    if (!_shareMenu) {
        _shareMenu = @[@{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"wx_frnds"],@"icon":@"icon_wechat",@"action":@"shareToWechat"},
                       @{@"title":[[TPOSLocalizedHelper standardHelper] stringWithKey:@"wx_timeline"],@"icon":@"icon_wechat_friends",@"action":@"shareToWechatFriends"},
                       @{@"title":@"QQ",@"icon":@"icon_qq",@"action":@"shareToQQ"},
                       ];
    }
    return _shareMenu;
}

@end
