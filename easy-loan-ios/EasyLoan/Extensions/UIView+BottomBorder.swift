import UIKit
import SnapKit

extension UIView {

    func setBottomBorder() {
        let borderView = UIView()
        borderView.backgroundColor = ColorUtils.separatorColor
        borderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(borderView)
        borderView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(1)
        }
    }
}
