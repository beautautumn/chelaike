import UIKit
import RxSwift
import Alamofire

class LoanOriginalDetailViewController: BaseDetailViewController, BaseDetailViewControllerDelegate {

    var recordId: Int?
    fileprivate var cars: [[String: AnyObject]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "借款详情"
        self.delegate = self
    }
    
    func reloadData(_ data: [String : AnyObject]) {
        for arrangedSubview in self.contentView.arrangedSubviews {
            self.contentView.removeArrangedSubview(arrangedSubview)
        }
        self.cars = (data["originalCars"] as? [[String: AnyObject]]) ?? []
        for (index, car) in self.cars.enumerated() {
            let carItemView = CarItemView()
            carItemView.tag = index
            carItemView.cover = CarUtils.parseCover(car["images"] as? [[String: AnyObject]])
            carItemView.name = CarUtils.parseName(car["brandName"] as? String,
                                                  series: car["seriesName"] as? String,
                                                  style: car["styleName"] as? String)
            carItemView.vin = car["vin"] as? String
            if let showPrice = car["showPriceWan"] as? Double {
                carItemView.showPrice = "\(showPrice)"
            }
            if let estimatePrice = car["estimatePriceWan"] as? Double {
                carItemView.estimatePrice = "\(estimatePrice)"
            }
            self.contentView.addArrangedSubview(carItemView)
            carItemView.snp.makeConstraints { (make) in
                make.height.equalTo(68)
            }
            carItemView.isUserInteractionEnabled = true
            carItemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCarItemViewClicked(_:))))
        }
    }
    
    func query() -> Observable<(HTTPURLResponse, Any)>? {
        if let id = self.recordId {
            return LoanApi.loadDetail(id)
        }
        return nil
    }

    @objc func onCarItemViewClicked(_ recognizer: UITapGestureRecognizer) {
        if let tag = recognizer.view?.tag {
            if let weshopUrl = self.cars[tag]["weshopUrl"] as? String {
                let controller = BrowerViewController()
                controller.pageTitle = "微店预览"
                controller.pageUrl = weshopUrl
                self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            }
        }
    }
}
