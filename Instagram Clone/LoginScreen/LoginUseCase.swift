class LoginUseCase : UseCase {    
    func execute(_ request: Credential,
                 completion: @escaping (LoginResponse) -> Void)
    {
        
    }
    
    typealias Credential = (username: String, password: String)
    typealias Request = Credential
    typealias Response = LoginResponse
    
    enum Error: Swift.Error {
        case unknown
        case badCredential
        case userNotExist
    }
}
