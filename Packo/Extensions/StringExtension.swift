//
//  StringExtension.swift
//  Packo
//
//  Created by Rodrigo Alves on 5/31/15.
//  Copyright (c) 2015 Rodrigo Alves. All rights reserved.
//

import Foundation

extension String {
    ///  Removes any leading or trailing spaces from the given string
    ///
    ///  - returns: An initialized `String` without any leading or trailing spaces.
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func capitalize() -> String {
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).capitalizedString)
        
        return result
    }
    
    var length: Int {
        return self.characters.count
    }
    
    var last: String {
        return self.subString(self.length - 1, length: 1)
    }
    
    subscript (i: Int) -> String {
        if self.length > i {
            return String(Array(self.characters)[i])
        }
        
        return ""
    }
    
    func indexAt(theInt:Int) -> String.Index {
        return self.startIndex.advancedBy(theInt)
    }
    
    func subString(startIndex: Int, length: Int) -> String {
        let start = self.startIndex.advancedBy(startIndex)
        let end = self.startIndex.advancedBy(startIndex + length)
        
        return self.substringWithRange(Range<String.Index>(start: start, end: end))
    }
}