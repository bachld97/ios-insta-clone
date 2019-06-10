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
                return completion(.success(response))
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

