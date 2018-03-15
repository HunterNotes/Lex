//
//  ZLabel.swift
//  Swift
//
//  Created by nbcb on 16/3/16.
//  Copyright © 2016年 nbcb. All rights reserved.
//

import UIKit

@IBDesignable open class ZLabel: UILabel {
    
    //IBDesignable: 显示出来使用代码写的界面
    
    /*Swift 有三种访问修饰符： public、internal、private
     public：可以访问自己模块中任何 public，被 import 到其他模块，也可以被访问
     internal：只能访问自己模块中任何 internal 实体，不能访问其他模块中的 internal 实体
     private：私有的，只能在当前源文件中使用。*/
    
    /* 一、各个修饰符区别
     1，private
     private访问级别所修饰的属性或者方法只能在当前类里访问。
     
     2，fileprivate
     fileprivate访问级别所修饰的属性或者方法在当前的Swift源文件里可以访问。
     
     3，internal（默认访问级别，internal修饰符可写可不写）
     internal访问级别所修饰的属性或方法在源代码所在的整个模块都可以访问。
     如果是框架或者库代码，则在整个框架内部都可以访问，框架由外部代码所引用时，则不可以访问。
     如果是App代码，也是在整个App代码，也是在整个App内部可以访问。
     
     4，public
     可以被任何人访问。但其他module中不可以被override和继承，而在module内可以被override和继承。
     
     5，open
     可以被任何人使用，包括override和继承。
     
     
     二、5种修饰符访问权限排序
     
     从高到低排序如下：
     open > public > interal > fileprivate > private
     
     */
    
    @IBInspectable open var charInterval: Double = 1
    //IBInspectable: 是View内的变量可视化，并且在修改后能马上看到
    
    fileprivate var stopped: Bool = false
    fileprivate var stoppedSubString = String()
    fileprivate var over = false
    
    override open var text: String! {
        //override:子类为继承来的实例方法，类方法，实例属性或附属脚本提供自己定制的实现，称为重写.需要在前面加上 override 关键字标明是要提供一个重写版本而非提供一个相同的定义，override提醒Swift去检查该类的父类是否有匹配的方法，可保证重写定义是正确的
        
        get {
            return super.text
        }
        set {
            if charInterval < 0 {
                charInterval = -charInterval
            }
            stopped = false
            stoppedSubString = String()
            over = false
            let val = newValue ?? ""
            
            setTextWithTyingAnimation(val, charInterval, true)
        }
    }
    
    open func pauseTyping() {
        
        stopped = true
    }
    
    open func continueTyping() {
        
        guard self.over == false else {
            
            CCLog("Animation is already over")
            return
        }
        guard self.over == true else {
            CCLog("Animation is not stopped")
            return
        }
        self.stopped = false
        setTextWithTyingAnimation(self.stoppedSubString, charInterval, false)
    }
    
    fileprivate func setTextWithTyingAnimation(_ typedText: String, _ charIntervar: TimeInterval, _ initial: Bool) {
        
        if initial == true {
            super.text = ""
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            
            for (index, char) in typedText.enumerated() {
                guard self.stopped == false else {
                    //guard 语句：类似if语句。保证条件满足情况下，才会通过，否则只能else返回！切记else中一定需要有返回的语句，比如return、continue、break、throw
                    self.stoppedSubString = typedText.substring(from: typedText.characters.index(typedText.startIndex, offsetBy: index))
                    return
                }
                
                DispatchQueue.main.async {
                    super.text = super.text! + String(char)
                    self.sizeToFit()
                }
                Thread.sleep(forTimeInterval: charIntervar)
            }
            self.over = true
            self.stopped = false
        }
    }
}
