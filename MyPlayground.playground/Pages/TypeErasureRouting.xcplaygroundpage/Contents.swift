//: A UIKit based Playground for presenting user interface
  
import UIKit

// Using Type Erasure to Build a Dependency Injecting Routing Framework in Swift
// ref: https://swiftrocks.com/using-type-erasure-to-build-a-dependency-injector-in-swift.html

///
public protocol Feature {
    associatedtype Dependencies
    static var dependenciesInitializer: AnyInitializer { get }
    static func build(dependencies: Dependencies) -> UIViewController
}

public protocol Dependency {}

public final class RouterService: Dependency {
    private var store = Store()

    public init() {
        register(dependency: self)
    }

    public func register(dependency: Dependency) {
        store.register(dependency)
    }

    public func navigate<T: Feature>(
        toFeature: T.Type,
        fromView viewController: UIViewController
    ) {
        let dependencies = T.dependenciesInitializer.build(store) as! T.Dependencies
        let viewController = T.build(dependencies: dependencies)
        viewController.navigationController?.pushViewController(viewController, animated: true)
    }
}

final public class Store {
    private var dependencies = [String: Any]()

    public func get<T>(_ dependencyType: T.Type) -> T {
        let name = String(describing: dependencyType)
        return dependencies[name] as! T
    }

    public func register(_ dependency: Dependency) {
        let name = String(describing: type(of: dependency))
        dependencies[name] = dependency
    }
}

public final class AnyInitializer {
    public let build: (Store) -> Any

    public init<T>(_ function: @escaping () -> T) {
        build = { store in
            return function()
        }
    }

    public init<T: Dependency, U>(_ function: @escaping (T) -> U) {
        build = { store in
            let t: T = store.get(T.self)
            return function(t)
        }
    }

    public init<T: Dependency, U: Dependency, V>(_ function: @escaping (T, U) -> V) {
        build = { store in
            let t: T = store.get(T.self)
            let u: U = store.get(U.self)
            return function(t, u)
        }
    }

    public init<T: Dependency, U: Dependency, V: Dependency, W>(_ function: @escaping (T, U, V) -> W) {
        build = { store in
            let t: T = store.get(T.self)
            let u: U = store.get(U.self)
            let v: V = store.get(V.self)
            return function(t, u, v)
        }
    }
}

// =====

class FeatureOneViewController: UIViewController {
    private let dependencies: FeatureOne.Dependencies

    init(dependencies: FeatureOne.Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum FeatureOne: Feature {
    static let dependenciesInitializer: AnyInitializer = .init(Dependencies.init)

    struct Dependencies {

    }

    static func build(dependencies: FeatureOne.Dependencies) -> UIViewController {
        return FeatureOneViewController(dependencies: dependencies)
    }
}


let routerService = RouterService()

routerService.navigate(toFeature: FeatureOne.self, fromView: UIViewController())
