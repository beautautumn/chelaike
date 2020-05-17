import RxSwift
import RealmSwift

class EnumerizeModel : Object {

    @objc dynamic var version = ""
    var loanBillStates = List<RealmMap>()
    var replaceCarsBillStates = List<RealmMap>()

    override static func primaryKey() -> String? {
        return "version"
    }

    class func setup() {
        if enumerize() == nil {
            let _ = EnumerizeApi.enumerize()
                .subscribeOn(ConcurrentMainScheduler.instance)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (response, json) in
                    if let data = (json as? [String: Any])?["data"] as? [String: Any] {
                        let enumerize = EnumerizeModel()
                        enumerize.version = ConfigUtils.version()
                        if let loanBillStates = (data["loanBill"] as? [String: Any])?["state"] as? [String: String] {
                            loanBillStates.forEach({ (key, value) in
                                enumerize.loanBillStates.append(RealmMap(value: ["key": key, "value": value]))
                            })
                        }
                        if let replaceCarsBillStates = (data["replaceCarsBill"] as? [String: Any])?["state"] as? [String: String] {
                            replaceCarsBillStates.forEach({ (key, value) in
                                enumerize.replaceCarsBillStates.append(RealmMap(value: ["key": key, "value": value]))
                            })
                        }
                        let realm = try! Realm()
                        try! realm.write {
                            realm.delete(realm.objects(EnumerizeModel.self))
                            realm.add(enumerize)
                        }
                    }
                })
        }
    }

    class func enumerize() -> EnumerizeModel? {
        let realm = try! Realm()
        return realm.object(ofType: EnumerizeModel.self, forPrimaryKey: ConfigUtils.version())
    }
}
