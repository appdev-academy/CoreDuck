//
//  NSManagedObjectContext.swift
//
//  Created by App Dev Academy on 07.04.16.
//  Copyright © 2016 App Dev Academy. All rights reserved.
//

import CoreData

// MARK: - NSManagedObjectContext extension

public extension NSManagedObjectContext {
  
  // MARK: - Variables
  
  /// Main NSManagedObjectContext of the app.
  /// Primary usage is UIKit, works on the main thread of the app.
  /// It's a singleton - always returns the same instance.
  public static var main: NSManagedObjectContext {
    return CoreDuck.quack.mainContext
  }
  
  /// Background NSManagedObjectContext.
  /// Returns new instance of NSManagedObjectContext each time you access this variable.
  /// Use it for persisting changes to CoreData.
  public static var background: NSManagedObjectContext {
    return CoreDuck.quack.backgroundContext
  }
  
  // MARK: - Working with context
  
  /// Create new NSManagedObject in context
  ///
  /// - Parameter entity: NSManagedObject entity for detect type
  /// - Returns: new NSManagedObject instance inserted into specified context or nil
  func new<T : NSManagedObject>(_ entity: T.Type) -> T? {
    return NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T
  }
  
  // MARK: - Helpers
  
  /// Get count of entities
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - predicate: NSPredicate for search
  /// - Returns: count of entities
  func countOfEntites<T: NSManagedObject>(entity: T.Type, with predicate: NSPredicate) -> Int {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
    request.predicate = predicate
    
    do {
      return try count(for: request)
    } catch {
      CoreDuck.printError("Failed to get count of \(T.entityName), error: \(error.localizedDescription)")
      return 0
    }
  }
  
  // MARK: - Find first with predicate
  
  /// Find first NSManagedObject with predicate in context
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - predicate: NSPredicate for search
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, with predicate: NSPredicate) -> T? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
    request.predicate = predicate
    
    do {
      let results = try fetch(request)
      return results.first
      
    } catch {
      CoreDuck.printError("Failed to fetch first object of \(T.entityName), error: \(error.localizedDescription)")
      return nil
    }
  }
  
  // MARK: - Find first by attribute
  
  /// Find first NSManagedObject by attribute in context
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject, U>(entity: T.Type, by attribute: String, with value: U) -> T? where U: Integer {
    return findFirst(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  // MARK: - Save contexts
  
  /// Save NSManagedObjectContext
  ///
  /// - Parameters:
  ///   - block: closure invoked before saving NSManagedObjectContext, perform changes on NSManagedObject instances here
  ///   - completion: closure that will be executed after save operation is finished
  static func saveWithBlock(_ block: @escaping (_ localContext: NSManagedObjectContext) -> Void, completion: @escaping (_ success: Bool) -> Void) {
    let backgroundContext = NSManagedObjectContext.background
    
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
    let backgroundContext = NSManagedObjectContext.background
    
    backgroundContext.performAndWait {
      block(backgroundContext)
      
      let success = CoreDuck.quack.saveContextsAndWait(contextWithObject: backgroundContext)
      
      DispatchQueue.main.async(execute: {
        completion(success)
      })
    }
  }
}
