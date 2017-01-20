# CoreDuck

[![CI Status](http://img.shields.io/travis/appdev-academy/CoreDuck.svg?style=flat)](https://travis-ci.org/appdev-academy/CoreDuck)
[![Version](https://img.shields.io/cocoapods/v/CoreDuck.svg?style=flat)](http://cocoapods.org/pods/CoreDuck)
[![License](https://img.shields.io/cocoapods/l/CoreDuck.svg?style=flat)](http://cocoapods.org/pods/CoreDuck)
[![Platform](https://img.shields.io/cocoapods/p/CoreDuck.svg?style=flat)](http://cocoapods.org/pods/CoreDuck)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+
- macOS 10.10+
- Swift 3.0+

## Installation

CoreDuck is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CoreDuck'
```

## Initialization

```swift
import CoreDuck
```

```swift
// Init CoreDuck
let _ = CoreDuck.quack
```

If you want to see errors in console during development:
```swift
CoreDuck.printErrors = true
```

If you want to specifi name of CoreData *.xcdatamodeld file ("CoreData" by default):
```swift
/// Name of your *.xcdatamodel file
CoreDuck.coreDataModelName = "YourModelName"
```

## Contexts

```swift
/// Main NSManagedObjectContext of the app.
/// Primary usage is UIKit, works on the main thread of the app.
/// It's a singleton - always returns the same instance.
let context = NSManagedObjectContext.main

/// Background NSManagedObjectContext.
/// Returns new instance of NSManagedObjectContext each time you access this variable.
/// Use it for persisting changes to CoreData.
let backgroundContext = NSManagedObjectContext.main
```

## Saving data

```swift
NSManagedObjectContext.saveWithBlock({ context in

}, completion: { success in

})
```

```swift
NSManagedObjectContext.saveWithBlockAndWait({ context in

}, completion: { success in

})
```

## Creating objects

To create a new Core Data object in specified context:

```swift
if let newEntity = context.new(Entity.self) {
  // your code goes here
}
```

## Getting object in context

To create a new Core Data object in specified context:

```swift
if let entityInContext = context.get(entity) {
// your code goes here
}
```

## Deleting objects

```swift
Entity.deleteAllObjects()
```

## Fetching Entities

#### Basic search

As an example, let's assume that you have an entity named *Person*.
You can retrieve all *Person* entities from your persistent store using the following function:

```swift
let people = context.findAll(entity: Person.self)
```

To return the same entities sorted by a specific attribute:

```swift
let people = context.findAll(entity: Person.self, sortedBy: "name", ascending: true)
```

If you want to find object in Core Data by attribute, you can use following functions:
```swift
let people = context.findFirst(entity: Person.self, by: "name", with: "John")
```

```swift
let people = context.findFirst(entity: Person.self, by: "officeID", with: 7)
```

#### Advanced search

If you want to execute more accurate search request, you can use predicates:

```swift
let people = context.findAll(entity: Person.self, with: NSPredicate(format: "entityID IN %@", peopleIDs))
```

#### NSFetchedResultsController

```swift
let people = context.fetchAll(entity: Person.self, sortedBy: "entityID", ascending: true, delegate: self)
```

```swift
let people = context.fetchAll(entity: Person.self, with: predicate, sortedBy: "entityID", ascending: true, delegate: self)
```
```swift
let people = context.fetchAll(entity: Person.self, by: "officeID", with: 7, sortedBy: "entityID", ascending: true, delegate: self)
```

## Authors

- Maksym Skliarov https://github.com/skliarov
- Yura Voevodin https://github.com/yura-voevodin

## License

CoreDuck is available under the MIT license. See the LICENSE file for more info.
