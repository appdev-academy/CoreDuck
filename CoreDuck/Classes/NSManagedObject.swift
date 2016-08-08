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
    
    /**
        Name of NSManagedObject entity
    */
    static var entityName: String {
        get {
            return String(self)
        }
    }
    
    // MARK: - Helpers
    
    /**
        Create new NSManagedObject in context
     
        - parameter inContext: context for object
    */
    static func new(inContext context: NSManagedObjectContext) -> NSManagedObject {
        
        return NSEntityDescription.insertNewObjectForEntityForName(self.entityName, inManagedObjectContext: context)
    }
    
    /**
        Move NSManagedObject to another context
     
        - parameter context: context to move
    */
    func inContext(context: NSManagedObjectContext) -> NSManagedObject? {
        
        if self.objectID.temporaryID {
            do {
                try self.managedObjectContext?.obtainPermanentIDsForObjects([self])
            } catch {
                return nil
            }
        }
        
        do {
            let objectInNewContext = try context.existingObjectWithID(objectID)
            return objectInNewContext
        } catch {
            return nil
        }
    }
    
    /**
        Truncate all data from Entity in context
     
        - parameter inContext: context for search
    */
    static func deleteAllObjects() {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        
        NSManagedObjectContext.saveWithBlock({
            localContext in
            
            do {
                let result = try localContext.executeFetchRequest(fetchRequest)
                
                if let objectsToDelete = result as? [NSManagedObject] {
                    
                    for object in objectsToDelete {
                        
                        do {
                            let objectInContext = try localContext.existingObjectWithID(object.objectID)
                            localContext.deleteObject(objectInContext)
                            
                        } catch {
                            
                        }
                    }
                }
                
            } catch {
                
            }
            
        }) {
            success in
            
        }
    }
    
    /**
        Get count of entities
     
        - parameter withPredicate: predicate for search
    */
    static func countOfEntities(withPredicate predicate: NSPredicate) -> Int {
        
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        fetchRequest.predicate = predicate
        
        let count = CoreDuck.quack.mainContext.countForFetchRequest(fetchRequest, error: nil)
        
        return count
    }
    
    // MARK: - findFirst with predicate
    
    /**
        Find first object with predicate in context
     
        - parameter withPredicate: predicate for search
        - parameter inContext: context for search
    */
    static func findFirst(withPredicate predicate: NSPredicate, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            
            if let object = results.first as? NSManagedObject  {
                
                return object
            } else {
                return nil
            }
            
        } catch {
            return nil
        }
    }
    
    /**
        Find first object with predicate (in main context)
     
        - parameter withPredicate: predicate for search
    */
    static func findFirst(withPredicate predicate: NSPredicate) -> NSManagedObject? {
        return self.findFirst(withPredicate: predicate, inContext: CoreDuck.quack.mainContext)
    }
    
    // MARK: - findFirst by attribute in context
    
    /**
        Find first object by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt64Value: value for search
        - parameter inContext: context for search
    */
    static func findFirst(byAttribute attribute: String, withInt64Value value: Int64, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find first object by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt32Value: value for search
        - parameter inContext: context for search
    */
    static func findFirst(byAttribute attribute: String, withInt32Value value: Int32, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find first object by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt16Value: value for search
        - parameter inContext: context for search
    */
    static func findFirst(byAttribute attribute: String, withInt16Value value: Int16, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find first object by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt8Value: value for search
        - parameter inContext: context for search
    */
    static func findFirst(byAttribute attribute: String, withInt8Value value: Int8, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find first object by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withIntValue: value for search
        - parameter inContext: context for search
    */
    static func findFirst(byAttribute attribute: String, withIntValue value: Int, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find first object by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withDoubleValue: value for search
        - parameter inContext: context for search
    */
    static func findFirst(byAttribute attribute: String, withDoubleValue value: Double, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find first object by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withFloatValue: value for search
        - parameter inContext: context for search
    */
    static func findFirst(byAttribute attribute: String, withFloatValue value: Float, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find first object by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withBoolValue: value for search
        - parameter inContext: context for search
    */
    static func findFirst(byAttribute attribute: String, withBoolValue value: Bool, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find first object by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withStringValue: value for search
        - parameter inContext: context for search
    */
    static func findFirst(byAttribute attribute: String, withStringValue value: String, inContext context: NSManagedObjectContext) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = %@", value)
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate, inContext: context)
    }
    
    // MARK: - findFirst
    
    /**
        Find all objects
     
        - parameter sortedBy: column name to sort by
        - parameter ascending: direction to sort by
    */
    static func findFirst(sortedBy sortedBy: String, ascending: Bool) -> NSManagedObject? {
        
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try CoreDuck.quack.mainContext.executeFetchRequest(fetchRequest)
            
            if let object = results.first as? NSManagedObject  {
                return object
            } else {
                return nil
            }
            
        } catch {
            
        }
        
        return nil
    }
    
    // MARK: - findFirst by attribute
    
    /**
        Find first object by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt64Value: value for search
    */
    static func findFirst(byAttribute attribute: String, withInt64Value value: Int64) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate)
    }
    
    /**
        Find first object by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt32Value: value for search
    */
    static func findFirst(byAttribute attribute: String, withInt32Value value: Int32) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate)
    }
    
    /**
        Find first object by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt16Value: value for search
    */
    static func findFirst(byAttribute attribute: String, withInt16Value value: Int16) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate)
    }
    
    /**
        Find first object by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt8Value: value for search
    */
    static func findFirst(byAttribute attribute: String, withInt8Value value: Int8) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate)
    }
    
    /**
        Find first object by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withIntValue: value for search
    */
    static func findFirst(byAttribute attribute: String, withIntValue value: Int) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate)
    }
    
    /**
        Find first object by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withDoubleValue: value for search
    */
    static func findFirst(byAttribute attribute: String, withDoubleValue value: Double) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate)
    }
    
    /**
        Find first object by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withFloatValue: value for search
    */
    static func findFirst(byAttribute attribute: String, withFloatValue value: Float) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate)
    }
    
    /**
        Find first object by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withBoolValue: value for search
    */
    static func findFirst(byAttribute attribute: String, withBoolValue value: Bool) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate)
    }
    
    /**
        Find first object by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withStringValue: value for search
    */
    static func findFirst(byAttribute attribute: String, withStringValue value: String) -> NSManagedObject? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = %@", value)
        
        // Fetch and return data
        return self.findFirst(withPredicate: predicate)
    }
    
    // MARK: - findAll
    
    /**
        Find all objects in context
     
        - parameter inContext: context for search
    */
    static func findAll(inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            
            if let fetchedArray = results as? [NSManagedObject] {
                return fetchedArray
            }
            
        } catch {
            
        }
        
        return []
    }
    
    /**
        Find all objects with predicate
     
        - parameter withPredicate: predicate for search
    */
    static func findAll(withPredicate predicate: NSPredicate) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        fetchRequest.predicate = predicate
        
        do {
            let results = try CoreDuck.quack.mainContext.executeFetchRequest(fetchRequest)
            
            if let fetchedArray = results as? [NSManagedObject] {
                return fetchedArray
            }
            
        } catch {
            
        }
        
        return []
    }
    
    /**
        Find all objects
     
        - parameter sortedBy: column name to sort by
        - parameter ascending: direction to sort by
    */
    static func findAll(sortedBy sortedBy: String, ascending: Bool) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try CoreDuck.quack.mainContext.executeFetchRequest(fetchRequest)
            
            if let fetchedArray = results as? [NSManagedObject] {
                return fetchedArray
            }
            
        } catch {
            
        }
        
        return []
    }
    
    /**
        Find all objects with predicate
     
        - parameter sortedBy: column name to sort by
        - parameter ascending: direction to sort by
        - parameter withPredicate: predicate for search
    */
    static func findAll(sortedBy sortedBy: String, ascending: Bool, withPredicate predicate: NSPredicate) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        fetchRequest.predicate = predicate
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try CoreDuck.quack.mainContext.executeFetchRequest(fetchRequest)
            
            if let fetchedArray = results as? [NSManagedObject] {
                return fetchedArray
            }
            
        } catch {
            
        }
        
        return []
    }
    
    /**
        Find all objects with predicate in context
     
        - parameter withPredicate: predicate for search
        - parameter inContext: context for search
    */
    static func findAll(withPredicate predicate: NSPredicate, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        fetchRequest.predicate = predicate
        
        do {
            
            let results = try context.executeFetchRequest(fetchRequest)
            
            if let fetchedArray = results as? [NSManagedObject] {
                return fetchedArray
            }
            
        } catch {
            
        }
        
        return []
    }
    
    // MARK: - findAll by attribute in context
    
    /**
        Find all objects by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt64Value: value for search
        - parameter inContext: context for search
    */
    static func findAll(byAttribute attribute: String, withInt64Value value: Int64, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find all objects by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt32Value: value for search
        - parameter inContext: context for search
    */
    static func findAll(byAttribute attribute: String, withInt32Value value: Int32, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find all objects by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt16Value: value for search
        - parameter inContext: context for search
    */
    static func findAll(byAttribute attribute: String, withInt16Value value: Int16, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find all objects by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt8Value: value for search
        - parameter inContext: context for search
    */
    static func findAll(byAttribute attribute: String, withInt8Value value: Int8, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find all objects by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withIntValue: value for search
        - parameter inContext: context for search
    */
    static func findAll(byAttribute attribute: String, withIntValue value: Int, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find all objects by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withDoubleValue: value for search
        - parameter inContext: context for search
    */
    static func findAll(byAttribute attribute: String, withDoubleValue value: Double, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find all objects by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withFloatValue: value for search
        - parameter inContext: context for search
    */
    static func findAll(byAttribute attribute: String, withFloatValue value: Float, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find all objects by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withBoolValue: value for search
        - parameter inContext: context for search
    */
    static func findAll(byAttribute attribute: String, withBoolValue value: Bool, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate, inContext: context)
    }
    
    /**
        Find all objects by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withStringValue: value for search
        - parameter inContext: context for search
    */
    static func findAll(byAttribute attribute: String, withStringValue value: String, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = %@", value)
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate, inContext: context)
    }
    
    // MARK: - findAll by attribute
    
    /**
        Find all objects by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt64Value: value for search
    */
    static func findAll(byAttribute attribute: String, withInt64Value value: Int64) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate)
    }
    
    /**
        Find all objects by attribute
         
        - parameter byAttribute: name of attribute for search
        - parameter withInt32Value: value for search
    */
    static func findAll(byAttribute attribute: String, withInt32Value value: Int32) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate)
    }
    
    /**
        Find all objects by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt16Value: value for search
    */
    static func findAll(byAttribute attribute: String, withInt16Value value: Int16) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate)
    }
    
    /**
        Find all objects by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt8Value: value for search
    */
    static func findAll(byAttribute attribute: String, withInt8Value value: Int8) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate)
    }
    
    /**
        Find all objects by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withIntValue: value for search
    */
    static func findAll(byAttribute attribute: String, withIntValue value: Int) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate)
    }
    
    /**
        Find all objects by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withDoubleValue: value for search
    */
    static func findAll(byAttribute attribute: String, withDoubleValue value: Double) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate)
    }
    
    /**
        Find all objects by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withFloatValue: value for search
    */
    static func findAll(byAttribute attribute: String, withFloatValue value: Float) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate)
    }
    
    /**
        Find all objects by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withBoolValue: value for search
    */
    static func findAll(byAttribute attribute: String, withBoolValue value: Bool) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate)
    }
    
    /**
        Find all objects by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withStringValue: value for search
    */
    static func findAll(byAttribute attribute: String, withStringValue value: String) -> [NSManagedObject] {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = %@", value)
        
        // Fetch and return data
        return self.findAll(withPredicate: predicate)
    }
    
    #if os(iOS)
    
    // MARK: - NSFetchedResultsController functions
    
    /**
        Fetch all objects with predicate in context
     
        - parameter sortBy: Column name for sorting
        - parameter ascending: sorting order
        - parameter inContext: context for search
        - parameter delegate: NSFetchedResultsControllerDelegate
    */
    static func fetchAll(sortedBy sortedBy: String, ascending: Bool, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: sortedBy, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDuck.quack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Set delegate
        fetchedResultsController.delegate = delegate
        
        // Try to perform fetch request
        do {
            try fetchedResultsController.performFetch()
        } catch {
            
        }
        
        // Return NSFetchedResultsController
        return fetchedResultsController
    }
    
    #endif
    
    #if os(iOS)
    
    /**
        Fetch all objects with predicate in context
     
        - parameter withPredicate: predicate for search
        - parameter sortBy: Column name for sorting
        - parameter ascending: sorting order
        - parameter inContext: context for search
        - parameter delegate: NSFetchedResultsControllerDelegate
    */
    static func fetchAll(withPredicate predicate: NSPredicate, sortBy: String, ascending: Bool, inContext context: NSManagedObjectContext, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: sortBy, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Add Predicate
        fetchRequest.predicate = predicate
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
       
        // Set delegate
        fetchedResultsController.delegate = delegate
        
        // Try to perform fetch request
        do {
            try fetchedResultsController.performFetch()
        } catch {
            
        }
        
        // Return NSFetchedResultsController
        return fetchedResultsController
    }
    
    #endif
    
    #if os(iOS)
    
    // MARK: - fetchAll by attribute in context
    
    /**
        Fetch all objects by attribute in context
     
        - parameter byAttribute: name of attribute for search
        - parameter withInt64Value: value for search
        - parameter sortBy: column name for sorting
        - parameter ascending: sorting order
        - parameter inContext: context for search
        - parameter delegate: NSFetchedResultsControllerDelegate
    */
    static func fetchAll(byAttribute attribute: String, withInt64Value value: Int64, sortBy: String, ascending: Bool, inContext context: NSManagedObjectContext, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController? {
        
        // Build predicate with value
        let predicate = NSPredicate(format: "\(attribute) = \(value)")
        
        // Fetch and return data
        return self.fetchAll(withPredicate: predicate, sortBy: sortBy, ascending: ascending, inContext: context, delegate: delegate)
    }
    
    #endif
    
    // MARK: - Aggregate functions
    
    /**
        Sum by attribute
     
        - parameter byAttribute: name of attribute for search
        - parameter withPredicate: predicate for search
        - parameter inContext: context for search
    */
    static func sum(onAttribute attribute: String, withPredicate predicate: NSPredicate, inContext context: NSManagedObjectContext) -> NSNumber? {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        
        // Add Predicate
        fetchRequest.predicate = predicate
        
        // Set result type
        fetchRequest.resultType = .DictionaryResultType
        
        let receiverName = "total"
        
        // Create expression
        let keyPath = NSExpression(forKeyPath: attribute)
        let calc = NSExpressionDescription()
        calc.name = receiverName
        calc.expression = NSExpression(forFunction: "sum:", arguments: [keyPath])
        calc.expressionResultType = .DoubleAttributeType
        
        fetchRequest.propertiesToFetch = [calc]
        
        do {
            let results = try context.executeFetchRequest(fetchRequest) as NSArray
            
            if let sum = results[0][receiverName] {
                return sum as? NSNumber
            }
        } catch {
            
        }
        
        return nil
    }
}
