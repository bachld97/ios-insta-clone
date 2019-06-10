struct TokenInfo: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

struct UserInfo: Decodable {
    let name: String
    
    func toUser() -> User {
        return User(name: name)
    }
}

enum LoginResponse {
    case success(UserInfo)
    case wrongPassword
    case userNotFound
    case unknownError}

enum LoginFailure {
}

struct LoginApiResponse: Decodable {
    private let userNotFound: Bool
    private let wrongPassword: Bool
    private let tokenInfo: TokenInfo?
    private let userInfo: UserInfo?
    
    var isSuccess: Bool {
        return userInfo != nil && tokenInfo != nil
    }
    
    var token: TokenInfo {
        return self.tokenInfo!
    }
    
    func toLoginResponse() -> LoginResponse {
        if userNotFound {
            return .userNotFound
        } else if wrongPassword {
            return .wrongPassword
        } else if isSuccess {
            return .success(userInfo!)
        } else {
            return .unknownError
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case userNotFound = "user_not_found"
        case wrongPassword = "wrong_password"
        case tokenInfo = "token_info"
        case userInfo = "user_info"
    }
}
