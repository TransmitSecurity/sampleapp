//
//  DictionaryExtension.swift
//  IdentityOrchestration
//
//  Created by Igor Babitski on 11/10/2023.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func decode<T>(_ type: T.Type) -> T? where T: Decodable {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return nil }
        let object = try? JSONDecoder().decode(type, from: data)
        
        return object
    }
    
    func mergeing(_ dictionary: [Key: Value], override: Bool = false) -> [Key: Value] {
        let result: [Key: Value]
        
        if override {
            result = self.merging(dictionary, uniquingKeysWith: { current, _ in current })
        } else {
            result = self.merging(dictionary, uniquingKeysWith: { _, new in new })
        }
        
        return result
    }
}

extension Encodable {
    public var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
