import UIKit

struct Utils {

    static func redirectToLogin(_ controller: UIViewController, messages: [String]? = nil) {
        UserModel.logout()
        let loginController = LoginViewController()
        loginController.messages = messages
        controller.present(loginController, animated: true, completion: nil)
    }

    static func parseStringToInt(_ value: String?) -> Int {
        if value == nil {
            return -1
        }
        return Int(value!) ?? -1
    }
}
