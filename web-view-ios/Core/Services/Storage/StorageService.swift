//
//  StorageService.swift
//  webview-app
//
//  Created by Артур Гетьман on 09.05.2025.
//

import Foundation

final class StorageService: ObservableObject {

    // UserDefaults instance used for storing and retrieving data.
    private let userDefaults: UserDefaults
    
    // A custom prefix for all keys to scope them to this application or feature.
    private let customPrefix = "elum_webview_storage_"

    // Initializes a new instance of `StorageManager` with a specified UserDefaults instance.
    // - Parameter userDefaults: The instance of UserDefaults to be used, defaulting to `.standard`.
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // Stores a string value for a given key in UserDefaults.
    // - Parameters:
    //   - key: The key for which the string value will be stored.
    //   - value: The string value to be stored.
    func set(forKey key: String, value: String) {
        // Prepend the custom prefix to the key for namespace isolation.
        let actualKey = customPrefix + key
        
        // Store the value in UserDefaults with the prefixed key.
        userDefaults.set(value, forKey: actualKey)
    }

    // Retrieves a string value for a given key from UserDefaults.
    // - Parameter key: The key for which the string value will be retrieved.
    // - Returns: The string value associated with the key, or nil if not found.
    func get(forKey key: String) -> String? {
        // Prepend the custom prefix to the key for identifying stored data.
        let actualKey = customPrefix + key
        
        // Retrieve and return the value from UserDefaults.
        return userDefaults.string(forKey: actualKey)
    }

    // Deletes a stored value for a given key from UserDefaults.
    // - Parameter key: The key for which the stored value will be deleted.
    func delete(forKey key: String) {
        // Prepend the custom prefix to the key.
        let actualKey = customPrefix + key
        
        // Remove the value from UserDefaults.
        userDefaults.removeObject(forKey: actualKey)
    }

    // Provides a list of all custom keys set by this manager in UserDefaults.
    // - Returns: An array of keys without the custom prefix.
    func keys() -> [String] {
        // Get all keys currently stored in UserDefaults.
        let allKeys = userDefaults.dictionaryRepresentation().keys
        
        // Filter keys to only those with the custom prefix and remove the prefix before returning.
        return allKeys
            .filter { $0.hasPrefix(customPrefix) }
            .map { $0.replacingOccurrences(of: customPrefix, with: "") }
    }
}
