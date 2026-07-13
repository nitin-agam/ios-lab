//
//  KeychainStore.swift
//  PullView
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

protocol KeychainStoreProtocol {
    func saveToken(_ token: String) throws
    func readToken() throws -> String?
    func deleteToken() throws
}

enum KeychainError: Error, Equatable {
    case unexpectedStatus(OSStatus)
    case encodingFailed
    case decodingFailed
}

final class KeychainStore: KeychainStoreProtocol {
    
    private let service: String
    private let account = "pat"
    
    init(service: String = "com.devswiftable.pullview") {
        self.service = service
    }
    
    func saveToken(_ token: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
        
        var attributes = query
        attributes[kSecValueData as String] = data
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func readToken() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess:
            guard let data = result as? Data, let token = String(data: data, encoding: .utf8) else {
                throw KeychainError.decodingFailed
            }
            return token
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func deleteToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
