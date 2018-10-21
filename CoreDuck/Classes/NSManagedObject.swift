//
//  NSManagedObject.swift
//
//  Created by App Dev Academy on 3/15/16.
//  Copyright © 2016 App Dev Academy. All rights reserved.
//

import CoreData

// MARK: - NSManagedObject extension

public extension NSManagedObject {
  
  // MARK: - Variables
  
  /// NSManagedObject's subclass name
  static var entityName: String {
    return String(describing: self)
  }
  
  // MARK: - Helpers
  
  /// Delete all NSManagedObject subclass instances
  static func deleteAllObjects() {
    let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
    
    NSManagedObjectContext.saveWithBlock({ localContext in
      do {
        let result = try localContext.fetch(request)
        guard let objectsToDelete = result as? [NSManagedObject] else {
          CoreDuck.printError("Error while fetching objects")
          return
        }
        
        for object in objectsToDelete {
          localContext.delete(object)
        }
      } catch {
        CoreDuck.printError("Error while fetching objects \(error.localizedDescription)")
      }
    }, completion: { success in
      if !success {
        CoreDuck.printError("Failed to delete objects")
      }
    })
  }
  
  #if os(iOS)
  /// Delete all NSManagedObject subclass instances with batch request
  @available(iOS 9.0, *)
  static func batchDeleteAll() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    let context = NSManagedObjectContext.background
    do {
      try CoreDuck.quack.persistentStoreCoordinator.execute(deleteRequest, with: context)
      _ = CoreDuck.quack.saveContexts(contextWithObject: context)
    } catch {
      CoreDuck.printError("Failed to delete objects")
    }
  }
  #endif
  
  // MARK: - Aggregate functions
  
  /// Calculate sum by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of the attribute to calculate sum
  ///   - predicate: NSPredicate for filtering
  ///   - context: NSManagedObjectContext for fetching (mainContext is default)
  /// - Returns: NSNumber with total sum or nil
  static func sum(on attribute: String, with predicate: NSPredicate, in context: NSManagedObjectContext = NSManagedObjectContext.main) -> NSNumber? {
    let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
    
    // Predicate
    request.predicate = predicate
    
    // Set result type
    request.resultType = .dictionaryResultType
    
    let receiverName = "total"
    
    // Create expression
    let keyPath = NSExpression(forKeyPath: attribute)
    let calc = NSExpressionDescription()
    calc.name = receiverName
    calc.expression = NSExpression(forFunction: "sum:", arguments: [keyPath])
    calc.expressionResultType = .doubleAttributeType
    
    request.propertiesToFetch = [calc]
    
    do {
      let results = try context.fetch(request)
      let objects = results as NSArray
      guard let first = objects.firstObject as? [String: Any] else { return nil }
      return first[receiverName] as? NSNumber
      
    } catch {
      CoreDuck.printError("Failed to fetch request for \(entityName), error: \(error.localizedDescription)")
      return nil
    }
  }
}
