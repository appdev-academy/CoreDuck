//
//  ViewController.swift
//  CoreDuck_Example_macOS
//
//  Created by Yura Voevodin on 08.08.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Cocoa
import CoreDuck

class ViewController: NSViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Delete all objects
    if #available(OSX 10.11, *) {
      Entity.batchDeleteAll()
    } else {
      // Fallback on earlier versions
      Entity.deleteAllObjects()
    }
  }
}
