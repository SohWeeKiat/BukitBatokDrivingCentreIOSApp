//
//  StepperView.m
//  Stepper
//
//  Created by StudentR on 17/2/16.
//  Copyright © 2016 IT. All rights reserved.
//

#import "StepperView.h"
#import <QuartzCore/QuartzCore.h>

@implementation StepperView


-(id)initWithInfo:(UIView*)Parent MPR:(NSInteger)MarksPerRow CurrentValue:(NSInteger)Current Max:(NSInteger)MaxStep
{
    self = [super init];
    if (self){
        _MakersPerRow = MarksPerRow;
        _numberCurrent = Current;
        _numberTotalStep = MaxStep;
        _StepperBGRows = [[NSMutableArray alloc]init];
        _StepperConnectors = [[NSMutableArray alloc]init];
        _StepperRows = [[NSMutableArray alloc]init];
        _StepperMarks = [[NSMutableArray alloc]init];
        Descriptions = [[NSMutableArray alloc]init];
        _ParentView = Parent;
        [self drawStepperInView:Parent];
    }
    return self;
}

- (void)drawStepperInView:(UIView *)containerView
{
    if (_numberCurrent <= 0) {
        _numberCompleted = 0;
        _numberCurrent = 1;
    } else if (_numberCurrent > _numberTotalStep) {
        _numberCompleted = _numberTotalStep - 1;
        _numberCurrent = _numberTotalStep + 1;
    } else {
        _numberCompleted = _numberCurrent - 1;
    }
    CGFloat _startPointX = ([UIScreen mainScreen].bounds.size.width - STEPPER_WIDTH) / 2;
    if (_startX) {
        _startPointX = _startX;
    }
    CGFloat _startPointY = 250.0f;
    if (_startY) {
        _startPointY = _startY;
    }
    NSInteger NoOfRows = _numberTotalStep / _MakersPerRow;
    if (_numberTotalStep % _MakersPerRow > 0){
        NoOfRows++;
    }
    NSInteger CompletedMark = _numberCurrent;
    NSInteger TotalMarks = _numberTotalStep;
    
    for(int i = 0;i < NoOfRows;i++){
        
        NSInteger MarkersForThisRow = TotalMarks >= _MakersPerRow ?  _MakersPerRow : TotalMarks;
        NSInteger SelectedMarkersForThisRow = CompletedMark > _MakersPerRow ? _MakersPerRow : CompletedMark;
        
        
        UIView* _stepperPipeBG = [[UIView alloc] initWithFrame:CGRectMake(_startPointX, _startPointY + ((i == 0) ? 0 : ((STEPPER_HEIGHT * i)+ 50 * i)), MarkersForThisRow == 1 ? 10 : (STEPPER_WIDTH * ((CGFloat)(MarkersForThisRow-1) / (CGFloat)(_MakersPerRow-1))), STEPPER_HEIGHT)];
        
        _stepperPipeBG.backgroundColor = [UIColor colorWithRed:(225.0f/256.0f) green:(225.0f/256.0f) blue:(225.0f/256.0f) alpha:1.0f];
        [containerView addSubview:_stepperPipeBG];
        [_StepperBGRows addObject:_stepperPipeBG];
        
        
        //draw connectors
        if ((i+1) < NoOfRows){
            NSInteger SelectedMarkersForNextRow = (CompletedMark-_MakersPerRow) > _MakersPerRow ? _MakersPerRow : (CompletedMark-_MakersPerRow);
            CGFloat StartX = (i % 2) ? (-7) : (STEPPER_WIDTH - 5);
            
            UIView* _StepperConnector = [[UIView alloc] initWithFrame:CGRectMake(StartX, 0, STEPPER_HEIGHT, 50+(STEPPER_HEIGHT*2))];
            _StepperConnector.backgroundColor = [UIColor colorWithRed:(225.0f/256.0f) green:(225.0f/256.0f) blue:(225.0f/256.0f) alpha:1.0f];
            [_stepperPipeBG addSubview:_StepperConnector];
            
            UIView* _stepperPipeFront = [[UIView alloc] initWithFrame:CGRectMake(4.0f, 0, (STEPPER_HEIGHT - 8.0f), (SelectedMarkersForNextRow > 0) ? 70 : 1)];
            _stepperPipeFront.backgroundColor = COMPLETED_COLOR;
            _stepperPipeFront.layer.borderWidth = 1.5f;
            _stepperPipeFront.layer.borderColor = COMPLETED_BORDER_COLOR.CGColor;
            [_StepperConnector addSubview:_stepperPipeFront];
            [_StepperConnectors addObject:_stepperPipeFront];
        }
        
        //draw bar
        
        CGFloat _stepperPipeFrontWidth = (STEPPER_WIDTH * ((CGFloat)(SelectedMarkersForThisRow-1) / (CGFloat)(_MakersPerRow-1)));
        if (SelectedMarkersForThisRow <= 0){
            _stepperPipeFrontWidth = 1;
        }
        CGFloat stepperPipeFrontStartX = 10.0f;
        if (i % 2){
            stepperPipeFrontStartX = STEPPER_WIDTH - _stepperPipeFrontWidth;
        }
        UIView* _stepperPipeFront = [[UIView alloc] initWithFrame:CGRectMake(stepperPipeFrontStartX, 4.0f, _stepperPipeFrontWidth, (STEPPER_HEIGHT - 8.0f))];
        _stepperPipeFront.backgroundColor = COMPLETED_COLOR;
        _stepperPipeFront.layer.borderWidth = 1.5f;
        _stepperPipeFront.layer.borderColor = COMPLETED_BORDER_COLOR.CGColor;
        [_stepperPipeBG addSubview:_stepperPipeFront];
        [_StepperRows addObject:_stepperPipeFront];
    
        CompletedMark -= _MakersPerRow;
        TotalMarks -= _MakersPerRow;
    }
    for (int i=1; i<=_numberTotalStep; i++) {
        int RealIndex = (i-1) / _MakersPerRow;
        int status = MARK_UNTOUCHED;
        if (i < _numberCurrent) {
            status = MARK_COMPLETED;
        } else if (i == _numberCurrent) {
            status = MARK_CURRENT;
        } else {
            status = MARK_UNTOUCHED;
        }
        [self drawStepperMarkInView:[_StepperBGRows objectAtIndex:RealIndex] withNumber:i withStatus:status withRow:RealIndex];
    }
}

