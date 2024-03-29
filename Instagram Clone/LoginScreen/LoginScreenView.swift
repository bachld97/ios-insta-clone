import UIKit

class LoginScreenView: UIView {
    
    private weak var delegate: LoginScreenViewDelegate?
    
    override var frame: CGRect {
        didSet{
            requestLayout()
        }
    }
    
    var insets: Spacing {
        didSet {
            requestLayout()
        }
    }
    
    private static let scaleFactor = UIScreen.main.scale
    let paddingHorizontal: CGFloat = 8 * scaleFactor
    let spacingLogoToTop: CGFloat = 16 * scaleFactor
    let spacingLogoToTextBox: CGFloat = 12 * scaleFactor
    let spacingBetweenTextBoxes: CGFloat = 4 * scaleFactor
    let spacingForgotToPassword: CGFloat = 4 * scaleFactor
    let spacingForgotToLogin: CGFloat = 8 * scaleFactor
    let spacingSignupToBot: CGFloat = 4 * scaleFactor
    
    private func requestLayout() {
        let childViewWidth = frame.width - 2 * paddingHorizontal - insets.left - insets.right
        let leftSpacing = insets.left + paddingHorizontal
        
        logoBanner.frame = CGRect(
            x: leftSpacing,
            y: spacingLogoToTop + insets.top,
            width: childViewWidth,
            height: 96
        )
        
        usernameTextField.frame = CGRect(
            x: leftSpacing,
            y: logoBanner.frame.maxY + spacingLogoToTextBox,
            width: childViewWidth,
            height: 48
        )
        
        passwordTextField.frame = CGRect(
            x: leftSpacing,
            y: usernameTextField.frame.maxY + spacingBetweenTextBoxes,
            width: childViewWidth,
            height: 48
        )
        
        let forgotPasswordWidth: CGFloat = 120
        forgotPasswordButton.frame = CGRect(
            x: frame.maxX - insets.right - forgotPasswordWidth - paddingHorizontal,
            y: passwordTextField.frame.maxY + spacingForgotToPassword,
            width: forgotPasswordWidth,
            height: 16
        )
        
        loginButton.frame = CGRect(
            x: leftSpacing,
            y: forgotPasswordButton.frame.maxY + spacingForgotToLogin,
            width: childViewWidth,
            height: 48
        )
        
        
        let suLabelWidth: CGFloat = signupLabel.text?.widthForFont(signupLabel.font) ?? 0
        let suButtonWidth: CGFloat
        if let suButtonLabel = signupButton.titleLabel {
            suButtonWidth = suButtonLabel.text?.widthForFont(suButtonLabel.font) ?? 0
        } else {
            suButtonWidth = 0
        }
        
        let suWidth = suButtonWidth + suLabelWidth + 4
        signupStack.frame = CGRect(
            x: (frame.width - suWidth) / 2,
            y: frame.maxY - spacingSignupToBot - 24 - insets.bottom,
            width: suWidth,
            height: 28
        )
    }
    
    @objc private func signupOnClick() {
        delegate?.navigateToSignup()
        hideKeys()
    }
    
    @objc private func loginOnClick() {
        loginButton.showLoading()
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        delegate?.performLogin(withUsername: username, andPassword: password)
        hideKeys()
    }
    
    private lazy var logoBanner: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.from(r: 230, g: 230, b: 230)
        textField.placeholder = "Phone number, username or email".localized
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .black
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = UIReturnKeyType.next
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.from(r: 230, g: 230, b: 230)
        textField.placeholder = "Password"
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .black
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(UIColor.from(r: 70, g: 110, b: 175), for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        
        let title = button.titleLabel
        title?.textAlignment = .right
        title?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    private lazy var signupLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?".localized
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up.".localized, for: .normal)
        button.setTitleColor(UIColor.from(r: 70, g: 110, b: 175), for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(signupOnClick), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    private lazy var loginButton: LoginButton = {
        let bgColor = UIColor.from(r: 70, g: 110, b: 175)
        let button = LoginButton(
            disabledColor: bgColor.withAlphaComponent(0.65),
            highlightColor: bgColor.withAlphaComponent(0.75),
            backgroundColor: bgColor)
        button.addTarget(self, action: #selector(loginOnClick), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var signupStack: UIStackView = {
        let subviews = [signupLabel, signupButton]
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .horizontal
        return stackView
    }()

    init(delegate: LoginScreenViewDelegate, _ insets: Spacing) {
        self.insets = insets
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = .white
        addSubview(logoBanner)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(forgotPasswordButton)
        addSubview(loginButton)
        addSubview(signupStack)
        let tapHideKey = UITapGestureRecognizer(target: self, action: #selector(hideKeys))
        self.addGestureRecognizer(tapHideKey)
    }
    
    @objc private func hideKeys() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopLoadingIndicator() {
        self.loginButton.showwNotLoading()
    }
}

extension LoginScreenView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let otherTextField: UITextField
        if textField == usernameTextField {
            otherTextField = passwordTextField
        } else {
            otherTextField = usernameTextField
        }
        let curString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        loginButton.isEnabled =
            !(otherTextField.text ?? "").isEmpty && !curString.isEmpty
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == usernameTextField) {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
