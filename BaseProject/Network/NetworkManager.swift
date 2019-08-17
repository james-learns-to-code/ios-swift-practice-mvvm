//
//  NetworkManager.swift
//  BaseProject
//
//  Created by dongseok lee on 15/06/2019.
//  Copyright © 2019 Good Effect. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case url
    case response(error: Error?)
    case data
    case jsonDecoding(error: Error?)
    
    var localizedDescription: String {
        switch self {
        case .response(let error):
            return error?.localizedDescription ?? self.localizedDescription
        case .jsonDecoding(let error):
            return error?.localizedDescription ?? self.localizedDescription
        default:
            return self.localizedDescription
        }
    }
}

class NetworkManager {
    
    // MARK: Request
    
    enum RequestType: String {
        case post = "POST"
        case get = "GET"
        
        var httpMethod: String {
            return rawValue
        }
    }
    
    static let header: [String: String] = [
        "Content-Type": "application/json"
    ]
    
    typealias DataResult = Result<Data, NetworkError>
    typealias DataResultHandler = (DataResult) -> Void
    
    @discardableResult
    func request(
        with url: URL,
        type: RequestType,
        handler: @escaping DataResultHandler) -> URLSessionDataTask {
        
        var req = URLRequest(url: url)
        req.httpMethod = type.httpMethod
        req.allHTTPHeaderFields = NetworkManager.header
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        return request(with: session, req, handler)
    }
    
    private func request(
        with session: URLSession,
        _ request: URLRequest,
        _ handler: @escaping DataResultHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) {
            (responseData, response, responseError) in
            
            guard responseError == nil else {
                handler(.failure(.response(error: responseError)))
                return
            }
            guard let data = responseData else {
                handler(.failure(.data))
                return
            }
            handler(.success(data))
        }
        task.resume()
        return task
    }
    
    // MARK: Decoder
    struct Decoder<Type: Decodable> {
        static func decodeResult(
            _ result: DataResult,
            handler: @escaping (Result<Type, NetworkError>) -> Void) {
            
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(Type.self, from: data)
                    handler(.success(value))
                } catch {
                    handler(.failure(.jsonDecoding(error: error)))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

// MARK: Interface
extension NetworkManager {
    func request(
        with urlString: String,
        type: RequestType,
        handler: @escaping DataResultHandler) {
        guard let url = URL(string: urlString) else {
            handler(.failure(.url))
            return
        }
        request(with: url, type: type, handler: handler)
    }
}
