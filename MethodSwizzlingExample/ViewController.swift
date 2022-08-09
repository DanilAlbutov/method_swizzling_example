//
//  ViewController.swift
//  MethodSwizzlingExample
//
//  Created by Данил Албутов on 08.08.2022.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomMethodSwizzler().originalMethod(value: "Original1", count: 1)
        print("------")
        
        CustomMethodSwizzler().originalMethod(value: "Original2", count: 2)
        print("------")
        
        CustomMethodSwizzler().originalMethod(value: "Original3", count: 3)
        print("------")
        
        CustomMethodSwizzler().originalMethod(value: "Original4", count: 4)
        print("------")
        
    }
}

