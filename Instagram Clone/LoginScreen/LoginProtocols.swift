protocol LoginScreenViewDelegate: class {
    func performLogin(withUsername username: String, andPassword password: String)
    func navigateToSignup()
    func navigateToForgetPassword()
}
