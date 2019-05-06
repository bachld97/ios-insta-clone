struct LoginResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case userNotExist = "userNotFound"
        case wrongPassword = "wrongPassword"
        case userInfo = "user"
    }
    
    var result: Result<User, LoginUseCase.Error> {
        if userNotExist {
            return .failure(.userNotExist)
        }
        
        if wrongPassword {
            return .failure(.badCredential)
        }
        
        guard let ui = userInfo else {
            return .failure(.unknown)
        }
        
        return .success(ui.clientData)
    }
    
    let userNotExist: Bool
    let wrongPassword: Bool
    let userInfo: UserResponse?
    
    
    struct UserResponse: Decodable {
        let name: String
        
        var clientData: User {
            return User(name: name)
        }
    }
}
