import UIKit

class NotificationScreenViewController: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        let dataSource = CollectionViewDataSource()
        dataSource.objects = ["Hello", "world", "BaseCollectionViewController"]
        self.dataSource = dataSource
    }
}
