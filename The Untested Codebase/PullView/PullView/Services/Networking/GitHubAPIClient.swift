//
//  GitHubAPIClient.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation
import os

protocol GitHubAPIClientProtocol {
    func request<T: Decodable>(_ endpoint: GitHubEndpoint, token: String?) async throws -> T
    func request<T: Decodable, Body: Encodable>(_ endpoint: GitHubEndpoint, body: Body, token: String?) async throws -> T
    func requestNoContent(_ endpoint: GitHubEndpoint, token: String?) async throws
}

final class GitHubAPIClient: GitHubAPIClientProtocol {
    
    private let networkLogger = Logger(subsystem: "com.devswiftable.pullview",
                                       category: "networking")
    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared,
         baseURL: URL = URL(string: "https://api.github.com")!) {
        self.session = session
        self.baseURL = baseURL
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func request<T: Decodable>(_ endpoint: GitHubEndpoint, token: String? = nil) async throws -> T {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            throw GitHubAPIError.invalidURL
        }
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw GitHubAPIError.invalidURL
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = endpoint.method
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        networkLogger.debug("→ \(endpoint.method) \(url.absoluteString) token: \(token != nil ? "present" : "none")")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            networkLogger.error("← No HTTP response for \(url.absoluteString)")
            throw GitHubAPIError.network("No HTTP response")
        }
        
        networkLogger.debug("← \(httpResponse.statusCode) \(url.absoluteString)")
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                networkLogger.error("Decoding failed for \(url.absoluteString): \(error)")
                throw GitHubAPIError.decodingFailed
            }
        case 401:
            networkLogger.error("Unauthorized (401) — \(url.absoluteString)")
            throw GitHubAPIError.unauthorized
        case 403:
            networkLogger.error("Rate limited or scope denied (403) — \(url.absoluteString)")
            throw GitHubAPIError.rateLimited
        case 404:
            networkLogger.error("Not found (404) — \(url.absoluteString)")
            throw GitHubAPIError.notFound
        default:
            let body = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
            networkLogger.error("Unexpected status \(httpResponse.statusCode) — \(url.absoluteString) — body: \(body)")
            throw GitHubAPIError.unknown(statusCode: httpResponse.statusCode)
        }
    }
    
    func request<T: Decodable, Body: Encodable>(_ endpoint: GitHubEndpoint, body: Body, token: String? = nil) async throws -> T {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            throw GitHubAPIError.invalidURL
        }
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw GitHubAPIError.invalidURL
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = endpoint.method
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(body)
        
        let bodyString = String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "<encoding failed>"
        networkLogger.debug("→ \(endpoint.method) \(url.absoluteString) token: \(token != nil ? "present" : "none") body: \(bodyString)")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            networkLogger.error("← No HTTP response for \(url.absoluteString)")
            throw GitHubAPIError.network("No HTTP response")
        }
        
        networkLogger.debug("← \(httpResponse.statusCode) \(url.absoluteString)")
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                networkLogger.error("Decoding failed for \(url.absoluteString): \(error)")
                throw GitHubAPIError.decodingFailed
            }
        case 401:
            networkLogger.error("Unauthorized (401) — \(url.absoluteString)")
            throw GitHubAPIError.unauthorized
        case 403:
            let body = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
            networkLogger.error("Rate limited or scope denied (403) — \(url.absoluteString) — body: \(body)")
            throw GitHubAPIError.rateLimited
        case 404:
            networkLogger.error("Not found (404) — \(url.absoluteString)")
            throw GitHubAPIError.notFound
        default:
            let body = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
            networkLogger.error("Unexpected status \(httpResponse.statusCode) — \(url.absoluteString) — body: \(body)")
            throw GitHubAPIError.unknown(statusCode: httpResponse.statusCode)
        }
    }
    
    func requestNoContent(_ endpoint: GitHubEndpoint, token: String? = nil) async throws {
        guard let url = baseURL.appendingPathComponent(endpoint.path) as URL? else {
            throw GitHubAPIError.invalidURL
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = endpoint.method
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        networkLogger.debug("→ \(endpoint.method) \(url.absoluteString) token: \(token != nil ? "present" : "none")")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            networkLogger.error("← No HTTP response for \(url.absoluteString)")
            throw GitHubAPIError.network("No HTTP response")
        }
        
        networkLogger.debug("← \(httpResponse.statusCode) \(url.absoluteString)")
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw GitHubAPIError.unauthorized
        case 403:
            let body = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
            networkLogger.error("Rate limited or scope denied (403) — \(url.absoluteString) — body: \(body)")
            throw GitHubAPIError.rateLimited
        case 404:
            throw GitHubAPIError.notFound
        default:
            let body = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
            networkLogger.error("Unexpected status \(httpResponse.statusCode) — \(url.absoluteString) — body: \(body)")
            throw GitHubAPIError.unknown(statusCode: httpResponse.statusCode)
        }
    }
}
