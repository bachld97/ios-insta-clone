class Injection {
    static func getLoginRepository() -> LoginRepository {
        return LoginRepositoryImpl()
    }
}
