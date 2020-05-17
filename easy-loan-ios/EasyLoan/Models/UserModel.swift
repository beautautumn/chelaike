import RealmSwift

class UserModel: Object {

    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var token = ""
    var authorities = List<RealmString>()

    class func login(_ data: [String: AnyObject]) {
        let user = UserModel()
        user.id = (data["id"] as? Int) ?? 0
        user.name = (data["name"] as? String) ?? ""
        user.token = (data["token"] as? String) ?? ""
        if let authorities = data["authorities"] as? [String] {
            authorities.forEach({ (authority) in
                user.authorities.append(RealmString(value: ["value": authority]))
            })
        }
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(UserModel.self))
            realm.add(user)
        }
        EnumerizeModel.setup()
    }

    class func logout() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(UserModel.self))
        }
    }

    class func currentUser() -> UserModel? {
        let realm = try! Realm()
        return realm.objects(UserModel.self).last
    }

    class func isAuthValid(_ auth: String) -> Bool {
        if let user = self.currentUser() {
            return user.authorities.contains { (authority) -> Bool in
                return authority.value == auth
            }
        }
        return false
    }

    class func isAnyAuthValid(_ auths: [String]) -> Bool {
        for auth in auths {
            if self.isAuthValid(auth) {
                return true
            }
        }
        return false
    }
}
