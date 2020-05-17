import UIKit
import RxSwift
import Alamofire

struct ImageClient {

    static func upload(_ filePath: String) -> Observable<String?> {
        return ConfigApi.ossConfiguration().flatMap { (args) -> Observable<String?> in
            let (response, json) = args
            return Observable.create { observer in
                if response.statusCode == 200 {
                    if let ossConfiguration = (json as? [String: Any])?["data"] as? [String: String] {
                        let fileName = "images/\(UUID().uuidString).jpg"
                        let task = AROssClient.task(filePath, fileName: fileName, ossConfiguration: ossConfiguration, completionHandler: { (_, _, error) in
                            if error != nil {
                                observer.onNext(nil)
                            } else {
                                observer.onNext("\(ossConfiguration["url"]!)/\(fileName)")
                            }
                        })
                        task?.resume()
                    } else {
                        observer.onNext(nil)
                    }
                } else {
                    observer.onNext(nil)
                }
                return Disposables.create()
            }
        }
    }
}
