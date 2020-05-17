import UIKit
import SpriteKit

class MapView: UIView {

    var isInLocation: Bool {
        return !self.toastLabel.isHidden
    }

    var address: String?

    var coordinate: CLLocationCoordinate2D? {
        didSet {
            setErrorViewShowStatus()
        }
    }

    var shopCoordinate: CLLocationCoordinate2D? {
        didSet {
            setErrorViewShowStatus()
        }
    }

    var onLocationFinished: (() -> Void)?

    fileprivate let toastLabel = UILabel()
    fileprivate let errorView = UIView()
    fileprivate let errorImageView = UIImageView()
    fileprivate let errorLabel = UILabel()

    fileprivate let mapView = MAMapView()
    fileprivate let locationManager = AMapLocationManager()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    override func updateConstraints() {
        super.updateConstraints()
        self.errorView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(223)
            make.top.equalTo(self).offset(15)
            make.height.equalTo(26)
        }
        self.errorImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.errorView).offset(7)
            make.centerY.equalTo(self.errorView)
            make.size.equalTo(14)
        }
        self.errorLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.errorImageView.snp.right).offset(2)
            make.right.top.bottom.equalTo(self.errorView)
        }

        self.toastLabel.snp.remakeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(36)
            make.width.equalTo(100)
        }
        self.mapView.snp.remakeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
    }

    func startLocation() {
        self.toastLabel.isHidden = false
        self.locationManager.requestLocation(withReGeocode: true) { [weak self] (location, regeocode, _) in
            if let weakSelf = self {
                if let location = location {
                    weakSelf.toastLabel.isHidden = true
                    weakSelf.coordinate = location.coordinate
                    let pointAnnotation = MAPointAnnotation()
                    pointAnnotation.coordinate = location.coordinate
                    weakSelf.mapView.removeAnnotations(weakSelf.mapView.annotations)
                    weakSelf.mapView.addAnnotation(pointAnnotation)
                    weakSelf.mapView.setZoomLevel(15, animated: false)
                    weakSelf.mapView.setCenter(location.coordinate, animated: true)
                }
                if let regeocode = regeocode {
                    weakSelf.address = regeocode.formattedAddress
                }
                if let callback = weakSelf.onLocationFinished {
                    callback()
                }
            }
        }
    }

    fileprivate func initViews() {
        self.addSubview(self.mapView)

        self.errorView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.errorView.layer.cornerRadius = 14
        self.errorView.clipsToBounds = true
        self.errorView.isHidden = true
        self.addSubview(self.errorView)
        self.errorImageView.image = UIImage(named: "error")
        self.errorView.addSubview(self.errorImageView)
        self.errorLabel.text = "当前地址与车商门店地址不匹配，请核查！"
        self.errorLabel.textColor = UIColor(red:0.80, green:0.07, blue:0.17, alpha:1.00)
        self.errorLabel.font = UIFont.systemFont(ofSize: 10)
        self.errorView.addSubview(self.errorLabel)

        self.toastLabel.text = "定位中..."
        self.toastLabel.textColor = UIColor.white
        self.toastLabel.textAlignment = .center
        self.toastLabel.layer.cornerRadius = 8
        self.toastLabel.clipsToBounds = true
        self.toastLabel.isHidden = true
        self.toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.toastLabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(self.toastLabel)
    }

    fileprivate func setErrorViewShowStatus() {
        if let currentLocation = self.coordinate {
            let shopLocation = self.shopCoordinate ?? currentLocation
            let distance = MAMetersBetweenMapPoints(
                MAMapPointForCoordinate(currentLocation),
                MAMapPointForCoordinate(shopLocation)
            )
            self.errorView.isHidden = abs(distance) <= 500
        }
    }
}
