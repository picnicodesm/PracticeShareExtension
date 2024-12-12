import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    private var navigationBar: UINavigationBar!
    private var itemLabel: UILabel!
    private var itemText: String?
    
    override func loadView() {
        super.loadView()
        guard let extensionContext = extensionContext else { return }
        guard let extensionItems = extensionContext.inputItems as? [NSExtensionItem] else { return }
        guard let extensionItem = extensionItems.first else { return }
        guard let extensionItemProvider = extensionItem.attachments?.first else { return }
        
        if extensionItemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            extensionItemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (url, error) in
                if let url = url as? URL {
                    DispatchQueue.main.async {
                        self?.itemLabel.text = url.absoluteString
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

extension ShareViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
        configureNavBar()
        configureItemLabel()
    }
    
    private func configureNavBar() {
        navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let navItem = UINavigationItem(title: "ShareExtenion 연습")
        navItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel)
        navItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done)
        navigationBar.setItems([navItem], animated: false)
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureItemLabel() {
        itemLabel = UILabel()
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.backgroundColor = .black
        itemLabel.textColor = .white
        itemLabel.text = "Hello Share Extension"
        
        view.addSubview(itemLabel)
        
        NSLayoutConstraint.activate([
            itemLabel.widthAnchor.constraint(equalToConstant: 300),
            itemLabel.heightAnchor.constraint(equalToConstant: 50),
            itemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
