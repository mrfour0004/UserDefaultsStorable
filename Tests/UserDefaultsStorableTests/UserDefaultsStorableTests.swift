import XCTest
@testable import UserDefaultsStorable

final class UserDefaultsStorableTests: XCTestCase {

    override class func setUp() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    func testPrimitveTypes() {
        XCTAssertEqual(PrimitiveDefaults.string, "default string")
        PrimitiveDefaults.string = "test string"
        XCTAssertEqual(PrimitiveDefaults.string, "test string")

        XCTAssertEqual(PrimitiveDefaults.int, 100)
        PrimitiveDefaults.int = 2
        XCTAssertEqual(PrimitiveDefaults.int, 2)

        XCTAssertEqual(PrimitiveDefaults.double, 3.14)
        PrimitiveDefaults.double = 6.28
        XCTAssertEqual(PrimitiveDefaults.double, 6.28)

        XCTAssertEqual(PrimitiveDefaults.bool, true)
        PrimitiveDefaults.bool = false
        XCTAssertEqual(PrimitiveDefaults.bool, false)

        XCTAssertEqual(String(data: PrimitiveDefaults.data, encoding: .utf8), "data")
        PrimitiveDefaults.data = "new data".data(using: .utf8)!
        XCTAssertEqual(String(data: PrimitiveDefaults.data, encoding: .utf8), "new data")
    }

    func testOptional() {
        XCTAssertNil(OptionalDefaults.string)
        OptionalDefaults.string = "optional string"
        XCTAssertEqual(OptionalDefaults.string, "optional string")
        OptionalDefaults.string = nil
        XCTAssertNil(OptionalDefaults.string)
    }

    func testProjectedValue() {
        let string = PrimitiveDefaults.$projectedString
        XCTAssertEqual(string.wrappedValue, "projected")

        string.wrappedValue = "wrapped string"
        XCTAssertEqual(string.wrappedValue, "wrapped string")

        PrimitiveDefaults.projectedString = "new string"
        XCTAssertEqual(string.wrappedValue, "new string")

        let optionalString = OptionalDefaults.$projectedString
        XCTAssertNil(optionalString.wrappedValue)

        optionalString.wrappedValue = "wrapped"
        XCTAssertEqual(optionalString.wrappedValue, "wrapped")

        optionalString.wrappedValue = nil
        XCTAssertNil(optionalString.wrappedValue)
    }

    func testEnum() {
        XCTAssertEqual(Defaults.stringEnum, .boo)
        Defaults.stringEnum = .far
        XCTAssertEqual(Defaults.stringEnum, .far)

        XCTAssertEqual(Defaults.codableStringEnum, .boo)
        Defaults.codableStringEnum = .far
        XCTAssertEqual(Defaults.codableStringEnum, .far)
    }

    func testCodable() {
        XCTAssertNil(Defaults.person)
        Defaults.person = Person(name: "Jason", age: 18, gender: .male)
        XCTAssertEqual(Defaults.person?.name, "Jason")
    }

    func testArray() {
        XCTAssertEqual(Defaults.intArray, [])
        Defaults.intArray.append(1)
        XCTAssertEqual(Defaults.intArray, [1])
        Defaults.intArray.append(contentsOf: [2, 3, 4])
        XCTAssertEqual(Defaults.intArray, [1, 2, 3, 4])

        XCTAssertTrue(Defaults.codableArray.isEmpty)
        Defaults.codableArray.append(Person(name: "Far", age: 18, gender: .female))
        XCTAssertEqual(Defaults.codableArray.count, 1)
    }

    func testDictionary() {
        let dict: [String: Any] = [
            "string": "string value",
            "int": 1234,
            "bool": true
        ]
        XCTAssertTrue(Defaults.dictionary.isEmpty)
        Defaults.dictionary = dict
        XCTAssertEqual(Defaults.dictionary["string"] as? String, "string value")
        XCTAssertEqual(Defaults.dictionary["int"] as? Int, 1234)
        XCTAssertEqual(Defaults.dictionary["bool"] as? Bool, true)


    }

    func testObservation() {
        let expect = expectation(description: "change handler is called.")

        // somehow old value get `nil` without setting this
        Defaults.observedString = "observing"
        var observer: Observer? = Observer()
        observer?.tokens.append(Defaults.$observedString.observe(withOptions: [.old, .new]) { change in
            XCTAssertEqual(change.oldValue, "observing")
            XCTAssertEqual(change.newValue, "observed")
            expect.fulfill()
        })
        Defaults.observedString = "observed"
        observer = nil
        Defaults.observedString = "observed again" // this should not trigger change
        wait(for: [expect], timeout: 2)
    }

    func testInvalidateObservation() {
        var isInvalidated = false
        var token: UserDefaultObservation? = Defaults.$invalidation.observe(withOptions: .new) { change in
            if isInvalidated {
                XCTFail("Shouldn't get here after invalidated")
            } else {
                XCTAssertEqual(change.newValue, "invalidation 2")
            }
        }
        Defaults.invalidation = "invalidation 2"
        token?.invalidate()
        isInvalidated = true
        Defaults.invalidation = "invalidation 3"
        token = nil
    }
    

    static var allTests = [
        ("testPrimitveTypes", testPrimitveTypes),
        ("testProjectedValue", testProjectedValue),
        ("testOptional", testOptional),
        ("testEnum", testEnum),
        ("testCodable", testCodable),
        ("testArray", testArray),
        ("testObservation", testObservation),
        ("testInvalidateObservation", testInvalidateObservation)
    ]

    private class Observer {
        var tokens: [UserDefaultObservation] = []
    }
}

private enum PrimitiveDefaults {
    @UserDefault(key: "string", defaultValue: "default string")
    static var string: String

    @UserDefault(key: "int", defaultValue: 100)
    static var int: Int

    @UserDefault(key: "double", defaultValue: 3.14)
    static var double: Double

    @UserDefault(key: "bool", defaultValue: true)
    static var bool: Bool

    @UserDefault(key: "data", defaultValue: "data".data(using: .utf8)!)
    static var data: Data

    @UserDefault(key: "projected string", defaultValue: "projected")
    static var projectedString: String
}

private enum OptionalDefaults {
    @OptionalUserDefault(key: "optional string")
    static var string: String?

    @OptionalUserDefault(key: "projected optional string")
    static var projectedString: String?
}

private enum StringEnum: String, UserDefaultsStorable {
    case boo, far
}

private enum CodableStringEnum: String, Codable, UserDefaultsStorable {
    case boo, far
}

private struct Person: Codable, UserDefaultsStorable, Equatable {

    enum Gender: Int, Codable {
         case male, female
    }

    let name: String
    let age: Int
    let gender: Gender
}

private enum Defaults {
    @UserDefault(key: "stringEnum", defaultValue: .boo)
    static var stringEnum: StringEnum

    @UserDefault(key: "codableStringEnum", defaultValue: .boo)
    static var codableStringEnum: CodableStringEnum

    @OptionalUserDefault(key: "person")
    static var person: Person?

    @UserDefault(key: "intArray", defaultValue: [])
    static var intArray: [Int]

    @UserDefault(key: "codableArray", defaultValue: [])
    static var codableArray: [Person]

    @UserDefault(key: "observedString", defaultValue: "observing")
    static var observedString: String

    @OptionalUserDefault(key: "invalidation")
    static var invalidation: String?

    @UserDefault(key: "dictionary", defaultValue: [:])
    static var dictionary: [String: Any]

    @UserDefault(key: "dictionaries", defaultValue: [])
    static var dictionaries: [[String: Any]]
}
