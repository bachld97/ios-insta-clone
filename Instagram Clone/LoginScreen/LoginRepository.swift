protocol LoginRepository {
    func login(username: String, password: String,
               completion: @escaping (Result<LoginApiResponse, Error>) -> Void)
}

class LoginRepositoryImpl: LoginRepository {
    
    private let webService: WebService
    
    init(webService: WebService = Injection.getWebService()) {
        self.webService = webService
    }
    
    func login(
        username: String, password: String,
        completion: @escaping (Result<LoginApiResponse, Error>) -> Void
    ) {
        let request = Endpoint.loginRequest(username: username, password: password)
        webService.execute(request: request, completion: completion)
    }
}
