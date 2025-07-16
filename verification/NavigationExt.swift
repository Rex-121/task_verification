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

import Toast_Swift
extension Reactive where Base: UIViewController {
    
    var toast: BindingTarget<String?> {
        return makeBindingTarget(on: UIScheduler()) { base, value in
            base.view?.makeToast(value, duration: 0.3, position: .center)
        }
    }
    
}
//Action<RegisterNet, BasicInfo, AnvilNetError>
extension Action where Output == BasicInfo, Error == AnvilNetError {
    
    var allMessages: Signal<String?, Never> {
        return values.map { $0.message }.merge(with: errors.map { $0.description })
    }
    
}

//extension Action where Output == (any Decodable, BasicInfo), Error == AnvilNetError {
//    
//    var allMessagesx: Signal<String?, Never> {
//        return values.map { $0.1.message }.merge(with: errors.map { $0.description })
//    }
//    
//}


extension Reactive where Base: AnyObject {
    func binding<Value>(for keyPath: ReferenceWritableKeyPath<Base, Value>) -> BindingTarget<Value> {
        return makeBindingTarget { base, value in
            base[keyPath: keyPath] = value
        }
    }
}
