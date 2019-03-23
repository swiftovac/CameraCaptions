//
//  Caption.swift
//  Day50Project
//
//  Created by Stefan Milenkovic on 3/23/19.
//  Copyright © 2019 Stefan Milenkovic. All rights reserved.
//

import Foundation

class Caption: Codable {
    
    var caption: String
    var image: String
    
    
    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
    
    
}
