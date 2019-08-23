//
//  CoreDuck.swift
//
//  Created by App Dev Academy on 3/24/16.
//  Copyright © 2016 App Dev Academy. All rights reserved.
//

import CoreData

open class CoreDuck {
  
  /// Singleton instance of CoreData stack
  public static let quack = CoreDuck()
  
  /// Set this variable to true if you want to print errors to console
  public static var printErrors: Bool = false
  
  /// Name of your *.xcdatamodel file
  public static var coreDataModelName = "CoreData"
  
  init() {
    let _ = self.mainContext
  }
  
  /// Directory to store CoreData files
  fileprivate lazy var applicationStoreDirectory: NSURL = {
    #if os(iOS)
      let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
      return urls.last! as NSURL
    #endif
    
    #if os(macOS)
      let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
      let appSupportURL = urls.last!
      return appSupportURL.appendingPathComponent(Bundle.main.bundleIdentifier!) as NSURL
    #endif
  }()
  
  /// NSManagedObjectModel for CoreDuck stack
  /// This property is not optional. It is a fatal error for the application not to be able to find and load its model.
  fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = Bundle.main.url(forResource: CoreDuck.coreDataModelName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  /// NSPersistentStoreCoordinator for CoreDuck stack.
  /// Creates and returns instance of NSPersistentStoreCoordinator. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
  open lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    #if os(iOS)
      // Create the coordinator and store
      let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
      let url = defaultPersistentStoreURL()
      let result = addPersistentStore(at: url, for: coordinator)

      switch result {
      case .success:
        return coordinator
      case .failure:
        abort()
      }
    #endif
    
    #if os(macOS)
      let fileManager = FileManager.default
      var failError: NSError? = nil
      var shouldFail = false
      var failureReason = "There was an error creating or loading the application's saved data."
      
      // Make sure application files directory is there
      do {
        let properties = try applicationStoreDirectory.resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
        if !(properties[URLResourceKey.isDirectoryKey]! as AnyObject).boolValue {
          failureReason = "Expected a folder to store application data, found a file \(applicationStoreDirectory.path ?? "")."
          shouldFail = true
        }
      } catch {
        let nserror = error as NSError
        if nserror.code == NSFileReadNoSuchFileError {
          do {
            try fileManager.createDirectory(atPath: applicationStoreDirectory.path!, withIntermediateDirectories: true, attributes: nil)
          } catch {
            failError = nserror
          }
        } else {
          failError = nserror
        }
      }
      
      // Create coordinator and store
      var coordinator: NSPersistentStoreCoordinator? = nil
      if failError == nil {
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = defaultPersistentStoreURL()
        let result = addPersistentStore(at: url, for: coordinator!)

        switch result {
        case .success:
          break
        case .failure(let error):
          failError = error as NSError
        }
      }
      
      if shouldFail || (failError != nil) {
        // Report any error we got.
        var dict = [String: AnyObject]()
        dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
        dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
        if failError != nil {
          dict[NSUnderlyingErrorKey] = failError
        }
        let error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
        print(error)
        abort()
      } else {
        return coordinator!
      }
    #endif
  }()
  