- (void)setStepWithNumber:(int)step {
    
    if (step <= 0) {
        _numberCompleted = 0;
        step = 1;
        
    } else if (step > _numberTotalStep) {
        
        _numberCompleted = _numberTotalStep - 1;
        _numberCurrent = _numberTotalStep + 1;
        
    } else {
        _numberCompleted = step - 1;
        _numberCurrent = step;
    }
    
    NSInteger MarksSelected = _numberCurrent;
    for (int i = 0; i < [_StepperRows count]; i++) {
        NSInteger MarkSelected2 = MarksSelected > _MakersPerRow ? _MakersPerRow : MarksSelected;
        
        if ((i+1) == [_StepperRows count] && MarkSelected2 > (_numberTotalStep % _MakersPerRow) && (_numberTotalStep % _MakersPerRow) > 0){
            MarkSelected2 = (_numberTotalStep % _MakersPerRow);
        }
        CGFloat _stepperPipeFrontWidth = (STEPPER_WIDTH * ((CGFloat)(MarkSelected2-1) / (CGFloat)(_MakersPerRow-1)));
        if (MarkSelected2 <= 0){
            _stepperPipeFrontWidth = 1;
        }
        CGFloat stepperPipeFrontStartX = 10.0f;
        if (i % 2){
            stepperPipeFrontStartX = STEPPER_WIDTH - _stepperPipeFrontWidth;
        }
        
        UIView* _stepperPipeFront = [_StepperRows objectAtIndex:i];
        _stepperPipeFront.frame = CGRectMake(stepperPipeFrontStartX, 4.0f, _stepperPipeFrontWidth, (STEPPER_HEIGHT - 8.0f));
        
        if ((i+1) < [_StepperRows count]){
            NSInteger SelectedMarkersForNextRow = (MarksSelected-_MakersPerRow) > _MakersPerRow ? _MakersPerRow : (MarksSelected-_MakersPerRow);
            UIView* _stepperPipeSide = [_StepperConnectors objectAtIndex:i];
            _stepperPipeSide.frame = CGRectMake(4.0f, 0, (STEPPER_HEIGHT - 8.0f), (SelectedMarkersForNextRow > 0) ? 70 : 1);
        }
        MarksSelected -= _MakersPerRow;
    }
    
    for (int i=1; i<=_numberTotalStep; i++) {
        int status = MARK_UNTOUCHED;
        if (i < _numberCurrent) {
            status = MARK_COMPLETED;
        } else if (i == _numberCurrent) {
            status = MARK_CURRENT;
        } else {
            status = MARK_UNTOUCHED;
        }
        UILabel* Label = [_StepperMarks objectAtIndex:(i-1)];
        UIColor *backgroundColor = [UIColor clearColor];
        UIColor *borderColor = [UIColor clearColor];
        switch (status) {
            case MARK_UNTOUCHED:
                backgroundColor = [UIColor clearColor];
                borderColor = [UIColor clearColor];
                break;
                
            case MARK_CURRENT:
                backgroundColor = CURRENT_COLOR;
                borderColor = CURRENT_BORDER_COLOR;
                break;
                
            case MARK_COMPLETED:
                backgroundColor = COMPLETED_COLOR;
                borderColor = COMPLETED_BORDER_COLOR;
                break;
                
            default:
                break;
        }
        Label.backgroundColor = backgroundColor;
        Label.layer.borderColor = borderColor.CGColor;
        //[self drawStepperMarkInView:[_StepperBGRows objectAtIndex:RealIndex] withNumber:i withStatus:status withRow:RealIndex];
    }
}

