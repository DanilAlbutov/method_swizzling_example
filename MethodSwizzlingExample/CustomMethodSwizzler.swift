//
//  CustomMethodSwizzler.swift
//  MethodSwizzlingExample
//
//  Created by Данил Албутов on 08.08.2022.
//

import Foundation

class CustomMethodSwizzler {
    
    init() {
        swizzleMethods()        
    }
    
    private func swizzleMethods() {
        let originalSelector = #selector(originalMethod(value:count:))
        let swizzledSelector = #selector(customMethod(value:count:))
        
        guard let originalMethod = class_getInstanceMethod(CustomMethodSwizzler.self,
                                                           originalSelector),
              let swizzledMethod = class_getInstanceMethod(CustomMethodSwizzler.self,
                                                           swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc dynamic func originalMethod(value: String, count: Int) {
        print("This is original()")
        print("  String: \(value)\n  Int: \(String(count))")
    }
    
    @objc dynamic private func customMethod(value: String, count: Int) {
        customMethod(value: value, count: count)
        print("This is custom()")
        
        let newValue = "Changed Text"
        let newCount = count + 1
        
        print("  String: \(newValue)\n  Int: \(String(newCount))")
    }
}
