import Foundation

class LoginUseCase : UseCase {
    func execute(_ request: Credential,
                 completion: @escaping (LoginResponse) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let ur = LoginResponse.UserResponse(name: "noti")
            let lr = LoginResponse(
                userNotExist: false, wrongPassword: false, userInfo: ur
            )
            completion(lr)
        }
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
