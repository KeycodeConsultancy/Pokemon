//
//  Webservice.swift
//  
//
//  Created by Kevin Reid on 15/10/2022.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case badUrl
    case decodingError
}

enum HttpMethod {
    case get([URLQueryItem])
    case post(Data?)
    
    var name: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL
    var method: HttpMethod = .get([])
}

final class Webservice {
    
    func load<T: Codable>(_ resource: Resource<T>, offset: Int = 0, limit: Int = 20) async throws -> T {
        
        var request = URLRequest(url: resource.url)
        
        switch resource.method {
            case .post(let data):
                request.httpMethod = resource.method.name
                request.httpBody = data
            case .get(let queryItems):
                var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
                components?.queryItems = queryItems
                components?.queryItems = [URLQueryItem(name: "offset", value: String(offset)),
                                            URLQueryItem(name: "limit", value: String(limit))]
            
            guard let url = components?.url else {
                    throw NetworkError.badUrl
                }
                request = URLRequest(url: url)
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        let session = URLSession(configuration: configuration)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw NetworkError.invalidResponse
        }
       
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return result
    }
}
