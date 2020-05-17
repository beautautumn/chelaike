import Foundation

struct CarUtils {
    
    static func parseCover(_ images: [[String: AnyObject]]?) -> String? {
        return images?.first(where: { (image) -> Bool in
            return image["isCover"] as? Bool ?? false
        })?["url"] as? String
    }
    
    static func parseName(_ brand: String?, series: String?, style: String?) -> String {
        if (brand?.isEmpty ?? true) && (series?.isEmpty ?? true) && (style?.isEmpty ?? true) {
            return ""
        }

        return [brand ?? "", series ?? "", style ?? ""].joined(separator: "  ")
    }
}
