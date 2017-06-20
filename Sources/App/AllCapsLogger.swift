//
//  AllCapsLogger.swift
//  Feedback
//
//  Created by Malte Bünz on 20.06.17.
//
//

import Vapor
import Foundation

final class AllCapsLogger: LogProtocol {
    var enabled: [LogLevel] = []
    let exclamationCount: Int
    
    init(exclamationCount: Int) {
        self.exclamationCount = exclamationCount
    }
    
    func log(_ level: LogLevel, message: String, file: String, function: String, line: Int) {
        print(message + String(repeating: "!", count: exclamationCount))
    }
}

extension AllCapsLogger: ConfigInitializable {
    convenience init(config: Config) throws {
        let count = config["allCaps", "exclamationCount"]?.int ?? 3
        self.init(exclamationCount: count)
    } 
}
