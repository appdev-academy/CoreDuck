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
  
  /// Create new NSManagedObject in context
  ///
  /// - Parameter context: context to insert new NSManagedObject instance
  /// - Returns: new NSManagedObject instance inserted into specified context
  static func new<T: NSManagedObject>(in context: NSManagedObjectContext) -> T? {
    return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T
  }
  
  /// Get reference to NSManagedObject instance in different context
  ///
  /// - Parameter context: context to access NSManagedObject instance in
  /// - Returns: NSManagedObject instance in different context
  func inContext<T: NSManagedObject>(_ context: NSManagedObjectContext) -> T? {
    if objectID.isTemporaryID {
      do {
        try managedObjectContext?.obtainPermanentIDs(for: [self])
      } catch {
        return nil
      }
    }
    
    do {
      return try context.existingObject(with: objectID) as? T
    } catch {
      return nil
    }
  }
  
  /// Delete all NSManagedObject subclass instances
  static func deleteAllObjects() {
    let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
    
    NSManagedObjectContext.saveWithBlock({ localContext in
      do {
        let result = try localContext.fetch(request)
        guard let objectsToDelete = result as? [NSManagedObject] else {
          if CoreDuck.printErrors {
            print("⚠️ error while fetching objects")
          }
          return
        }
        
        for object in objectsToDelete {
          localContext.delete(object)
        }
      } catch {
        if CoreDuck.printErrors {
          print("⚠️ error while fetching objects")
        }
      }
    }, completion: { success in
      if !success && CoreDuck.printErrors {
        print("⚠️ failed to delete objects")
      }
    })
  }
  
  /// Get count of entities
  ///
  /// - Parameter predicate: predicate for search
  /// - Returns: count of entities
  static func countOfEntities(withPredicate predicate: NSPredicate) -> Int {
    let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
    request.predicate = predicate
    
    do {
      return try NSManagedObjectContext.mainContext.count(for: request)
    } catch {
      if CoreDuck.printErrors {
        print("⚠️ failed to get count of " + entityName)
      }
      return 0
    }
  }
  
  // MARK: - findFirst with predicate
  
  /// Find first object with predicate in context
  ///
  /// - Parameters:
  ///   - predicate: predicate for search
  ///   - context: context to search in
  /// - Returns: NSManagedObject instance or nil
  static func findFirst<T: NSManagedObject>(with predicate: NSPredicate, in context: NSManagedObjectContext) -> T? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
    request.predicate = predicate
    
    do {
      let results = try context.fetch(request)
      return results.first
      
    } catch {
      if CoreDuck.printErrors {
        print("⚠️ failed to fetch first object of " + entityName)
      }
      return nil
    }
  }
  
  /// Find first object with predicate (in main context)
  ///
  /// - Parameter predicate: predicate for search
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(with predicate: NSPredicate) -> T? {
    return findFirst(with: predicate, in: NSManagedObjectContext.mainContext)
  }
  
  // MARK: - findFirst by attribute in context
  
  /// Find first object by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: context for search
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withInt64 value: Int64, in context: NSManagedObjectContext) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find first object by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: context for search
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withInt32 value: Int32, in context: NSManagedObjectContext) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find first object by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: context for search
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withInt16 value: Int16, in context: NSManagedObjectContext) -> T? {
    return self.findFirst(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find first object by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: context for search
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withInt8 value: Int8, in context: NSManagedObjectContext) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find first object by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: context for search
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withInt value: Int, in context: NSManagedObjectContext) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find first object by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: context for search
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withDouble value: Double, in context: NSManagedObjectContext) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find first object by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: context for search
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withFloat value: Float, in context: NSManagedObjectContext) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find first object by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: context for search
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withBool value: Bool, inContext context: NSManagedObjectContext) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find first object by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: context for search
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withString value: String, in context: NSManagedObjectContext) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = %@", value), in: context)
  }
  
  // MARK: - findFirst
  
  /// Find first object
  ///
  /// - Parameters:
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(sortedBy: String, ascending: Bool) -> T? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
    
    // Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
    request.sortDescriptors = [sortDescriptor]
    
    do {
      let results = try NSManagedObjectContext.mainContext.fetch(request)
      return results.first
      
    } catch {
      if CoreDuck.printErrors {
        print("⚠️ failed to fetch first object of " + entityName)
      }
      return nil
    }
  }
  
  // MARK: - findFirst by attribute
  
  /// Find first object by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withInt64 value: Int64) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first object by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withInt32 value: Int32) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first object by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withInt16 value: Int16) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first object by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withInt8 value: Int8) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first object by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withInt value: Int) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first object by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withDouble value: Double) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first object by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withFloat value: Float) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first object by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withBool value: Bool) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = \(value)"))
  }
  
  /// Find first object by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  /// - Returns: object or nil
  static func findFirst<T: NSManagedObject>(by attribute: String, withString value: String) -> T? {
    return findFirst(with: NSPredicate(format: "\(attribute) = %@", value))
  }
  
  // MARK: - findAll
  
  /// Find all objects in context
  ///
  /// - Parameter context: NSManagedObjectContext for fetch request
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(in context: NSManagedObjectContext) -> [T] {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
    
    do {
      return try context.fetch(request)
      
    } catch {
      if CoreDuck.printErrors {
        print("⚠️ failed to fetch request for " + entityName)
      }
      return []
    }
  }
  
  /// Find all objects with predicate
  ///
  /// - Parameters:
  ///   - predicate: NSPredicate for search
  ///   - context: NSManagedObjectContext for fetch request
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(with predicate: NSPredicate, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
    request.predicate = predicate
    
    do {
      return try context.fetch(request)
      
    } catch {
      if CoreDuck.printErrors {
        print("⚠️ failed to fetch request for " + entityName)
      }
      return []
    }
  }
  
  /// Find all objects
  ///
  /// - Parameters:
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(sortedBy: String, ascending: Bool, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
    
    // Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
    request.sortDescriptors = [sortDescriptor]
    
    do {
      return try context.fetch(request)
      
    } catch {
      if CoreDuck.printErrors {
        print("⚠️ failed to fetch request for " + entityName)
      }
      return []
    }
  }
  
  /// Find all objects with predicate in context
  ///
  /// - Parameters:
  ///   - predicate: predicate for search
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(with predicate: NSPredicate, sortedBy: String, ascending: Bool, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
    request.predicate = predicate
    
    // Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
    request.sortDescriptors = [sortDescriptor]
    
    do {
      return try context.fetch(request)
      
    } catch {
      if CoreDuck.printErrors {
        print("⚠️ failed to fetch request for " + entityName)
      }
      return []
    }
  }
  
  // MARK: - findAll by attribute in context
  
  /// Find all objects by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(by attribute: String, withInt64 value: Int64, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    return findAll(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find all objects by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(by attribute: String, withInt32 value: Int32, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    return findAll(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find all objects by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(by attribute: String, withInt16 value: Int16, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    return findAll(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find all objects by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(by attribute: String, withInt8 value: Int8, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    return findAll(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find all objects by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(by attribute: String, withInt value: Int, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    return findAll(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find all objects by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(by attribute: String, withDouble value: Double, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    return findAll(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find all objects by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(by attribute: String, withFloat value: Float, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    return findAll(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find all objects by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(by attribute: String, withBool value: Bool, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    return findAll(with: NSPredicate(format: "\(attribute) = \(value)"), in: context)
  }
  
  /// Find all objects by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: array of NSManagedObject's subclass instances
  static func findAll<T: NSManagedObject>(by attribute: String, withString value: String, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> [T] {
    return findAll(with: NSPredicate(format: "\(attribute) = %@", value), in: context)
  }
  
  // MARK: - NSFetchedResultsController functions
  
  /// Fetch all objects in context
  ///
  /// - Parameters:
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  ///   - delegate: NSFetchedResultsControllerDelegate
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: NSFetchedResultsController
  @available(OSX 10.12, *)
  static func fetchAll<T: NSManagedObject>(sortedBy: String, ascending: Bool, delegate: NSFetchedResultsControllerDelegate, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> NSFetchedResultsController<T>? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
    
    // Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
    request.sortDescriptors = [sortDescriptor]
    
    // Initialize Fetched Results Controller
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    // Set delegate
    fetchedResultsController.delegate = delegate
    
    // Try to perform fetch request
    do {
      try fetchedResultsController.performFetch()
      return fetchedResultsController
      
    } catch {
      if CoreDuck.printErrors {
        print("⚠️ failed to fetch request for " + entityName)
      }
      return nil
    }
  }
  
  /// Fetch all objects with predicate in context
  ///
  /// - Parameters:
  ///   - predicate: NSPredicate for search
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  ///   - delegate: NSFetchedResultsControllerDelegate
  ///   - context: NSManagedObjectContext to perform fetch in
  /// - Returns: NSFetchedResultsController
  @available(OSX 10.12, *)
  static func fetchAll<T: NSManagedObject>(with predicate: NSPredicate, sortedBy: String, ascending: Bool, delegate: NSFetchedResultsControllerDelegate, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> NSFetchedResultsController<T>? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
    
    // Sort Descriptors
    let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
    request.sortDescriptors = [sortDescriptor]
    
    // Add Predicate
    request.predicate = predicate
    
    // Initialize Fetched Results Controller
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    // Set delegate
    fetchedResultsController.delegate = delegate
    
    // Try to perform fetch request
    do {
      try fetchedResultsController.performFetch()
      return fetchedResultsController
      
    } catch {
      if CoreDuck.printErrors {
        print("⚠️ failed to fetch request for " + entityName)
      }
      return nil
    }
  }
  
  /// Fetch all objects with predicate and sort descriptors and sections in context
  ///
  /// - Parameters:
  ///   - predicate: NSPredicate for search
  ///   - sortDescriptors: The sort descriptors of the fetch request.
  ///   - sectionNameKeyPath: A key path on result objects that returns the section name.
  ///   - delegate: The object that is notified when the fetched results changed.
  ///   - context: The managed object against which fetchRequest is executed.
  /// - Returns: NSFetchedResultsController
  @available(OSX 10.12, *)
  static func fetchAll<T: NSManagedObject>(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor], sectionNameKeyPath: String? = nil, delegate: NSFetchedResultsControllerDelegate, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> NSFetchedResultsController<T>? {
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
    
    // Sort Descriptors
    request.sortDescriptors = sortDescriptors
    
    // Add Predicate
    request.predicate = predicate
    
    // Initialize Fetched Results Controller
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
    
    // Set delegate
    fetchedResultsController.delegate = delegate
    
    // Try to perform fetch request
    do {
      try fetchedResultsController.performFetch()
      return fetchedResultsController
      
    } catch {
      if CoreDuck.printErrors {
        print("⚠️ failed to fetch request for " + entityName)
      }
      return nil
    }
  }
  
  // MARK: - fetchAll by attribute in context
  
  /// Fetch all objects by attribute in context
  ///
  /// - Parameters:
  ///   - attribute: name of attribute to match value
  ///   - value: value to match attribute with
  ///   - sortedBy: column name to sort by
  ///   - ascending: direction to sort by
  ///   - context: NSManagedObjectContext to perform fetch in
  ///   - delegate: NSFetchedResultsControllerDelegate
  /// - Returns: NSFetchedResultsController
  @available(OSX 10.12, *)
  static func fetchAll<T: NSManagedObject>(by attribute: String, withInt64 value: Int64, sortedBy: String, ascending: Bool, delegate: NSFetchedResultsControllerDelegate, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> NSFetchedResultsController<T>? {
    return fetchAll(with: NSPredicate(format: "\(attribute) = \(value)"), sortedBy: sortedBy, ascending: ascending, delegate: delegate, in: context)
  }
  
  // MARK: - Aggregate functions
  
  /// Calculate sum by attribute
  ///
  /// - Parameters:
  ///   - attribute: name of the attribute to calculate sum
  ///   - predicate: NSPredicate for filtering
  ///   - context: NSManagedObjectContext for fetching (mainContext is default)
  /// - Returns: NSNumber with total sum or nil
  static func sum(on attribute: String, with predicate: NSPredicate, in context: NSManagedObjectContext = NSManagedObjectContext.mainContext) -> NSNumber? {
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
      if CoreDuck.printErrors {
        print("⚠️ failed to fetch request for " + entityName)
      }
      return nil
    }
  }
}
