//
//  PhotoInfo.swift
//  HTTP Session
//
//  Created by Denis Bystruev on 19/08/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

struct PhotoInfo {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url = "hdurl"
        case copyright
    }
}

extension PhotoInfo: Codable {
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        description = try valueContainer.decode(String.self, forKey: CodingKeys.description)
        url = try valueContainer.decode(URL.self, forKey: CodingKeys.url)
        copyright = try? valueContainer.decode(String.self, forKey: CodingKeys.copyright)
    }
}
