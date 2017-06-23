import Vapor

extension Droplet {
    
    func setupRoutes() throws {

        get("description") { req in return req.description }
        
        try resource("feedback", FeedbackController.self)
    }
}
