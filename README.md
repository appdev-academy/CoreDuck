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
- Swift 2.2+

## Installation

CoreDuck is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CoreDuck'
```

# Creating objects

To create a new Core Data object in specified context:

```swift
if let newEntity = Entity.new(inContext: localContext) as? Entity {
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
if let people = Person.findAll(inContext: localContext) as? [Person] {
  // your code goes here
}
```

To return the same entities sorted by a specific attribute:

```swift
if let people = Person.findAll(sortedBy: "name", ascending: true) as? [Person] {
  // your code goes here
}
```

If you want to find object in Core Data by attribute, you can use following functions:
```swift
if let people = Person.findAll(byAttribute: "name", withStringValue: "John") as? [Person] {
  // your code goes here
}
```

```swift
if let people = Person.findAll(byAttribute: "officeID", withInt64Value: 7) as? [Person] {
  // your code goes here
}
```

You can use same functions, but with specific context, e.g. objects will be returned in context you specified:

```swift
if let people = Person.findAll(byAttribute: "name", withStringValue: "John", inContext: localContext) as? [Person] {
  // your code goes here
}
```

```swift
if let people = Person.findAll(byAttribute: "officeID", withInt64Value: 7, inContext: localContext) as? [Person] {
  // your code goes here
}
```

#### Advanced search

If you want to execute more accurate search request, you can use predicates:

```swift
if let people = Person.findAll(withPredicate: NSPredicate(format: "entityID IN %@", peopleIDs)) as? [Person] {
  // your code goes here
}
```

And the same with specific context:

```swift
if let people = Person.findAll(withPredicate: NSPredicate(format: "entityID IN %@", peopleIDs), inContext: localContext) as? [Person] {
  // your code goes here
}
```

#### NSFetchedResultsController
\* iOS only

```swift
let peopleRequest = Person.fetchAll(sortedBy: "entityID", ascending: true, delegate: self)
```

```swift
let peopleRequest = Person.fetchAll(withPredicate: predicate, sortBy: "entityID", ascending: true, inContext: mainContext, delegate: self)
```
```swift
let peopleRequest = Person.fetchAll(byAttribute: "officeID", withInt64Value: 7, sortBy: "entityID", ascending: true, inContext: mainContext, delegate: self)
```

## Authors

Maksym Skliarov https://github.com/skliarov

Yura Voevodin https://github.com/yura-voevodin

## License

CoreDuck is available under the MIT license. See the LICENSE file for more info.
