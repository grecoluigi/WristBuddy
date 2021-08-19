//
//  RSSData.swift
//  WristBuddy WatchKit Extension
//
//  Created by Luigi Greco on 14/08/2021.
//

import Foundation

class RSSData : Codable {
    let title: String
    let description: String
    let url: String
    
    init(title: String, description: String, url: String) {
        self.title = title
        self.description = description
        self.url = url
    }
}
