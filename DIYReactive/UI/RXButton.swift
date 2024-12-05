import UIKit

public class RxButton: UIButton {
    
    public var eventPublishers: [UInt: RxPublisher<Void>] = [:]
    
    public func publisher(for event: UIControl.Event) -> RxPublisher<Void> {
        let key = event.rawValue
        if let publisher = eventPublishers[key] {
            return publisher
        } else {
            let publisher = RxPublisher<Void>()
            eventPublishers[key] = publisher
            addTarget(self, action: selector(for: event), for: event)
            return publisher
        }
    }
    
    @objc private func test(_ event: UIControl.Event) {
        eventPublishers[event.rawValue]?.send(event: ())
    }
    
    private func selector(for event: UIControl.Event) -> Selector {
        switch event {
        case .touchDown:
            return #selector(handleTouchDown)
        case .touchDownRepeat:
            return #selector(handleTouchDownRepeat)
        case .touchDragInside:
            return #selector(handleTouchDragInside)
        case .touchDragOutside:
            return #selector(handleTouchDragOutside)
        case .touchDragExit:
            return #selector(handleTouchDragExit)
        case .touchDragEnter:
            return #selector(handleTouchDragEnter)
        case .touchUpInside:
            return #selector(handleTouchUpInside)
        case .touchUpOutside:
            return #selector(handleTouchUpOutside)
        case .valueChanged:
            return #selector(handleValueChanged)
        case .primaryActionTriggered:
            return #selector(handlePrimaryActionTriggered)
        case .editingDidBegin:
            return #selector(handleEditingDidBegin)
        case .editingChanged:
            return #selector(handleEditingChanged)
        case .editingDidEnd:
            return #selector(handleEditingDidEnd)
        case .editingDidEndOnExit:
            return #selector(handleEditingDidEndOnExit)
        default:
            fatalError("Unsupported event: \(event)")
        }
    }
    
    @objc private func handleTouchDown() {
        eventPublishers[UIControl.Event.touchDown.rawValue]?.send(event: ())
    }
    
    @objc private func handleTouchDownRepeat() {
        eventPublishers[UIControl.Event.touchDownRepeat.rawValue]?.send(event: ())
    }
    
    @objc private func handleTouchDragInside() {
        eventPublishers[UIControl.Event.touchDragInside.rawValue]?.send(event: ())
    }
    
    @objc private func handleTouchDragOutside() {
        eventPublishers[UIControl.Event.touchDragOutside.rawValue]?.send(event: ())
    }
    
    @objc private func handleTouchDragExit() {
        eventPublishers[UIControl.Event.touchDragExit.rawValue]?.send(event: ())
    }
    
    @objc private func handleTouchDragEnter() {
        eventPublishers[UIControl.Event.touchDragEnter.rawValue]?.send(event: ())
    }
    
    @objc private func handleTouchUpInside() {
        eventPublishers[UIControl.Event.touchUpInside.rawValue]?.send(event: ())
    }
    
    @objc private func handleTouchUpOutside() {
        eventPublishers[UIControl.Event.touchUpOutside.rawValue]?.send(event: ())
    }
    
    @objc private func handleValueChanged() {
        eventPublishers[UIControl.Event.valueChanged.rawValue]?.send(event: ())
    }
    
    @objc private func handlePrimaryActionTriggered() {
        eventPublishers[UIControl.Event.primaryActionTriggered.rawValue]?.send(event: ())
    }
    
    @objc private func handleEditingDidBegin() {
        eventPublishers[UIControl.Event.editingDidBegin.rawValue]?.send(event: ())
    }
    
    @objc private func handleEditingChanged() {
        eventPublishers[UIControl.Event.editingChanged.rawValue]?.send(event: ())
    }
    
    @objc private func handleEditingDidEnd() {
        eventPublishers[UIControl.Event.editingDidEnd.rawValue]?.send(event: ())
    }
    
    @objc private func handleEditingDidEndOnExit() {
        eventPublishers[UIControl.Event.editingDidEndOnExit.rawValue]?.send(event: ())
    }
}
