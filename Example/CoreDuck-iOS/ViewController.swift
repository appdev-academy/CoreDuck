//
//  ViewController.swift
//  CoreDuck
//
//  Created by Maksym Skliarov on 05/09/2016.
//  Copyright (c) 2016 Maksym Skliarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 9.0, *) {
      Entity.batchDeleteAll()
    } else {
      // Fallback on earlier versions
      Entity.deleteAllObjects()
    }
  }
}
