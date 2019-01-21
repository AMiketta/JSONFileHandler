//
//  JSONFileHandler.swift
//
//  Created by Andreas Miketta on 14.08.18.

import Foundation

public typealias EncodeResult = (data: Data?, error: Error?)

class JSONFileHandler<T:Decodable> {
    var dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

    func load( ressource: String, completion: @escaping ((_ jsonResult: Data) -> Void)) {
        if let path = Bundle.main.path(forResource: ressource, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                completion(data)
            } catch {
                fatalError("fatalError while loading ressource:\(ressource), error: \(error.localizedDescription)")
            }
        }
    }

    public func loadData(ressource: String, completion: @escaping ((_ resonse: T?) -> Void)){
        load(ressource: ressource) { (jsonResult) in
            let object = self.decode(T.self, from: jsonResult)
            if let error =  object.error  {
                fatalError("fatalError while loading ressource:\(ressource), error: \(error.localizedDescription)")
            }
            completion(object.decodableObj)
        }
    }

    func decode<T>(_ type: T.Type, from data: Data) -> (decodableObj: T?, error: Error?) where T : Decodable {
        var returnedDecodable: T? = nil
        var returnedError: Error? = nil

        let decoder = JSONDecoder()

        decoder.dataDecodingStrategy = .base64
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(formatter)

        do {
            returnedDecodable = try decoder.decode(type, from: data)
        } catch {
            returnedError = error
        }

        return (returnedDecodable, returnedError)
    }

    func encode<T>(_ value: T, prettyPrint: Bool = false) -> EncodeResult where T : Encodable {
        var returnedData: Data?
        var returnedError: Error? = nil

        let encoder = JSONEncoder()
        if prettyPrint {
            encoder.outputFormatting = .prettyPrinted
        }
        encoder.dataEncodingStrategy = .base64
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        encoder.dateEncodingStrategy = .formatted(formatter)

        do {
            returnedData = try encoder.encode(value)
        } catch {
            returnedError = error
        }

        return (returnedData, returnedError)
    }
}
