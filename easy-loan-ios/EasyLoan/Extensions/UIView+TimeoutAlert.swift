import UIKit
import RxSwift

extension UIView {

    fileprivate struct TimeoutAlertKeys {
        static var defaultKey = "TimeoutAlertDefaultKey"
    }

    func showTimeoutAlert() {
        if let _ = objc_getAssociatedObject(self, &TimeoutAlertKeys.defaultKey) as? UIImageView {
            return
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        imageView.center = CGPoint(x: self.center.x, y: self.center.y - 64)
        imageView.image = UIImage(named: "timeout")
        objc_setAssociatedObject(self, &TimeoutAlertKeys.defaultKey, imageView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addSubview(imageView)
        let _ =  Observable<Int>.timer(2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (varlue) in
                self.hideTimeoutAlert()
            })
    }

    func hideTimeoutAlert() {
        if let imageView = objc_getAssociatedObject(self, &TimeoutAlertKeys.defaultKey) as? UIImageView {
            imageView.removeFromSuperview()
            objc_setAssociatedObject(self, &TimeoutAlertKeys.defaultKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
