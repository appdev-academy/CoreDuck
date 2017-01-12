//
//  AppDelegate.swift
//  CoreDuck_Example_macOS
//
//  Created by Yura Voevodin on 08.08.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import CoreDuck
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    // Initialize CoreData stack
    let _ = CoreDuck.quack
    
    // Access main NSManagedContext
    let _ = CoreDuck.quack.mainContext
    // or
    let _ = NSManagedObjectContext.main
    
    // Get background NSManagedObjectContext
    let _ = CoreDuck.quack.backgroundContext
    // or
    let _ = NSManagedObjectContext.background
    
    
    // Make some changes to NSManagedObjects
    NSManagedObjectContext.saveWithBlock({
      localContext in
      
      // Save NSManagedObjects here...
      
    }, completion: {
      success in
      
      // Completion code depending on success bool
    })
    // or
    NSManagedObjectContext.saveWithBlockAndWait({
      localContext in
      
      // Save NSManagedObjects here...
      
    }, completion: {
      success in
      
      // Completion code depending on success bool
    })
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
}
