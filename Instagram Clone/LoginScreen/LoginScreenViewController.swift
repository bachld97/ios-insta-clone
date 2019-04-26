import UIKit

class LoginScreenViewControler: UIViewController {
    private lazy var loginScreenView = LoginScreenView(delegate: self, insets)
    private var insets = Spacing()
    
    override func loadView() {
        view = loginScreenView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            self.insets = Spacing(
                top: view.safeAreaInsets.top,
                bottom: view.safeAreaInsets.bottom,
                left: view.safeAreaInsets.left,
                right: view.safeAreaInsets.right
            )
        } else {
            // Notch devices has minimum version of iOS 11
        }
        
        loginScreenView.insets = insets
    }
}

extension LoginScreenViewControler: LoginScreenViewDelegate {
    func performLogin(withUsername username: String, andPassword password: String) {
        
    }
    
    func navigateToSignup() {
        
    }
}
