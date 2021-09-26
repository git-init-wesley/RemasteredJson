//
//  Conçu avec ♡ par Levasseur Wesley.
//  © Copyright 2021. Tous droits réservés.
//
//  Création datant du 27/05/2021.
//

import Foundation

public enum RemasteredJsonException: Error, LocalizedError {
    case UrlParse, DataDecode, DataEncode, JsonDecode, JsonEncode, unexpected(code: Int)

    public func isFatal() -> Bool {
        if case RemasteredJsonException.unexpected = self {
            return true
        } else {
            return false
        }
    }

    public var errorDescription: String? {
        switch self {
        case .UrlParse:
            return "Url cannot be parsed."
        case .DataEncode:
            return "Data cannot be encoded."
        case .DataDecode:
            return "Data cannot be decoded."
        case .JsonEncode:
            return "It's not possible to encode from the data."
        case .JsonDecode:
            return "It's not possible to decode from the data."
        default:
            return .none
        }
    }
}

public class RemasteredJson<T> {

    public init() {
    }

    public func decode(localUrl: URL?) throws -> T where T: Decodable {
        let data: Data
        do {
            try data = Data(contentsOf: try self.validateUrl(localUrl))
        } catch {
            throw RemasteredJsonException.DataDecode
        }
        return try self.decode(data)
    }

    public func decode(externalUrl: String, completion: @escaping (Result<T, Error>) -> ()) throws where T: Decodable {
        try self.decode(externalUrl: URL(string: externalUrl), completion: completion)
    }

    public func decode(externalUrl: URL?, completion: @escaping (Result<T, Error>) -> ()) throws where T: Decodable {
        URLSession.shared.dataTask(with: try self.validateUrl(externalUrl)) { (_data: Data?, _response: URLResponse?, _error: Error?) in
            if let error: Error = _error {
                completion(.failure(error))
                return
            }
            if let data: Data = _data {
                do {
                    completion(.success(try self.decode(data)))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    public func decode(_ data: Data) throws -> T where T: Decodable {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw RemasteredJsonException.JsonDecode
        }
    }

    private func validateUrl(_ url: URL?) throws -> URL {
        if url == nil {
            throw RemasteredJsonException.UrlParse
        } else {
            return url!
        }
    }

    public func encode(_ encodable: T, completion: @escaping (Result<Data, Error>) -> ()) throws where T: Encodable {
        do {
            completion(.success(try JSONEncoder().encode(encodable)))
        } catch {
            completion(.failure(RemasteredJsonException.JsonEncode))
        }
    }

}
