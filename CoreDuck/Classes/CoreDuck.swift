//
//  CoreDuck.swift
//
//  Created by App Dev Academy on 3/24/16.
//  Copyright © 2016 App Dev Academy. All rights reserved.
//

import CoreData

public class CoreDuck {
    
    /// Singleton instance
    static let sharedStack = CoreDuck()
    
    private var coreDataModelName = "CoreData"
    
    init() {
        let _ = self.mainContext
    }
    
    private lazy var applicationLibraryDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(self.coreDataModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationLibraryDirectory.URLByAppendingPathComponent("CoreData.sqlite")
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
    lazy var mainContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.parentContext = self.writingContext
        return managedObjectContext
    }()
    
    /**
        NSManagedObjectContext for background usage
    */
    internal var backgroundContext: NSManagedObjectContext {
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
                try receivedContext.save()
                
                CoreDataStack.sharedStack.mainContext.performBlock {
                    do {
                        try CoreDataStack.sharedStack.mainContext.save()
                        
                        CoreDataStack.sharedStack.writingContext.performBlock {
                            do {
                                try CoreDataStack.sharedStack.writingContext.save()
                            } catch {
                                success = false
                            }
                        }
                    } catch {
                        success = false
                    }
                }
            } catch {
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
                try receivedContext.save()
                
                CoreDuck.sharedStack.mainContext.performBlockAndWait {
                    do {
                        try CoreDuck.sharedStack.mainContext.save()
                        
                        CoreDuck.sharedStack.writingContext.performBlockAndWait {
                            do {
                                try CoreDuck.sharedStack.writingContext.save()
                            } catch {
                                success = false
                            }
                        }
                    } catch {
                        success = false
                    }
                }
            } catch {
                success = false
            }
        }
        return success
    }
}