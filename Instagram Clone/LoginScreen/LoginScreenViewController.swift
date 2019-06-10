import UIKit

class LoginScreenViewControler: BaseViewController {
    private lazy var loginScreenView = LoginScreenView(delegate: self, insets)
    private let loginUseCase: LoginUseCase
    
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
        loginScreenView.insets = insets
    }
    
    func navigateToHomeScreen(_ user: User) {
        let home = HomeNavigationViewController(user: user)
        self.dismiss(animated: false, completion: nil)
        self.present(home, animated: true)
    }
    
    func handleNetworkError(_ error: Error) {
        let title = "Cannot connect to server"
        let message = "Please make sure you are connected to the internet and try again."
        let cancelTitle = "Try again"
        loginScreenView.stopLoadingIndicator()
        showSimpleAlert(title: title, message: message, cancelTitle: cancelTitle)
    }
    
    func handleLoginResponse(_ response: LoginResponse) {
        var title: String? = nil
        var message: String? = nil
        let cancelTitle: String = "Try again"
        
        switch response {
        case .success(let userInfo):
            self.navigateToHomeScreen(userInfo.toUser())
        case .wrongPassword:
            title = "Incorrect password"
            message =  "The password you entered is incorrect. Please try again."
        case .userNotFound:
            title = "Incorrect username"
            message = "The username you entered doesn't appear to belong to an account. Please check your username and try again."
        case .unknownError:
            title = "Unexpected error occured"
            message = "The server cannot response to your request at the moment. Please try again later."
        }
        
        if let title = title, let message = message {
            loginScreenView.stopLoadingIndicator()
            showSimpleAlert(title: title, message: message, cancelTitle: cancelTitle)
        }
    }
}

extension LoginScreenViewControler: LoginScreenViewDelegate {
    func performLogin(withUsername username: String, andPassword password: String) {
        loginUseCase.execute((username, password), completion: { result in
            switch result {
            case .success(let apiResponse):
                self.handleLoginResponse(apiResponse)
            case .failure(let error):
                self.handleNetworkError(error)
            }
        })
    }
    
    func navigateToForgetPassword() {
        // Later
    }
    
    
    func navigateToSignup() {
        // Later
    }
}
