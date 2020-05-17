import UIKit

class SingleSelectedView : UIView {

    fileprivate let borderTopLayer = CALayer()
    fileprivate let borderBottomLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let size = self.bounds.size
        self.borderTopLayer.removeFromSuperlayer()
        self.borderBottomLayer.removeFromSuperlayer()
        self.borderTopLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: 0.5)
        self.borderBottomLayer.frame = CGRect(x: 0, y: size.height - 0.5, width: size.width, height: 0.5)
        self.layer.addSublayer(self.borderTopLayer)
        self.layer.addSublayer(self.borderBottomLayer)
        let image = UIImage(named: "check")
        image?.draw(in: CGRect(x: size.width - 40, y: (bounds.height - 14) / 2, width: 22, height: 14))
    }

    fileprivate func initViews() {
        self.backgroundColor = UIColor.white
        self.borderTopLayer.backgroundColor = ColorUtils.separatorColor.cgColor
        self.borderBottomLayer.backgroundColor = ColorUtils.separatorColor.cgColor
    }
}