- (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

-(void) OnUndoTouched:(id)sender{
    --_numberCurrent;
    if (_numberCurrent <= 0) {
        _numberCurrent = 1;
    }
    [self setStepWithNumber:(int)_numberCurrent];
    if (PopupView){
        [PopupView dismiss];
    }
}

-(void) OnCompletedTouched:(id)sender{
    ++_numberCurrent;
    if (_numberCurrent > _numberTotalStep) {
        _numberCurrent = _numberTotalStep + 1;
    }
    [self setStepWithNumber:(int)_numberCurrent];
    if (PopupView){
        [PopupView dismiss];
    }
}

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)sender AndLabel:(UILabel*)Label {
    CGPoint tapPoint = [sender locationOfTouch:0 inView:_ParentView];
    
    NSDictionary* Info = [Descriptions objectAtIndex:(Label.tag-1)];
    NSString* Title = [Info objectForKey:@"Title"];
    UIView* NewView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 300, 130)];
    NewView.backgroundColor = [UIColor whiteColor];
    
    UILabel* UITitle = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 20)];
    UITitle.textAlignment = NSTextAlignmentCenter;
    UITitle.text = Title;
    [NewView addSubview:UITitle];
    
    UILabel* UIDesc = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 300-10, 130-40)];
    UIDesc.numberOfLines = 0;
    UIDesc.lineBreakMode = NSLineBreakByWordWrapping;
    UIDesc.text = [Info objectForKey:@"Desc"];
    UIDesc.font = [UIFont systemFontOfSize:12];
    [NewView addSubview:UIDesc];
    
    if (Label.tag == _numberCurrent){
        UIButton* Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [Button setTitle:@"Complete" forState:UIControlStateNormal];
        [Button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [Button.layer setBorderColor:[UIColor greenColor].CGColor];
        [[Button layer] setBorderWidth:2.0f];
        [Button addTarget:self action:@selector(OnCompletedTouched:) forControlEvents:UIControlEventTouchUpInside];
        Button.frame = CGRectMake((300-160)/2, 75, 160.0, 40.0);
        [NewView addSubview:Button];
    }else if (Label.tag == (_numberCurrent-1)){
        UIButton* Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [Button setTitle:@"Undo" forState:UIControlStateNormal];
        [Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [Button.layer setBorderColor:[UIColor redColor].CGColor];
        [[Button layer] setBorderWidth:2.0f];
        [Button addTarget:self action:@selector(OnUndoTouched:) forControlEvents:UIControlEventTouchUpInside];
        Button.frame = CGRectMake((300-160)/2, 75, 160.0, 40.0);
        [NewView addSubview:Button];
    }
    [NewView setAlpha:0.8];
    PopupView = [[UZPopupView alloc]initWithContentView:NewView contentSize:NewView.bounds.size];
    [PopupView presentModalAtPoint:tapPoint inView:_ParentView animated:YES];
}

- (void)drawStepperMarkInView:(UIView *)containerView withNumber:(NSInteger)markDigit withStatus:(NSInteger)markStatus withRow:(NSInteger)Row {
    
    CGFloat markStartX = 0;
    if (markDigit == 1) {
        markStartX = 0.0f - (STEPPER_MARK_HEIGHT_WIDTH / 2);
    }else if (Row % 2){//odd
        markStartX = STEPPER_WIDTH - ((STEPPER_WIDTH / (_MakersPerRow - 1)) * (markDigit-(Row*_MakersPerRow) - 1)) - (STEPPER_MARK_HEIGHT_WIDTH / 2);
    }else if (markDigit == _MakersPerRow) {
        markStartX = STEPPER_WIDTH - (STEPPER_MARK_HEIGHT_WIDTH / 2);
    } else {
        markStartX = ((STEPPER_WIDTH / (_MakersPerRow - 1)) * (markDigit-(Row*_MakersPerRow) - 1)) - (STEPPER_MARK_HEIGHT_WIDTH / 2);
    }
    
    UIColor *backgroundColor = [UIColor clearColor];
    UIColor *borderColor = [UIColor clearColor];
    switch (markStatus) {
        case MARK_UNTOUCHED:
            backgroundColor = [UIColor clearColor];
            borderColor = [UIColor clearColor];
            break;
            
        case MARK_CURRENT:
            backgroundColor = CURRENT_COLOR;
            borderColor = CURRENT_BORDER_COLOR;
            break;
            
        case MARK_COMPLETED:
            backgroundColor = COMPLETED_COLOR;
            borderColor = COMPLETED_BORDER_COLOR;
            break;
            
        default:
            break;
    }
    
    UIView *_stepperMarkBG = [[UIView alloc] initWithFrame:CGRectMake(markStartX, ((STEPPER_HEIGHT - STEPPER_MARK_HEIGHT_WIDTH) / 2), STEPPER_MARK_HEIGHT_WIDTH, STEPPER_MARK_HEIGHT_WIDTH)];
    _stepperMarkBG.tag = (int)markDigit;
    _stepperMarkBG.backgroundColor = [UIColor colorWithRed:(225.0f/256.0f) green:(225.0f/256.0f) blue:(225.0f/256.0f) alpha:1.0f];
    _stepperMarkBG.layer.cornerRadius = STEPPER_MARK_HEIGHT_WIDTH / 2;
    [_stepperMarkBG clipsToBounds];
    _stepperMarkBG.clipsToBounds = YES;
    [containerView addSubview:_stepperMarkBG];
    [containerView bringSubviewToFront:_stepperMarkBG];
    
    CGFloat heightWidth = STEPPER_MARK_HEIGHT_WIDTH - 6;
    CGFloat labelStart = (STEPPER_MARK_HEIGHT_WIDTH - heightWidth) / 2;
    CGFloat fontSize = heightWidth - 5.0f;
    
    UILabel* _stepperMark = [[UILabel alloc] initWithFrame:CGRectMake(labelStart, labelStart, heightWidth, heightWidth)];
    _stepperMark.tag = (int)markDigit;
    _stepperMark.backgroundColor = backgroundColor;
    _stepperMark.textAlignment = NSTextAlignmentCenter;
    _stepperMark.font = [UIFont systemFontOfSize:fontSize];
    _stepperMark.text = [NSString stringWithFormat:@"%d", (int)markDigit];
    //[_stepperMark setTitle:[NSString stringWithFormat:@"%d", (int)markDigit] forState:UIControlStateNormal];
    _stepperMark.layer.cornerRadius = _stepperMark.frame.size.width / 2;
    _stepperMark.layer.borderWidth = 1.5f;
    _stepperMark.layer.borderColor = borderColor.CGColor;
    [_stepperMark clipsToBounds];
    _stepperMark.clipsToBounds = YES;
    _stepperMark.userInteractionEnabled = YES;

    _stepperMarkBG.clipsToBounds = YES;
    _stepperMarkBG.userInteractionEnabled = YES;

    [_stepperMarkBG addSubview:_stepperMark];
    [_stepperMarkBG bringSubviewToFront:_stepperMark];
    [_StepperMarks addObject:_stepperMark];
}

-(void)AddDescription:(NSString*)Title AndDesc:(NSString*)Desc
{
    NSDictionary* Step = @{
        @"Title" : Title,
        @"Desc" : Desc
    };
    [Descriptions addObject:Step];
}

-(void)OnTapped:(UITapGestureRecognizer*)sender
{
    if (sender.numberOfTouches <= 0){
        return;
    }
    
    for(int i = 0;i < [_StepperMarks count];i++){
        UILabel* Label = [_StepperMarks objectAtIndex:i];
        CGRect ToBeChecked = Label.bounds;
        CGPoint touchPoint = [sender locationOfTouch:0 inView:Label];
        ToBeChecked.size.height += 5;
        ToBeChecked.size.width += 10;
        
        if (CGRectContainsPoint(ToBeChecked, touchPoint)){
            [self didTapLabelWithGesture:sender AndLabel:Label];
            break;
        }
    }
}

@end
