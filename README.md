# CoreDuck

[![CI Status](http://img.shields.io/travis/appdev-academy/CoreDuck.svg?style=flat)](https://travis-ci.org/appdev-academy/CoreDuck)
[![Version](https://img.shields.io/cocoapods/v/CoreDuck.svg?style=flat)](http://cocoapods.org/pods/CoreDuck)
[![License](https://img.shields.io/cocoapods/l/CoreDuck.svg?style=flat)](http://cocoapods.org/pods/CoreDuck)
[![Platform](https://img.shields.io/cocoapods/p/CoreDuck.svg?style=flat)](http://cocoapods.org/pods/CoreDuck)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CoreDuck is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CoreDuck"
```

# Creating Entities

To create a new instance of an Entity in the context, you can use:
```swift
if let entity = Entity.new(inContext: localContext) as? Entity {

}
```

# Deleting Entities

To truncate all entities:
```swift
Entity.deleteAllObjects()
```

# Fetching Entities

#### Basic Finding

As an example, if you have an entity named *Person* related to a *Department* entity, you can retrieve all of the *Person* entities from your persistent store using the following method:
```swift
if let people = Person.findAll(inContext: localContext) as? [Person] {
    
}
```
To return the same entities sorted by a specific attribute:
```swift
if let people = Person.findAll(sortedBy: "name", ascending: true) as? [Person] {

}
```
If you have a unique way of retrieving objects from your data store (such as an identifier attribute), you can use the following methods:
```swift
if let people = Person.findAll(byAttribute: "name", withStringValue: "John") as? [Person] {

}
```
```swift
if let people = Person.findAll(byAttribute: "officeID", withInt64Value: 7) as? [Person] {

}
```
And other...

You can use the same but with specific context:
```swift
if let people = Person.findAll(byAttribute: "name", withStringValue: "John", inContext: localContext) as? [Person] {

}
```
```swift
if let people = Person.findAll(byAttribute: "officeID", withInt64Value: 7, inContext: localContext) as? [Person] {

}
```

#### Advanced Finding

If you want to be more specific with your search, you can use a predicate:
```swift
if let people = Person.findAll(withPredicate: NSPredicate(format: "entityID IN %@", peopleIDs)) as? [Person] {

} 
```

And the same with context:
```swift
if let people = Person.findAll(withPredicate: NSPredicate(format: "entityID IN %@", peopleIDs), inContext: localContext) as? [Person] {

} 
```

#### Returning an NSFetchRequest

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
