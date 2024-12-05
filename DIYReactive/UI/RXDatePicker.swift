import Foundation
import UIKit

public class RXDatePicker: UIDatePicker {
    
    public var didChangeDate: RxPublisher<Date> = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRx()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupRx()
    }
    
    private func setupRx() {
        addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc private func dateChanged() {
        didChangeDate.send(event: (date))
    }
}
