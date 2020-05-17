import Foundation

struct ImageUtils {

    static func scalePath(_ path: String, width: Int, height: Int) -> String {
        if path.hasPrefix("http://") || path.hasPrefix("https://") {
            return "\(path)?x-oss-process=image/resize,m_fixed,w_\(width),h_\(height),limit_0"
        }
        return path
    }
}
