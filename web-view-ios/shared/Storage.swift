import Foundation

class StorageManager {

    private let userDefaults: UserDefaults
    private let customPrefix = "elum_webview_storage_"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // Устанавливает строку для ключа локально (на устройстве)
    func set(forKey key: String, value: String) {
        let actualKey = customPrefix + key
        userDefaults.set(value, forKey: actualKey)
    }

    // Получает строку для ключа локально (на устройстве)
    func get(forKey key: String) -> String? {
        let actualKey = customPrefix + key
        return userDefaults.string(forKey: actualKey)
    }

    // Удаляет строку для ключа локально
    func delete(forKey key: String) {
        let actualKey = customPrefix + key
        userDefaults.removeObject(forKey: actualKey)
    }

    // Возвращает список всех пользовательских ключей
    func keys() -> [String] {
        let allKeys = userDefaults.dictionaryRepresentation().keys
        return allKeys
            .filter { $0.hasPrefix(customPrefix) }
            .map { $0.replacingOccurrences(of: customPrefix, with: "") }
    }
}
