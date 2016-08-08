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



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // Initialize CoreData stack
        CoreDuck.quack
        
        // Access main NSManagedContext
        let _ = CoreDuck.quack.mainContext
        // or
        let _ = NSManagedObjectContext.mainContext
        
        // Get background NSManagedObjectContext
        let _ = CoreDuck.quack.backgroundContext
        // or
        let _ = NSManagedObjectContext.backgroundContext
        
        // Make some changes to NSManagedObjects
        NSManagedObjectContext.saveWithBlock({
            localContext in
            }, completion: {
                success in
        })
        // or
        NSManagedObjectContext.saveWithBlockAndWait({
            localContext in
            }, completion: {
                success in
        })
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

