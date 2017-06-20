//
//  FeedbackController.swift
//  Feedback
//
//  Created by Malte Bünz on 20.06.17.
//
//

import Vapor
import HTTP

final class FeedbackController: ResourceRepresentable {
    
    // called when user calls 'GET' in feedback
    func index(req: Request) throws -> ResponseRepresentable {
        return try Feedback.all().makeJSON()
    }
    
    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/posts/13rd88' we should show that specific post
    func show(req: Request, feedback: Feedback) throws -> ResponseRepresentable {
        return feedback
    }
    
    /// When consumers call 'POST' on '/feedback' with valid JSON
    /// create and save the post
    func create(request: Request) throws -> ResponseRepresentable {
        var feedback = try request.feedback()
        try feedback.save()
        return feedback
    }
    
    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'posts/l2jd9' we should remove that resource from the database
    func delete(req: Request, feedback: Feedback) throws -> ResponseRepresentable {
        try feedback.delete()
        return Response(status: .ok)
    }
    
    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/posts' we should remove the entire table
    func clear(req: Request) throws -> ResponseRepresentable {
        try Feedback.makeQuery().delete()
        return Response(status: .ok)
    }
    
    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(req: Request, feedback: Feedback) throws -> ResponseRepresentable {
        // See `extension Post: Updateable`
        try feedback.update(for: req)
        
        // Save an return the updated post.
        try feedback.save()
        return feedback
    }
    
    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
    func makeResource() -> Resource<Feedback> {
        return Resource(
            index: index,
            store: create,
            show: show,
            update: update,
            destroy: delete,
            clear: clear
        )
    }
    
}

extension Request {
    
    func feedback() throws -> Feedback {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try Feedback(with: json)
    }
}

extension FeedbackController: EmptyInitializable {}
