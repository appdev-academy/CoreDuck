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
  
  /// Create new NSManagedObject
  ///
  /// - Parameter entity: NSManagedObject entity for detect type
  /// - Returns: new NSManagedObject instance inserted into specified context or nil
  func new<T : NSManagedObject>(_ entity: T.Type) -> T? {
    return NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T
  }
  
  /// Get reference to NSManagedObject instance in context
  ///
  /// - Parameter entity: NSManagedObject entity
  /// - Returns: NSManagedObject reference in context or nil
  func get<T : NSManagedObject>(_ entity: T) -> T? {
    if entity.objectID.isTemporaryID {
      do {
        try entity.managedObjectContext?.obtainPermanentIDs(for: [entity])
      } catch {
        CoreDuck.printError("Error while getting existing object in context \(error.localizedDescription)")
        return nil
      }
    }
    
    do {
      return try existingObject(with: entity.objectID) as? T
    } catch {
      CoreDuck.printError("Error while obtain object in context \(error.localizedDescription)")
      return nil
    }
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
  
  /// Find first NSManagedObject with predicate
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
  
  /// Find first NSManagedObject by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int64) -> T? {
    return findFirst(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first NSManagedObject by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int32) -> T? {
    return findFirst(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first NSManagedObject by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int16) -> T? {
    return findFirst(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first NSManagedObject by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int8) -> T? {
    return findFirst(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first NSManagedObject by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int) -> T? {
    return findFirst(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first NSManagedObject by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Double) -> T? {
    return findFirst(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first NSManagedObject by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Float) -> T? {
    return findFirst(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first NSManagedObject by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Bool) -> T? {
    return findFirst(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first NSManagedObject by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: NSManagedObject instance or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: String) -> T? {
    return findFirst(entity: entity, with: NSPredicate(format: "\(attribute) = %@", value))
  }
  
  // MARK: - Find first
  
  /// Find first object
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  /// - Returns: object or nil
  func findFirst<T: NSManagedObject>(entity: T.Type, sortedBy: String, ascending: Bool) -> T? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
    
    // Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
    request.sortDescriptors = [sortDescriptor]
    
    do {
      let results = try fetch(request)
      return results.first
      
    } catch {
      CoreDuck.printError("Failed to fetch first object of \(T.entityName), error: \(error.localizedDescription)")
      return nil
    }
  }
  
  // MARK: - Find all
  
  /// Find all objects
  ///
  ///   - entity: NSManagedObject entity for detect type
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type) -> [T] {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
    
    do {
      return try fetch(request)
      
    } catch {
      CoreDuck.printError("Failed to fetch request of \(T.entityName), error: \(error.localizedDescription)")
      return []
    }
  }
  
  /// Find all objects with predicate
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - predicate: NSPredicate for search
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, with predicate: NSPredicate) -> [T] {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
    request.predicate = predicate
    
    do {
      return try fetch(request)
      
    } catch {
      CoreDuck.printError("Failed to fetch request of \(T.entityName), error: \(error.localizedDescription)")
      return []
    }
  }
  
  /// Find all objects
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, sortedBy: String, ascending: Bool) -> [T] {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
    
    // Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
    request.sortDescriptors = [sortDescriptor]
    
    do {
      return try fetch(request)
      
    } catch {
      CoreDuck.printError("Failed to fetch request of \(T.entityName), error: \(error.localizedDescription)")
      return []
    }
  }
  
  /// Find all objects with predicate
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - predicate: predicate for search
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, with predicate: NSPredicate, sortedBy: String, ascending: Bool) -> [T] {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
    request.predicate = predicate
    
    // Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
    request.sortDescriptors = [sortDescriptor]
    
    do {
      return try fetch(request)
      
    } catch {
      CoreDuck.printError("Failed to fetch request of \(T.entityName), error: \(error.localizedDescription)")
      return []
    }
  }
  
  // MARK: - Find all by attribute
  
  /// Find all objects by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int64) -> [T] {
    return findAll(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find all objects by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int32) -> [T] {
    return findAll(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find all objects by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int16) -> [T] {
    return findAll(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find all objects by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int8) -> [T] {
    return findAll(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find all objects by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int) -> [T] {
    return findAll(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find all objects by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Double) -> [T] {
    return findAll(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find all objects by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Float) -> [T] {
    return findAll(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find all objects by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Bool) -> [T] {
    return findAll(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find all objects by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: array of NSManagedObject's subclass instances
  func findAll<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: String) -> [T] {
    return findAll(entity: entity, with: NSPredicate(format: "\(attribute) = %@", value))
  }
  
  // MARK: - NSFetchedResultsController functions
  
  /// Fetch all objects
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  ///   - delegate: NSFetchedResultsControllerDelegate
  /// - Returns: NSFetchedResultsController
  @available(OSX 10.12, *)
  func fetchAll<T: NSManagedObject>(entity: T.Type, sortedBy: String, ascending: Bool, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<T>? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
    
    // Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
    request.sortDescriptors = [sortDescriptor]
    
    // Initialize Fetched Results Controller
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self, sectionNameKeyPath: nil, cacheName: nil)
    
    // Set delegate
    fetchedResultsController.delegate = delegate
    
    // Try to perform fetch request
    do {
      try fetchedResultsController.performFetch()
      return fetchedResultsController
      
    } catch {
      CoreDuck.printError("Failed to perform fetch for \(T.entityName), error: \(error.localizedDescription)")
      return nil
    }
  }
  
  /// Fetch all objects with predicate
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - predicate: NSPredicate for search
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  ///   - delegate: NSFetchedResultsControllerDelegate
  /// - Returns: NSFetchedResultsController
  @available(OSX 10.12, *)
  func fetchAll<T: NSManagedObject>(entity: T.Type, with predicate: NSPredicate, sortedBy: String, ascending: Bool, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<T>? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
    
    // Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
    request.sortDescriptors = [sortDescriptor]
    
    // Add Predicate
    request.predicate = predicate
    
    // Initialize Fetched Results Controller
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self, sectionNameKeyPath: nil, cacheName: nil)
    
    // Set delegate
    fetchedResultsController.delegate = delegate
    
    // Try to perform fetch request
    do {
      try fetchedResultsController.performFetch()
      return fetchedResultsController
      
    } catch {
      CoreDuck.printError("Failed to perform fetch for \(T.entityName), error: \(error.localizedDescription)")
      return nil
    }
  }
  
  /// Fetch all objects with predicate and sort descriptors and sections
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - predicate: NSPredicate for search
  ///   - sortDescriptors: The sort descriptors of the fetch request.
  ///   - sectionNameKeyPath: A key path on result objects that returns the section name.
  ///   - delegate: The object that is notified when the fetched results changed.
  /// - Returns: NSFetchedResultsController
  @available(OSX 10.12, *)
  func fetchAll<T: NSManagedObject>(entity: T.Type, with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor], sectionNameKeyPath: String? = nil, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<T>? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
    
    // Sort Descriptors
    request.sortDescriptors = sortDescriptors
    
    // Add Predicate
    request.predicate = predicate
    
    // Initialize Fetched Results Controller
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
    
    // Set delegate
    fetchedResultsController.delegate = delegate
    
    // Try to perform fetch request
    do {
      try fetchedResultsController.performFetch()
      return fetchedResultsController
      
    } catch {
      CoreDuck.printError("Failed to perform fetch for \(T.entityName), error: \(error.localizedDescription)")
      return nil
    }
  }
  
  /// Fetch all objects by attribute
  ///
  /// - Parameters:
  ///   - entity: NSManagedObject entity for detect type
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  ///   - delegate: NSFetchedResultsControllerDelegate
  /// - Returns: NSFetchedResultsController
  @available(OSX 10.12, *)
  func fetchAll<T: NSManagedObject>(entity: T.Type, by attribute: String, with value: Int64, sortedBy: String, ascending: Bool, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<T>? {
    return fetchAll(entity: entity, with: NSPredicate(format: "\(attribute) = \(value)"), sortedBy: sortedBy, ascending: ascending, delegate: delegate)
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
