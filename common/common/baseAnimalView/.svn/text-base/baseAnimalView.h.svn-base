//
//  baseAnimalView.h
//  i1-app
//
//  Created by sam on 15/9/22.
//  Copyright © 2015年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    TopType = 0,
    BottomType,
    LeftType,
    RightType,
    CenterType
}animalType;

typedef  void (^Complete) (void);


@interface baseAnimalView : UIView

-(void)showView:(BOOL)animal animalType:(animalType)type complete:(Complete)complete;
-(void)showInView:(UIView *)view animal:(BOOL)animal animalType:(animalType)type complete:(Complete)complete;
-(void)dismissView:(BOOL)animal complete:(Complete)complete;

@end
