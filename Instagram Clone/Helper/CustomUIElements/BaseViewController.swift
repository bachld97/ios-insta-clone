import UIKit

class BaseViewController: UIViewController {
    
    private (set) var insets = Spacing(top: 20, bottom: 0)
    
    func showSimpleAlert(title: String, message: String, cancelTitle: String) {
        let actions = [
            UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        ]
        showAlert(title: title, message: message, actions: actions)
    }
    
    func showAlert(
        title: String, message: String, actions: [UIAlertAction] = [],
        preferredStyle: UIAlertController.Style = .alert
        ) {
        let localizedTitle = NSLocalizedString(title, comment: "")
        let localizedMessage = NSLocalizedString(message, comment: "")
        let alertController = UIAlertController(
            title: localizedTitle, message: localizedMessage,
            preferredStyle: preferredStyle
        )
        
        actions.forEach { alertController.addAction($0) }
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            self.insets = Spacing(
                top: view.safeAreaInsets.top,
                bottom: view.safeAreaInsets.bottom,
                left: view.safeAreaInsets.left,
                right: view.safeAreaInsets.right
            )
        } else {
            // Notch devices has minimum version of iOS 11
        }
    }
    
    final func addSubViewController(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
