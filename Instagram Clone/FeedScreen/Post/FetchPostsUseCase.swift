import Foundation

class FetchPostsUseCase: UseCase {
    typealias Request = User
    typealias Response = [Post]
    
    func execute(_ request: User, completion: @escaping ([Post]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let posts = self.posts()
            completion(posts)
        }
    }

    private func posts() -> [Post] {
        let u1 = User(name: "bachld")
        let content1 = Post.Content(
            caption: "Hello world. Hello. This is a long sentence. I wan it to span 2 lines of UI. Hello world. Hello. This is a long sentence. I wan it to span 2 lines of UI. Hello world. Hello. This is a long sentence. I wan it to span 2 lines of UI. A little more.",
            imageUrl: "https://via.placeholder.com/480/",
            likeCount: 14)
        
        let comments = [
            Post.Comment(creator: u1, content: "Hy I am a comment",replies: []),
            Post.Comment(creator: u1, content: "World", replies: [])
        ]
        
        let u2 = User(name: "ldbach")
        let content2 = Post.Content(
            caption: "Hi world",
            imageUrl: "https://via.placeholder.com/480/",
            likeCount: 27)
        
        let post = Post(id: 1, creator: u1, content: content1, comments: comments)
        let post2 = Post(id: 2, creator: u2, content: content2, comments: comments)

        return [
            post, post2, post, post2, post, post2, post, post2, post, post2, post, post2,
            post, post2, post, post2, post, post2, post, post2, post, post2, post, post2,
            post, post2, post, post2, post, post2, post, post2, post, post2, post, post2,
        ].shuffled()
    }
}