  /// NSManagedObjectContext with privateQueueConcurrencyType
  /// It's used internally in CoreDuck as the only context to write to persistence store
  /// For saving data use backgroundContext instead
  lazy var writingContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.persistentStoreCoordinator = self.persistentStoreCoordinator
    return context
  }()
  
  /// NSManagedObjectContext with mainQueueConcurrencyType
  /// Use it with UIKit, since it's the only NSManagedObjectContext that exists on main thread
  open lazy var mainContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.parent = self.writingContext
    return context
  }()
  
  /// NSManagedObjectContext with privateQueueConcurrencyType
  /// Use it for background save operations
  open var backgroundContext: NSManagedObjectContext {
    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.parent = self.mainContext
    return context
  }
  
  /// Save all contexts
  ///
  /// - Parameter receivedContext: background context to save
  /// - Returns: success of contexts save operation (true or false)
  func saveContexts(contextWithObject receivedContext: NSManagedObjectContext) -> Bool {
    
    var success = true
    
    receivedContext.perform {
      do {
        // Save background NSManagedObjectContext
        try receivedContext.save()
        
        CoreDuck.quack.mainContext.perform {
          do {
            // Save main NSManagedObjectContext
            try CoreDuck.quack.mainContext.save()
            
            CoreDuck.quack.writingContext.perform {
              do {
                // Save writing NSManagedObjectContext
                try CoreDuck.quack.writingContext.save()
              } catch let error as NSError {
                // Writing NSManagedObjectContext save error
                CoreDuck.printError("Writing NSManagedObjectContext save error: \(error.userInfo)")
                success = false
              }
            }
          } catch let error as NSError {
            // Main NSManagedObjectContext save error
            CoreDuck.printError("Main NSManagedObjectContext save error: \(error.userInfo)")
            success = false
          }
        }
      } catch let error as NSError {
        // Background NSManagedObjectContext save error
        CoreDuck.printError("Background NSManagedObjectContext save error: \(error.userInfo)")
        success = false
      }
    }
    return success
  }
  
  /// Save all contexts and wait
  ///
  /// - Parameter receivedContext: background context to save
  /// - Returns: success of contexts save operation (true or false)
  func saveContextsAndWait(contextWithObject receivedContext: NSManagedObjectContext) -> Bool {
    
    var success = true
    
    receivedContext.performAndWait {
      do {
        // Save background NSManagedObjectContext
        try receivedContext.save()
        
        CoreDuck.quack.mainContext.performAndWait {
          do {
            // Save main NSManagedObjectContext
            try CoreDuck.quack.mainContext.save()
            
            CoreDuck.quack.writingContext.performAndWait {
              do {
                // Save writing NSManagedObjectContext
                try CoreDuck.quack.writingContext.save()
              } catch let error as NSError {
                // Writing NSManagedObjectContext save error
                CoreDuck.printError("Writing NSManagedObjectContext save error: \(error.userInfo)")
                success = false
              }
            }
          } catch let error as NSError {
            // Main NSManagedObjectContext save error
            CoreDuck.printError("Main NSManagedObjectContext save error: \(error.userInfo)")
            success = false
          }
        }
      } catch let error as NSError {
        // Background NSManagedObjectContext save error
        CoreDuck.printError("Background NSManagedObjectContext save error: \(error.userInfo)")
        success = false
      }
    }
    return success
  }
  
  /// Print error in console
  /// Will print error only if `printErrors` set in true
  ///
  /// - Parameter error: String error text
  static func printError(_ error: String) {
    if CoreDuck.printErrors {
      print("⚠️ ", error)
    }
  }
  
  public static func managedObjectID(forURIRepresentation uri: URL) -> NSManagedObjectID? {
    return quack.persistentStoreCoordinator.managedObjectID(forURIRepresentation: uri)
  }

  // MARK: - Persistent Store

  /// Add NSPersistentStore at URL.
  /// Private method that used on initialization of the default NSPersistentStoreCoordinator.
  private func addPersistentStore(at persistentStoreURL: URL?, for coordinator: NSPersistentStoreCoordinator) -> Result<Bool, Error> {
    do {
      // Migration options for persistent store
      let options = [
        NSMigratePersistentStoresAutomaticallyOption: true,
        NSInferMappingModelAutomaticallyOption: true
      ]
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
      return .success(true)
    } catch {
      return .failure(error)
    }
  }

  /// Add persistent store at URL
  public func addPersistentStore(at persistentStoreURL: URL?) -> Result<Bool, Error> {
    return addPersistentStore(at: persistentStoreURL, for: persistentStoreCoordinator)
  }

  /// Add persistent store
  public func addDefaultPersistentStore() -> Bool {
    let persistentStoreURL = defaultPersistentStoreURL()
    let result = addPersistentStore(at: persistentStoreURL, for: persistentStoreCoordinator)
    switch result {
    case .failure:
      return false
    case .success:
      return true
    }
  }

  /// Destroy default NSPersistentStore at URL
  @available(iOS 9.0, *)
  @available(OSX 10.11, *)
  public func destroyDefaultPersistentStore() -> Bool {
    guard let persistentStoreURL = defaultPersistentStoreURL() else { return false }
    do {
      try persistentStoreCoordinator.destroyPersistentStore(at: persistentStoreURL, ofType: NSSQLiteStoreType, options: nil)
      return true
    } catch {
      CoreDuck.printError(error.localizedDescription)
      return false
    }
  }

  /// Default URL for NSPersistentStore
  public func defaultPersistentStoreURL() -> URL? {
    let url = applicationStoreDirectory.appendingPathComponent("CoreData.sqlite")
    return url
  }
}
