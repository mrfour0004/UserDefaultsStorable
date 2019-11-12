//
//  Codable+Extension.swift
//  UserDefaultsStorable
//
//  Created by mrfour on 2019/11/9.
//  Copyright © 2019 mrfour. All rights reserved.
//

import Foundation

extension Encodable {
    func encoded(by encoder: JSONEncoder = JSONEncoder()) -> Data? {
        do {
            return try encoder.encode(self)
        } catch let error as EncodingError {
            print("Error happened when encoding \(self): \(error.localizedDescription)")
        } catch {
            print("Error happened when encoding \(self): \(error.localizedDescription)")
        }
        return nil
    }
}

extension Decodable {
    init?(data: Data, using decoder: JSONDecoder = JSONDecoder()) {
        do {
            self = try decoder.decode(Self.self, from: data)
        } catch {
            print("Error happened when decoding \(Self.self): \(error.localizedDescription)")
            return nil
        }
    }
}
