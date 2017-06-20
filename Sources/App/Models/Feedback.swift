//
//  Feedback.swift
//  Feedback
//
//  Created by Malte Bünz on 20.06.17.
//
//

import Foundation
import FluentProvider
import Vapor
import HTTP

final class Feedback: Model {
    let storage = Storage()
    
    /// The column names for `id` and `content` in the database
    static let idKey = "id"
    static let textKey = "text"
    static let osKey = "os"
    static let starsKey = "stars"
    
    var exists: Bool = false
    var id: Node?
    var text: String
    var os: String
    var stars: Int
    
    init(text: String, os: String, stars: Int) {
        self.text = text
        self.os = os
        self.stars = stars
    }
    
    
    
    init(with json: JSON?) throws {
        guard let n = json else {
            print("SAAAD")
            throw ConfigError.maxResolve
        }
        text = try n.get(Feedback.textKey)
        os = try n.get(Feedback.osKey)
        stars = try n.get(Feedback.starsKey)
    }
    
    init(row: Row) throws {
        text = try row.get(Feedback.textKey)
        os = try row.get(Feedback.osKey)
        stars = try row.get(Feedback.starsKey)
    }
    
    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Feedback.textKey, text)
        try row.set(Feedback.osKey, os)
        try row.set(Feedback.starsKey, stars)
        return row
    }
    
    
    func makeNode() throws -> Node {
        return try Node(node: ["text": text,
                               "os": os,
                               "stars": stars])
    }
}

extension Feedback: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Feedback.textKey)
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Feedback: JSONRepresentable, ResponseRepresentable {
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Feedback.idKey, id)
        try json.set(Feedback.textKey, text)
        try json.set(Feedback.osKey, os)
        try json.set(Feedback.starsKey, stars)
        return json
    }
}

extension Feedback: Updateable {
    
    public static var updateableKeys: [UpdateableKey<Feedback>] {
        return [
            UpdateableKey(Feedback.textKey, String.self) { feedback, text in
                feedback.text = text
            }
        ]
    }
    
}
