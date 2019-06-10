import Foundation

class LoginUseCase: UseCase {
    typealias Request = (username: String, password: String)
    typealias Response = Result<LoginResponse, Error>
    
    private let loginRepository: LoginRepository
    
    init(loginRepository: LoginRepository = Injection.getLoginRepository()) {
        self.loginRepository = loginRepository
    }
    
    
    func execute(
        _ request: (username: String, password: String),
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    ) {
        let handleApiResult: (Result<LoginApiResponse, Error>) -> Void = { result in
            switch result {
            case .success(let apiResponse):
                let response = apiResponse.toLoginResponse()
                if apiResponse.isSuccess {
                    Endpoint.registerToken(tokenInfo: apiResponse.token)
                }
                completion(.success(response))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
        
        self.loginRepository.login(
            username: request.username,
            password: request.password,
            completion: handleApiResult)
    }
}

class Injection {
    static func getLoginRepository() -> LoginRepository {
        return LoginRepositoryImpl()
    }
}

class Endpoint {
    static let host = "127.0.0.1"
    static let port = 8000
    static var tokenInfo: TokenInfo?
    
    static func registerToken(tokenInfo: TokenInfo?) {
        assert(self.tokenInfo == nil || tokenInfo == nil)
        self.tokenInfo = tokenInfo
    }
    
    static func loginRequest(username: String, password: String) -> WebService.Request {
        let params = [ "username" : username, "password": password ]
        let request = WebService.Request(
            host: host, path: "/auth/login/",
            params: params,
            port: port, httpMethod: .post
        )
        return request
    }
}

protocol LoginRepository {
    func login(username: String, password: String,
               completion: @escaping (Result<LoginApiResponse, Error>) -> Void)
}

class LoginRepositoryImpl: LoginRepository {
    
    private let webService: WebService
    
    init(webService: WebService = .init()) {
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
