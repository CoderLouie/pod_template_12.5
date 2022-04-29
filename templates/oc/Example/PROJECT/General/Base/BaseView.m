//
//  BaseView.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}


- (void)setup { }

@end

@implementation BaseControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}


- (void)setup { }

@end

@implementation BaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    [self setup];
    return self;
}

- (void)setup {}

@end

@implementation BaseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup {}
@end
