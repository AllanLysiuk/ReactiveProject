import UIKit
import DIYReactive

class ViewController: UIViewController {
    
    private lazy var button: RxButton = {
        let button = RxButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Press Me!", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var textField: RXTextField = {
        let textField = RXTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var datePicker: RXDatePicker = {
        let datePicker = RXDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private var bag: [RxReleasable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        button.publisher(for: .touchDragExit).subscribe({ _ in
            print("Yes! You dragged on me!")
        }).store(in: &bag)
        
        button.publisher(for: .touchUpInside).subscribe({ _ in
            print("Yes! You tapped on me!")
        }).store(in: &bag)
        
        textField.didChangeSelection.subscribe({ _ in
            print("Text field did change selection")
        }).store(in: &bag)
        
        datePicker.didChangeDate.subscribe({ date in
            print("Did change date: \(date)")
        }).store(in: &bag)
        
        datePicker.didChangeDate.filter { date in
            return date == Date()
        }

    }
    
    private func setupView() {
        view.addSubview(button)
        view.addSubview(textField)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
