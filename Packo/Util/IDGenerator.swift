//
//  IDGenerator.swift
//  Packo
//
//  Created by Rodrigo Alves on 12/28/15.
//  Copyright © 2015 Kick Ass Apps. All rights reserved.
//

import Foundation

class IDGenerator {
    var id: String?
    
    init(length: Int) {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters
        let lettersLength = UInt32(letters.count)
        
        let randomCharacters = (0..<length).map { i -> String in
            let offset = Int(arc4random_uniform(lettersLength))
            let c = letters[letters.startIndex.advancedBy(offset)]
            return String(c)
        }
        
        self.id = randomCharacters.joinWithSeparator("")
    }
}
