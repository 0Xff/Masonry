//
//  MASExampleAnimatedView.m
//  MasonryExamples
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "MASExampleAnimatedView.h"

@interface MASExampleAnimatedView ()

@property (nonatomic, strong) NSMutableArray *animatableConstraints;
@property (nonatomic, assign) int padding;

@end

@implementation MASExampleAnimatedView

- (id)init {
    self = [super init];
    if (!self) return nil;

    UIView *view1 = UIView.new;
    view1.backgroundColor = UIColor.greenColor;
    view1.layer.borderColor = UIColor.blackColor.CGColor;
    view1.layer.borderWidth = 2;
    [self addSubview:view1];

    UIView *view2 = UIView.new;
    view2.backgroundColor = UIColor.redColor;
    view2.layer.borderColor = UIColor.blackColor.CGColor;
    view2.layer.borderWidth = 2;
    [self addSubview:view2];

    UIView *view3 = UIView.new;
    view3.backgroundColor = UIColor.blueColor;
    view3.layer.borderColor = UIColor.blackColor.CGColor;
    view3.layer.borderWidth = 2;
    [self addSubview:view3];

    UIView *superview = self;
    int padding = self.padding = 10;
    UIEdgeInsets paddingInsets = UIEdgeInsetsMake(self.padding, self.padding, self.padding, self.padding);

    self.animatableConstraints = NSMutableArray.new;

    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.animatableConstraints addObjectsFromArray:@[
            make.edges.equalTo(superview).insets(paddingInsets).priorityLow(),
            make.bottom.equalTo(view3.mas_top).offset(-padding),
            make.right.equalTo(view2.mas_left).offset(-padding),
        ]];

        make.size.equalTo(view2);
        make.height.equalTo(view3.mas_height);
    }];

    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.animatableConstraints addObjectsFromArray:@[
            make.edges.equalTo(superview).insets(paddingInsets).priorityLow(),
            make.left.equalTo(view1.mas_right).offset(padding),
            make.bottom.equalTo(view3.mas_top).offset(-padding),
        ]];

        make.size.equalTo(view1);
        make.height.equalTo(view3.mas_height);
    }];

    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.animatableConstraints addObjectsFromArray:@[
            make.edges.equalTo(superview).insets(paddingInsets).priorityLow(),
            make.top.equalTo(view1.mas_bottom).offset(padding),
        ]];

        //TODO or pass an array
        //constraints.height.equal(superview.subviews);
        make.height.equalTo(view1.mas_height);
        make.height.equalTo(view2.mas_height);
    }];

    return self;
}

- (void)didMoveToSuperview {
    [self startAnimatingWithInvertedInsets:NO];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.layer removeAllAnimations];
    }
}

- (void)startAnimatingWithInvertedInsets:(BOOL)invertedInsets {
    int padding = invertedInsets ? 100 : self.padding;
    UIEdgeInsets paddingInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
    for (id<MASConstraint> constraint in self.animatableConstraints) {
        constraint.insets(paddingInsets);
    }

    [UIView animateWithDuration:1 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self startAnimatingWithInvertedInsets:!invertedInsets];
        }
    }];
}


@end

