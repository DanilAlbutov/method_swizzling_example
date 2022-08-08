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
        let swizzler = CustomMethodSwizzler()
//        swizzler.originalMethod(value: "Original", count: 1)
    }
}

