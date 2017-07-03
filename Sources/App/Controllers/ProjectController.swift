//
//  ProjectController.swift
//  Project
//
//  Created by Malte Bünz on 30.06.17.
//
//

import Vapor
import HTTP
import Routing


final class ProjectController: ResourceRepresentable {
    
    

    // called when user calls 'GET' in project
    func index(req: Request) throws -> ResponseRepresentable {
        return try Project.all().makeJSON()
    }
    
    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/posts/13rd88' we should show that specific post
    func show(req: Request, project: Project) throws -> ResponseRepresentable {
        return try project // try project.feedback().makeJSON()
    }
    
    /// When consumers call 'POST' on '/project' with valid JSON
    /// create and save the post
    func create(request: Request) throws -> ResponseRepresentable {
        var project = try request.project()
        try project.save()
        return project
    }
    
    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'posts/l2jd9' we should remove that resource from the database
    func delete(req: Request, project: Project) throws -> ResponseRepresentable {
        try project.delete()
        return Response(status: .ok)
    }
    
    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/posts' we should remove the entire table
    func clear(req: Request) throws -> ResponseRepresentable {
        try Project.makeQuery().delete()
        return Response(status: .ok)
    }
    
    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(req: Request, pj: Project) throws -> ResponseRepresentable {
        // See `extension Post: Updateable`
        try pj.update(for: req)
        
        // Save an return the updated post.
        try pj.save()
        return pj
    }
    
    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
    func makeResource() -> Resource<Project> {
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
    
    func project() throws -> Project {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try Project(node: Node(json))
    }
}

extension ProjectController: EmptyInitializable {}
