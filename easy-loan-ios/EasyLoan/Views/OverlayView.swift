import UIKit

class OverlayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    func initViews() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
    }
    
    @objc func onClicked() {
        self.removeFromSuperview()
    }
}
