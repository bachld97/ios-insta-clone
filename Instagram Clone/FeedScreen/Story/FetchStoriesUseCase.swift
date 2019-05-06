class FetchStoriesUseCase: UseCase {
    func execute(_ request: User, completion: @escaping ([Story]) -> Void) {
        let bachld = User(name: "bachld")
        let ldbach = User(name: "ldbach")
        let stories = [
            Story(user: bachld, content: "feed"),
            Story(user: ldbach, content: "create"),
            Story(user: bachld, content: "feed"),
            Story(user: ldbach, content: "create"),
            Story(user: bachld, content: "feed"),
            Story(user: ldbach, content: "create"),
            Story(user: bachld, content: "feed"),
            Story(user: ldbach, content: "create"),
            Story(user: bachld, content: "feed"),
            Story(user: ldbach, content: "create"),
            Story(user: bachld, content: "feed"),
            Story(user: ldbach, content: "create")
        ]
        completion(stories)
    }
    
    typealias Request = User
    typealias Response = [Story]
}
