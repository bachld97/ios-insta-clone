class Injection {
    static func getLoginRepository() -> LoginRepository {
        return LoginRepositoryImpl()
    }
    
    static func getPostRepository() -> PostRepository {
        return PostRepositoryImpl()
    }
}
