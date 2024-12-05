import UIKit
import DIYReactive

class ChatViewController: UIViewController {
    
    private var messages: [String] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessageBubbleCell.self, forCellReuseIdentifier: "\(MessageBubbleCell.self)")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    private let inputPanel: UIView = {
        let inputPanel = UIView()
        inputPanel.backgroundColor = .white
        inputPanel.translatesAutoresizingMaskIntoConstraints = false
        return inputPanel
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите сообщение..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let sendButton: RxButton = {
        let button = RxButton()
        button.setTitle("Отправить", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Bag for storing reactive subscriptions
    private var bag: [RxReleasable] = []
    
    private var inputPanelBottomConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(inputPanel)
        inputPanel.addSubview(textField)
        inputPanel.addSubview(sendButton)
        
        inputPanelBottomConstraint = NSLayoutConstraint(item: inputPanel, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputPanel.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            inputPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputPanelBottomConstraint,
            inputPanel.heightAnchor.constraint(equalToConstant: 80),
            
            textField.leadingAnchor.constraint(equalTo: inputPanel.leadingAnchor, constant: 10),
            textField.topAnchor.constraint(equalTo: inputPanel.topAnchor, constant: 8),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            
            sendButton.trailingAnchor.constraint(equalTo: inputPanel.trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 120),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func bind() {
        
        sendButton.publisher(for: .touchUpInside).subscribe { [weak self] _ in
            guard let self else { return }
            sendMessage()
        }.store(in: &bag)
        
        RxNotificationCenter.shared
            .observe(name: UIResponder.keyboardWillShowNotification)
            .merge(
                RxNotificationCenter.shared
                    .observe(name: UIResponder.keyboardWillHideNotification)
            )
            .subscribe({ [weak self] notification in
                guard let self = self else { return }
                if notification.name == UIResponder.keyboardWillHideNotification {
                    self.adjustInputPanelPosition(keyboardHeight: 0)
                } else if let userInfo = notification.userInfo,
                   let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self.adjustInputPanelPosition(keyboardHeight: keyboardFrame.height)
                }
            })
            .store(in: &bag)

    }
    
    private func sendMessage() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        messages.append(text)
        tableView.reloadData()
        
        // Clear text field after sending
        textField.text = ""
        
        // Scroll to the bottom of the table view
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func adjustInputPanelPosition(keyboardHeight: CGFloat) {
        let offset: CGFloat = keyboardHeight > 0 ? -keyboardHeight : 0
        
        UIView.animate(withDuration: 0.3) {
            self.inputPanelBottomConstraint.constant = offset
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MessageBubbleCell.self)", for: indexPath) as! MessageBubbleCell
        cell.configureCell(text: message)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let message = messages[indexPath.row]
//        let size = CGSize(width: tableView.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude)
//        let estimatedSize = MessageBubbleCell().messageLabel.sizeThatFits(size)
//        return estimatedSize.height + 20
        return UITableView.automaticDimension
    }
}
