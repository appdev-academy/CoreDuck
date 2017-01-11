//
//  NSManagedObjectContext.swift
//
//  Created by App Dev Academy on 07.04.16.
//  Copyright © 2016 App Dev Academy. All rights reserved.
//

import CoreData

// MARK: - NSManagedObjectContext extension

public extension NSManagedObjectContext {
  
  /// Main NSManagedObjectContext of the app.
  /// Primary usage is UIKit, works on the main thread of the app.
  /// It's a singleton - always returns the same instance.
  public static var mainContext: NSManagedObjectContext {
    return CoreDuck.quack.mainContext
  }
  
  /// Background NSManagedObjectContext.
  /// Returns new instance of NSManagedObjectContext each time you access this variable.
  /// Use it for persisting changes to CoreData.
  public static var backgroundContext: NSManagedObjectContext {
    return CoreDuck.quack.backgroundContext
  }
  
  /// Save NSManagedObjectContext
  ///
  /// - Parameters:
  ///   - block: closure invoked before saving NSManagedObjectContext, perform changes on NSManagedObject instances here
  ///   - completion: closure that will be executed after save operation is finished
  static func saveWithBlock(_ block: @escaping (_ localContext: NSManagedObjectContext) -> Void, completion: @escaping (_ success: Bool) -> Void) {
    let backgroundContext = NSManagedObjectContext.backgroundContext
    
    backgroundContext.perform {
      block(backgroundContext)
      
      let success = CoreDuck.quack.saveContexts(contextWithObject: backgroundContext)
      
      DispatchQueue.main.async(execute: {
        completion(success)
      })
    }
  }
  
  /// Save NSManagedObjectContext and wait
  ///
  /// - Parameters:
  ///   - block: closure invoked before saving NSManagedObjectContext, perform changes on NSManagedObject instances here
  ///   - completion: closure that will be executed after save operation is finished
  static func saveWithBlockAndWait(_ block: @escaping (_ localContext: NSManagedObjectContext) -> Void, completion: @escaping (_ success: Bool) -> Void) {
    let backgroundContext = NSManagedObjectContext.backgroundContext
    
    backgroundContext.performAndWait {
      block(backgroundContext)
      
      let success = CoreDuck.quack.saveContextsAndWait(contextWithObject: backgroundContext)
      
      DispatchQueue.main.async(execute: {
        completion(success)
      })
    }
  }
}
