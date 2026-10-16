//
//  GlobalJTO+Coding.swift
//  carac
//
//  Created by Jordan Chap on 16.10.2026.
//

import Foundation

extension GlobalJTO {
    private static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    init(data: Data) throws {
        self = try Self.decoder.decode(GlobalJTO.self, from: data)
    }

    func encoded() throws -> Data {
        try Self.encoder.encode(self)
    }
}
