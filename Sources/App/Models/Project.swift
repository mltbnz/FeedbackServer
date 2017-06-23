//
//  Project.swift
//  Feedback
//
//  Created by Malte Bünz on 23.06.17.
//
//

import Foundation
import FluentProvider
import Vapor
import HTTP

final class Project: Model {
    
    let storage = Storage()
    
    internal static let entity = "project"
    
    static let nameKey = "name"
    
    var exists: Bool = false
    var id: Node?
    var name: String
    
    // MARK: Initializers
    init(name: String) {
        self.name = name
    }
    
    init(node: Node, in context: Context) throws {
        name = try node.get(Project.nameKey)
    }
    
    init(from json: JSON?) throws {
        guard let jso = json else {
            throw Abort.badRequest
        }
        name = try jso.get(Project.nameKey)
    }
    
    init(row: Row) throws {
        name = try row.get(Project.nameKey)
    }
    
    // MARK: Maker
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [Project.nameKey: name])
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Project.nameKey, name)
        return row
    }
}

extension Project: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self,
                            closure: { (builder) in
                                builder.id()
                                builder.string(Project.nameKey)
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Project: JSONRepresentable, ResponseRepresentable {
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Project.nameKey, name)
        return json
    }
}
