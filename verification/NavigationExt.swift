//
//  NavigationExt.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import Foundation

import ReactiveCocoa
import ReactiveSwift
extension UINavigationController {
    
    
    func removeLastThenPush(_ vc: UIViewController) {
        
        var newStack = viewControllers
        newStack.removeLast()
        newStack.append(vc)
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        view.layer.add(transition, forKey: nil)
        setViewControllers(newStack, animated: false)
        
    }
    
    
    
}

extension Reactive where Base == UINavigationController {
    
    var removeLastThenPush: BindingTarget<UIViewController> {
        makeBindingTarget(on: UIScheduler()) { base, vc in
            base.removeLastThenPush(vc)
        }
    }
    
}
