import UIKit

class LoginScreenViewControler: BaseViewController {
    private lazy var loginScreenView = LoginScreenView(delegate: self, insets)
    private let loginUseCase: LoginUseCase
    private var insets = Spacing()
    
    init(_ loginUseCase: LoginUseCase = .init()) {
        self.loginUseCase = loginUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func navigateToHomeScreen(_ user: User) {
        print(user)
    }
    
    func handleLoginError(_ error: LoginUseCase.Error) {
        let title: String
        let message: String
        let cancelTitle = "Try again"
        switch error {
        case .badCredential:
            title = "Incorrect password"
            message = "The password you entered is incorrect. Please try again."
        case .userNotExist:
            title = "Incorrect username"
            message = "The username you entered doesn't appear to belong to an account. Please check your username and try again."
        case .unknown:
            title = "Unexpected error occurred"
            message = "There are some problems when connecting to server. Please try again or come back another time."
        }
        
        loginScreenView.stopLoadingIndicator()
        showSimpleAlert(title: title, message: message, cancelTitle: cancelTitle)
    }
}

extension LoginScreenViewControler: LoginScreenViewDelegate {
    func performLogin(withUsername username: String, andPassword password: String) {
        let credential = LoginUseCase.Credential(username, password)
        loginUseCase.execute(credential) { [unowned self] response in
            switch response.result {
            case .success(let user):
                self.navigateToHomeScreen(user)
            case .failure(let error):
                self.handleLoginError(error)
            }
        }
    }
    
    func navigateToForgetPassword() {
        
    }
    
    
    func navigateToSignup() {
        
    }
}
