//
//  CoreDuck.swift
//
//  Created by App Dev Academy on 3/24/16.
//  Copyright © 2016 App Dev Academy. All rights reserved.
//

import CoreData

public class CoreDuck {
    
    /**
        Singleton instance of CoreData stack
    */
    public static let quack = CoreDuck()
    
    /**
        Set to true to print NSManagedObjectContext save errors to console
    */
    public static var printErrors: Bool = false
    
    private var coreDataModelName = "CoreData"
    
    init() {
        let _ = self.mainContext
    }
    
    private lazy var applicationStoreDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file.
        #if os(iOS)
            let urls = NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)
            return urls[urls.count-1]
        #endif
        
        #if os(OSX)
            let urls = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
            let appSupportURL = urls[urls.count - 1]
            return appSupportURL.URLByAppendingPathComponent(NSBundle.mainBundle().bundleIdentifier!)
        #endif
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(self.coreDataModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        #if os(iOS)
            // Create the coordinator and store
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            let url = self.applicationStoreDirectory.URLByAppendingPathComponent("CoreData.sqlite")
            var failureReason = "There was an error creating or loading the application's saved data."
            do {
                // Migration options for persistent store
                let options = [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ]
                try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
            } catch {
                abort()
            }
            
            return coordinator
        #endif
        
        #if os(OSX)
            let fileManager = NSFileManager.defaultManager()
            var failError: NSError? = nil
            var shouldFail = false
            var failureReason = "There was an error creating or loading the application's saved data."
            
            // Make sure the application files directory is there
            do {
                let properties = try self.applicationStoreDirectory.resourceValuesForKeys([NSURLIsDirectoryKey])
                if !properties[NSURLIsDirectoryKey]!.boolValue {
                    failureReason = "Expected a folder to store application data, found a file \(self.applicationStoreDirectory.path)."
                    shouldFail = true
                }
            } catch  {
                let nserror = error as NSError
                if nserror.code == NSFileReadNoSuchFileError {
                    do {
                        try fileManager.createDirectoryAtPath(self.applicationStoreDirectory.path!, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        failError = nserror
                    }
                } else {
                    failError = nserror
                }
            }
            
            // Create the coordinator and store
            var coordinator: NSPersistentStoreCoordinator? = nil
            if failError == nil {
                coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
                let url = self.applicationStoreDirectory.URLByAppendingPathComponent("CocoaAppCD.storedata")
                do {
                    // Migration options for persistent store
                    let options = [
                        NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true
                    ]
                    try coordinator!.addPersistentStoreWithType(NSXMLStoreType, configuration: nil, URL: url, options: options)
                } catch {
                    failError = error as NSError
                }
            }
            
            if shouldFail || (failError != nil) {
                // Report any error we got.
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                if failError != nil {
                    dict[NSUnderlyingErrorKey] = failError
                }
                let error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                NSApplication.sharedApplication().presentError(error)
                abort()
            } else {
                return coordinator!
            }
        #endif
    }()
    
    /**
        NSManagedObjectContext for writing data to persistent store
    */
    lazy var writingContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    /**
        NSManagedObjectContext for main thread usage
    */
    public lazy var mainContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.parentContext = self.writingContext
        return managedObjectContext
    }()
    
    /**
        NSManagedObjectContext for background usage
    */
    public var backgroundContext: NSManagedObjectContext {
        get {
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
            managedObjectContext.parentContext = self.mainContext
            return managedObjectContext
        }
    }
    
    /**
        Save all contexts
     
        - parameter contextWithObject receivedContext: object added to this context
    */
    func saveContexts(contextWithObject receivedContext: NSManagedObjectContext) -> Bool {
        
        var success = true
        
        receivedContext.performBlock {
            do {
                // Save background NSManagedObjectContext
                try receivedContext.save()
                
                CoreDuck.quack.mainContext.performBlock {
                    do {
                        // Save main NSManagedObjectContext
                        try CoreDuck.quack.mainContext.save()
                        
                        CoreDuck.quack.writingContext.performBlock {
                            do {
                                // Save writing NSManagedObjectContext
                                try CoreDuck.quack.writingContext.save()
                            } catch let error as NSError {
                                // Writing NSManagedObjectContext save error
                                if CoreDuck.printErrors {
                                    print("Writing NSManagedObjectContext save error:", error.userInfo)
                                }
                                
                                success = false
                            }
                        }
                    } catch let error as NSError {
                        // Main NSManagedObjectContext save error
                        if CoreDuck.printErrors {
                            print("Main NSManagedObjectContext save error:", error.userInfo)
                        }
                        
                        success = false
                    }
                }
            } catch let error as NSError {
                // Background NSManagedObjectContext save error
                if CoreDuck.printErrors {
                    print("Background NSManagedObjectContext save error:", error.userInfo)
                }
                
                success = false
            }
        }
        return success
    }
    
    /**
        Save all contexts
     
        - parameter contextWithObject receivedContext: object added to this context
    */
    func saveContextsAndWait(contextWithObject receivedContext: NSManagedObjectContext) -> Bool {
        
        var success = true
        
        receivedContext.performBlockAndWait {
            do {
                // Save background NSManagedObjectContext
                try receivedContext.save()
                
                CoreDuck.quack.mainContext.performBlockAndWait {
                    do {
                        // Save main NSManagedObjectContext
                        try CoreDuck.quack.mainContext.save()
                        
                        CoreDuck.quack.writingContext.performBlockAndWait {
                            do {
                                // Save writing NSManagedObjectContext
                                try CoreDuck.quack.writingContext.save()
                            } catch let error as NSError {
                                // Writing NSManagedObjectContext save error
                                if CoreDuck.printErrors {
                                    print("Writing NSManagedObjectContext save error:", error.userInfo)
                                }
                                
                                success = false
                            }
                        }
                    } catch let error as NSError {
                        // Main NSManagedObjectContext save error
                        if CoreDuck.printErrors {
                            print("Main NSManagedObjectContext save error:", error.userInfo)
                        }
                        
                        success = false
                    }
                }
            } catch let error as NSError {
                // Background NSManagedObjectContext save error
                if CoreDuck.printErrors {
                    print("Background NSManagedObjectContext save error:", error.userInfo)
                }
                
                success = false
            }
        }
        return success
    }
}