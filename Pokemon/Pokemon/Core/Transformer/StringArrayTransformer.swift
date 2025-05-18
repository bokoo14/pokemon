//
//  StringArrayTransformer.swift
//  Pokemon
//
//  Created by bokyung on 5/18/25.
//

import Foundation

@objc(StringArrayTransformer)
final class StringArrayTransformer: ValueTransformer {

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [String] else { return nil }
        do {
            let data = try JSONEncoder().encode(array)
            return data
        } catch {
            print("Encoding error: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
}
