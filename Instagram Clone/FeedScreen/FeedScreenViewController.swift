import UIKit

class FeedScreenViewController: BaseViewController {

    private let loggedInUser: User
    
    
    init(of user: User) {
        loggedInUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var storyViewController = StoryViewController(viewingAs: loggedInUser)
    //    private lazy var postViewController = PostViewController(viewingAs: loggedInUser)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Instagram"
        
        addSubViewController(storyViewController)
        view.backgroundColor = .blue
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        storyViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width - insets.left - insets.right,
            height: storyViewController.collectiveHeight
        )
    }
}
