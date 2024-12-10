import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    private let items = ["Family", "Friends", "Study"]
    let shareInItem = SLComposeSheetConfigurationItem()
    
    override func loadView() {
        super.loadView()
        guard let extensionContext = extensionContext else { return }
        guard let extensionItems = extensionContext.inputItems as? [NSExtensionItem] else { return }
        guard let extensionItem = extensionItems.first else { return }
    }
    
    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        // 1. Compose View 밑에 tableview로 나타날 Item 정의
        shareInItem?.title = "Share in"
        shareInItem?.value = items[0]
        shareInItem?.tapHandler = { [weak self] in // 2. tapHandler에서 커스텀 뷰 호출
            guard let self = self else { return }
            self.showSelectionViewController()
        }
        
        // 3. Item 리턴
        return [shareInItem].compactMap { $0 }
    }
    
    private func showSelectionViewController() {
        // 선택을 위한 커스텀 뷰 컨트롤러
        let selectionVC = SelectionViewController()
        selectionVC.selectedItem = shareInItem!.value
        selectionVC.items = items
        selectionVC.onSelected = { [weak self] selectedItem in
            self?.shareInItem?.value = selectedItem
            self?.popConfigurationViewController() // 이전 화면으로 돌아감
        }
        
        // 구성 뷰 컨트롤러 표시
        pushConfigurationViewController(selectionVC)
    }
    
}

// 선택을 위한 CustomView 작성
class SelectionViewController: UIViewController {
    var selectedItem: String = ""
    var onSelected: ((String) -> Void)?
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .clear
        cell.textLabel?.text = items[indexPath.row]
        cell.accessoryType = items[indexPath.row] == selectedItem ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = items[indexPath.row]
        onSelected?(selected)
    }
}
