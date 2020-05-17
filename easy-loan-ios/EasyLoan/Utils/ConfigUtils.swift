import Foundation

struct ConfigUtils {
    
    static func apiRootUrl() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "ApiRootUrl") as! String
    }

    static func version() -> String {
        if let version =  Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return version
        }
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }

    static func deviceId() -> String {
        let key = "EASYLOANUUID"
        let defaults = UserDefaults.standard
        if let deviceId = defaults.string(forKey: key) {
            return deviceId
        }
        let deviceId = UUID().uuidString
        defaults.set(deviceId, forKey: key)
        defaults.synchronize()
        return deviceId
    }
    
    static func jpushKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "JPushKey") as! String
    }
    
    static func pgyerAppKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "PgyerAppKey") as! String
    }

    static func mapAppKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "MapAppKey") as! String
    }
}
