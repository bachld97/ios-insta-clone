struct LoginResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case userInfo = "user"
    }
    
    var result: Result<User, LoginUseCase.Error> {
        guard success else {
            return .failure(.badCredential)
        }
        
        guard let ui = userInfo else {
            return .failure(.unknown)
        }
        
        return .success(ui.clientData)
    }
    
    let success: Bool
    let userInfo: UserResponse?
    struct UserResponse: Decodable {
        let name: String
        
        var clientData: User {
            return User(name: name)
        }
    }
}
