import Vapor
import FluentSQLite

struct User: SQLiteModel, Content, Migration {
    var id: Int?
    let name: String

    init(name: String) {
        self.name = name
    }
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    router.get("users") { req -> Future<[User]> in
        return User.query(on: req).all()
    }

    router.post(User.self, at: "user") { req, user -> Future<User> in
        return user.save(on: req)
    }

    router.get("user", Int.parameter) { req -> Future<User> in
        let id = try req.parameters.next(Int.self)
        return User
            .find(id, on: req)
            .unwrap(or: Abort(.badGateway))
    }
}
