import Foundation

class FetchStoriesUseCase: UseCase {
    func execute(_ request: User, completion: @escaping ([Story]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let stories = self.stories()
            completion(stories)
        }
    }
    
    private func stories() -> [Story] {
        let bachld = User(name: "yhgpq")
        let ldbach = User(name: "ldbach")
        return [
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
    }
    
    typealias Request = User
    typealias Response = [Story]
}
