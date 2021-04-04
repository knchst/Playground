import Foundation

/// https://gist.github.com/inamiy/98575ec47e06b0cd52efbdec0e0c2b52
/// Recursive Struct in Swift using Box (indirect struct)

@propertyWrapper
class Box<T> {
    var wrappedValue: T

    var projectedValue: Box<T> {
        Box(wrappedValue)
    }

    init(_ value: T) {
        self.wrappedValue = value
    }
}

struct Foo {
    @Box
    var foo: Foo
}

// SeeAlso: https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#ref--box
