//
//  UINavigationController+Extends.h
//  NingBoBank
//
//  Created by YaoZhong on 3/19/14.
//  UINavigationVontroller返回到指定名位viewContrllerName的ViewController
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extends)

//- (void)popToSpecifiedViewController:(NSString *)viewControllerName animated:(BOOL)animated;


//返回到第一个aClass类对应的viewCtrl（如果没发现aClass对应的viewCtrl，返回NO）
-(BOOL) poptoClass:(Class) aClass;
//页面栈内查找aClass对应的viewCtrl（发现返回YES，没发现返回NO）
-(BOOL) canFindClassInNaviControllers:(Class) aClass;

-(id) findvcOfClass:(Class) aClass;
@end
