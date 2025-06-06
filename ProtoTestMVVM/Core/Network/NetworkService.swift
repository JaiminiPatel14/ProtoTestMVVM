//
//  Untitled.swift
//  ProtoTestMVVM
//
//  Created by Jaimini Shah on 21/05/25.
//

import Foundation

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func request<T: Codable>(model: T.Type, endPoint: EndPointType) async throws -> T
}

// MARK: - Network Service
final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private init() {}
    
    // MARK: - Network Service Protocol Implementation
    func request<T: Codable>(model: T.Type, endPoint: EndPointType) async throws -> T {
        guard let url = endPoint.url else {
            throw NetworkServiceError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        endPoint.headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        if let parameters = endPoint.parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard !data.isEmpty else {
                throw NetworkServiceError.noData
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkServiceError.invalidResponse
            }
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw NetworkServiceError.decodingFailed(error.localizedDescription)
                }
            case 401:
                throw NetworkServiceError.unauthorized
            default:
                throw NetworkServiceError.serverError(httpResponse.statusCode)
            }
        } catch let error as NetworkServiceError {
            throw error
        } catch {
            throw NetworkServiceError.custom(error.localizedDescription)
        }
    }
}
