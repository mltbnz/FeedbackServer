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
    static let projectIdKey = "project_id"
    static let feedbackTextKey = "feedback"
    static let osKey = "os"
    static let starsKey = "stars"
    
    var exists: Bool = false
    var id: Node?
    var projectId: Node?
    var feedback: String
    var os: String
    var stars: Int
    
    init(text: String, os: String, stars: Int, projectId: Node? = nil) {
        self.feedback = text
        self.os = os
        self.stars = stars
        self.projectId = projectId
    }
    
    init(node: Node) throws {
        id = try node.get(Feedback.idKey)
        projectId = try node.get(Feedback.projectIdKey)
        feedback = try node.get(Feedback.feedbackTextKey)
        os = try node.get(Feedback.osKey)
        stars = try node.get(Feedback.starsKey)
    }
    
    init(with json: JSON?) throws {
        guard let n = json else {
            throw Abort.badRequest
        }
        projectId = try n.get(Feedback.projectIdKey)
        feedback = try n.get(Feedback.feedbackTextKey)
        os = try n.get(Feedback.osKey)
        stars = try n.get(Feedback.starsKey)
    }
    
    init(row: Row) throws {
        id = try row.get(Feedback.idKey)
        projectId = try row.get(Feedback.projectIdKey)
        feedback = try row.get(Feedback.feedbackTextKey)
        os = try row.get(Feedback.osKey)
        stars = try row.get(Feedback.starsKey)
    }
    
    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Feedback.projectIdKey, projectId)
        try row.set(Feedback.feedbackTextKey, feedback)
        try row.set(Feedback.osKey, os)
        try row.set(Feedback.starsKey, stars)
        return row
    }
    
    func makeNode() throws -> Node {
        return try Node(node: [
            Feedback.idKey: id,
            Feedback.projectIdKey: projectId,
            Feedback.feedbackTextKey: feedback,
            Feedback.osKey: os,
            Feedback.starsKey: stars])
    }
}

extension Feedback: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.parent(Project.self,
                           optional: false,
                           unique: false,
                           foreignIdKey: "name")
            builder.string(Feedback.feedbackTextKey)
            builder.string(Feedback.osKey)
            builder.int(Feedback.starsKey)
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
        try json.set(Feedback.projectIdKey, projectId)
        try json.set(Feedback.feedbackTextKey, feedback)
        try json.set(Feedback.osKey, os)
        try json.set(Feedback.starsKey, stars)
        return json
    }
}

extension Feedback: Updateable {
    
    public static var updateableKeys: [UpdateableKey<Feedback>] {
        return [
            UpdateableKey(Feedback.feedbackTextKey, String.self) { feedback, text in
                feedback.feedback = text
            }
        ]
    }
}

extension Feedback {
    
}
