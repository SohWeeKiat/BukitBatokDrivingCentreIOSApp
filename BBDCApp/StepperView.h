//
//  StepperView.h
//  Stepper
//
//  Created by StudentR on 17/2/16.
//  Copyright © 2016 IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepperConstants.h"
#import "UZPopupView.h"

@interface StepperView : UIView
{
    NSMutableArray* Descriptions;
    UZPopupView* PopupView;
}
@property (nonatomic) NSInteger numberTotalStep;
@property (nonatomic) NSInteger numberCompleted;
@property (nonatomic) NSInteger numberCurrent;
@property (nonatomic) CGFloat startX;
@property (nonatomic) CGFloat startY;
@property (nonatomic) NSMutableArray* StepperBGRows;
@property (nonatomic) NSMutableArray* StepperRows;
@property (nonatomic) NSMutableArray* StepperConnectors;
@property (nonatomic) NSMutableArray* StepperMarks;
@property (nonatomic) NSInteger MakersPerRow;
@property (nonatomic) UIView* ParentView;

-(id)initWithInfo:(UIView*)Parent MPR:(NSInteger)MarksPerRow CurrentValue:(NSInteger)Current Max:(NSInteger)MaxStep;

- (void)drawStepperInView:(UIView *)containerView;

- (void)setStepWithNumber:(int)step;

-(void)AddDescription:(NSString*)Title AndDesc:(NSString*)Desc;

-(void)OnTapped:(UITapGestureRecognizer*)sender;

@end
