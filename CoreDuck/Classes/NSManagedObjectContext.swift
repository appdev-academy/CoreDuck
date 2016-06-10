//
//  NSManagedObjectContext.swift
//
//  Created by App Dev Academy on 07.04.16.
//  Copyright © 2016 App Dev Academy. All rights reserved.
//

import CoreData

// MARK: - NSManagedObjectContext extension

public extension NSManagedObjectContext {
    
    /**
        Main NSManagedObjectContext of the app
        You can use it safely with UIKit, works on the main thread of the app
        It's a singleton - always returns the smae instance
    */
    public static var mainContext: NSManagedObjectContext {
        return CoreDuck.quack.mainContext
    }
    
    /**
        Background NSManagedObjectContext.
        Returns new instance of NSManagedObjectContext each time you access this variable
        Perfect application of bacground context - asynchronous import of data into CoreData
    */
    public static var backgroundContext: NSManagedObjectContext {
        return CoreDuck.quack.backgroundContext
    }
    
    /**
        Save NSManagedObjectContext
     
        - parameter block: execute block of code before save
        - parameter localContext: context to save
    */
    static func saveWithBlock(block: (localContext: NSManagedObjectContext) -> Void, completion: (success: Bool) -> Void) {
        
        let backgroundContext = CoreDuck.quack.backgroundContext
        
        backgroundContext.performBlock {
            block(localContext: backgroundContext)
            
            let success = CoreDuck.quack.saveContexts(contextWithObject: backgroundContext)
            
            dispatch_async(dispatch_get_main_queue(), { 
                completion(success: success)
            })
        }
    }
    
    /**
        Save NSManagedObjectContext and wait
     
        - parameter block: execute block of code before save
        - parameter localContext: context to save
    */
    static func saveWithBlockAndWait(block: (localContext: NSManagedObjectContext) -> Void, completion: (success: Bool) -> Void) {
        
        let backgroundContext = CoreDuck.quack.backgroundContext
        
        backgroundContext.performBlockAndWait {
            block(localContext: backgroundContext)
            
            let success = CoreDuck.quack.saveContextsAndWait(contextWithObject: backgroundContext)
            
            dispatch_async(dispatch_get_main_queue(), {
                completion(success: success)
            })
        }
    }
}