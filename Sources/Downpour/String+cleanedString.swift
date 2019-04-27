//
//  String + CleanedString.swift
//  Downpour
//
//  Created by Stephen Radford on 18/05/2016.
//  Copyright © 2015 Stephen Radford. All rights reserved.
//

import Foundation

extension Substring {
    var cleanedString: String {
        var cleaned = String(self)
        cleaned = cleaned.trimmingCharacters(in: CharacterSet(charactersIn: " -.([]{}))_"))
        cleaned = cleaned.replacingOccurrences(of: ".", with: " ")
        return cleaned
    }
}

extension String {
    var cleanedString: String {
        var cleaned = self
        cleaned = cleaned.trimmingCharacters(in: CharacterSet(charactersIn: " -.([]{}))_"))
        cleaned = cleaned.replacingOccurrences(of: ".", with: " ")
        return cleaned
    }

    func range<Enum: RawRepresentable>(of pattern: Enum, options: String.CompareOptions = []) -> Range<String.Index>? where Enum.RawValue == String {
        return range(of: pattern.rawValue, options: options)
    }

    subscript(r: CountableClosedRange<Int>) -> Substring {
        let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[startIndex ... endIndex]
    }
}
