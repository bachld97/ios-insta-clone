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
            caption: "Hello world. This is a long sentence. I want it to span 2 lines of UI. Hello world. Hello. This is a long sentence. I wan it to span 2 lines of UI. Hello world. Hello. This is a long sentence. I wan it to span 2 lines of UI. A little more. Hello world. This is a long sentence. I want it to span 2 lines of UI. Hello world. Hello. This is a long sentence. I wan it to span 2 lines of UI. Hello world. Hello. This is a long sentence. I wan it to span 2 lines of UI. A little more",
            images: [.init(url: "https://via.placeholder.com/480/")],
            likeCount: 14)
        
        let comments = [
            Post.Comment(creator: u1, content: "Hy I am a comment",replies: []),
            Post.Comment(creator: u1, content: "World", replies: [])
        ]
        
        let u2 = User(name: "ldbach")
        let content2 = Post.Content(
            caption: "1\n2 2a\n3\n4\n5\n",
            images: [.init(url: "https://via.placeholder.com/480/")],
            likeCount: 27)
        
        let content3 = Post.Content(
            caption: "1 con vit xoe ra\n0002 cai canh\n3\n4\n5\n",
            images: [.init(url: "https://via.placeholder.com/480/")],
            likeCount: 27)
        
        let content4 = Post.Content(
            caption: "Hello world. This is a long sentence. I want it to span 2 lines of UIz\nHi i am 3rd line",
            images: [.init(url: "https://via.placeholder.com/480/")],
            likeCount: 27)
        
        let content5 = Post.Content(
            caption: "Hello world. This is a long sentence. I want it to span 2 lines of UIz\nHelllllloooo i am 3rd line",
            images: [.init(url: "https://via.placeholder.com/480/")],
            likeCount: 27)
        
        let post = Post(id: 1, creator: u1, content: content1, comments: comments)
        let post2 = Post(id: 2, creator: u2, content: content2, comments: comments)
        let post3 = Post(id: 3, creator: u1, content: content3, comments: comments)
        let post4 = Post(id: 4, creator: u1, content: content4, comments: comments)
        let post5 = Post(id: 4, creator: u2, content: content5, comments: comments)


        return [
            post, post2, post3, post4, post5
        ]
    }
}
