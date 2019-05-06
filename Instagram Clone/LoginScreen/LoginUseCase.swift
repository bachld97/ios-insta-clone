import Foundation

class LoginUseCase : UseCase {
    func execute(_ request: Credential,
                 completion: @escaping (LoginResponse) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let lr = LoginResponse(userNotExist: true, wrongPassword: false, userInfo: nil)
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
