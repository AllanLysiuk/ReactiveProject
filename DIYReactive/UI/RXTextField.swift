import Foundation
import UIKit

public class RXTextField: UITextField {
    
    public var didChangeSelection: RxPublisher<Void> = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRx()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupRx()
    }
    
    private func setupRx() {
        delegate = self
    }
}

extension RXTextField: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        didChangeSelection.send(event: ())
    }
}
