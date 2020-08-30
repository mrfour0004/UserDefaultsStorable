# UserDefaultsStorable

UserDefaultsStorable provides an easy, strongly-typed way to access properties in UserDefaults.

## Summary
- **Strongly typed**: Access properties without type casting.
- **Codable support**: Support any types conform to Codable.
- **Observation**: Observe changes to properties with the given key.[

## Requirement
- iOS 11.0+
- Xcode 11.4+
- Swift 5.2+

## Installation
### Cocoapods
```ruby
pod "UserDefaultsStorable"
```

### Swift Package Manager
```swift
.package(url: "https://github.com/mrfour0004/UserDefaultsStorable", from: "1.1.0")
```

## Usage
To starting using `UserDefaultsStorable`, simply declare a `UserDefaults` property with a given key and a default value. If the property could be `nil`, use `OptionalUserDefaults` instead.
```swift
enum Defaults {
    @UserDefault(key: "username", defaultValue: "guest")
    static var username: String
            
    // If the property doesn't have a default value, use `OptionalUserDefault`.
    @OptionalUserDefaults(key: "token")
    static var token: String?   
}

print(Defaults.username) // guest
print(Defaults.token)    // nil
```
### Conforms types to `UserDefaultsStorable`
You may have custom types and want them can be stored in `UserDefaults`. Just conform them to the protocol `UserDefaultsStorable`, and implement the required `userDefaultsBridge` property. 
```swift
struct Point {
    let x: Int, y: Int
}

extension Point: UserDefaultsStorable {
    static var userDefaultsBridge: UserDefautsBridge<Point> {
        UserDefaultsBridge(
            serialization: { point in
                return ["x": point.x, "y": point.y]
            },
            deserialization: { object in
                guard
                    let dict = object as? [String: Int]
                    let x = dict["x"] as? Int,
                    let y = dict["y"] as? Int
                else { return nil }
                return Point(x: x, y: y)
            }
        }
    }
}
```
If the type conforms to `Codable` as well, then there's already a default implementation of `userDefaultsBridge`.
```swift
struct Point: Codable, UserDefaultsStorable {
    let x: Int, y: Int
}

enum Defaults {
    @OptionalUserDefault(key: "point")
    static var point: Point
}
```
### Observation
```swift
enum Defaults {
    @UserDefault(key: "username", defaultValue: "guest")
    static var username: String
}

let observation = Defaults.$username.observe(withOptions: [.old, .new]) { change in
    print(change.newValue) // print Optional("guest")
    print(change.oldValue) // print Optional("mrfour")
}

let newValueObservation = Defaults.$username.observe { newValue in 
    print(newValue) // print Optional("mrfour")
}

Defaults.username = "mrfour"
```
## License
UserDefaultsStorable is available under the MIT license. See the LICENSE file for more info.
