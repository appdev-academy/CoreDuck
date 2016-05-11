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
        Save context
     
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
        Save context and wait
     
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