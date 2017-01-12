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
}
