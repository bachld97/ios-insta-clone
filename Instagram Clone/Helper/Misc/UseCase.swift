protocol UseCase {
    associatedtype Request
    associatedtype Response
    
    func execute(_ request: Request, completion: @escaping (Response) -> Void)
}
