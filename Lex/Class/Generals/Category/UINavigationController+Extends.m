//
//  UINavigationController+Extends.m
//  NingBoBank
//
//  Created by YaoZhong on 3/19/14.
//
//

#import "UINavigationController+Extends.h"

@implementation UINavigationController (Extends)


//- (void)popToSpecifiedViewController:(NSString *)viewControllerName animated:(BOOL)animated
//{
//    NSArray *vcArray = self.viewControllers;
//    for (int i = vcArray.count; i > 0; --i) {
//        UIViewController *vc = [vcArray objectAtIndex:i];
//        if ([vc isKindOfClass:NSClassFromString(viewControllerName)]) {
//            [self popToViewController:vc animated:animated];
//            break;
//        }
//    }
//}


-(BOOL) poptoClass:(Class) aClass
{
    for (int i = (int)self.viewControllers.count; --i>=0;)
    {
        UIViewController* vc = self.viewControllers[i];
        if ([vc isKindOfClass:aClass])
        {
            [self popToViewController:vc animated:YES];
            return YES;
        }
    }
    return NO;
}

-(id) findvcOfClass:(Class) aClass
{
    for (int i = (int)self.viewControllers.count; --i>=0;)
    {
        UIViewController* vc = self.viewControllers[i];
        if ([vc isKindOfClass:aClass])
        {
            return vc;
        }
    }
    return nil;
}

-(BOOL) canFindClassInNaviControllers:(Class) aClass
{
    for (int i = (int)self.viewControllers.count; --i>=0;)
    {
        UIViewController* vc = self.viewControllers[i];
        if ([vc isKindOfClass:aClass])
        {
            return YES;
        }
    }
    return NO;
}

@end


