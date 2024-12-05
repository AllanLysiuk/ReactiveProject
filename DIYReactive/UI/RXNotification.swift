import Foundation

public class RXNotification {
    
    private var publishers: [String: RxPublisher<Any>] = [:]
    
    public func subscribeToNotification<T>(
        name: Notification.Name,
        object: Any? = nil,
        type: T.Type,
        handler: @escaping (T) -> Void
    ) -> RxReleasable {
        let publisher = getPublisher(for: name)
        
        return publisher.subscribe { event in
            if let event = event as? T {
                handler(event)
            }
        }
    }
    
    private func getPublisher(for notificationName: Notification.Name) -> RxPublisher<Any> {
        let nameKey = notificationName.rawValue
        
        if let publisher = publishers[nameKey] {
            return publisher
        } else {
            let publisher = RxPublisher<Any>()
            publishers[nameKey] = publisher
            NotificationCenter.default.addObserver(
                forName: notificationName,
                object: nil,
                queue: .main) { [weak self] notification in
                    self?.publish(notification, for: notificationName)
                }
            return publisher
        }
    }
    
    private func publish(_ notification: Notification, for notificationName: Notification.Name) {
        if let publisher = publishers[notificationName.rawValue] {
            publisher.send(event: notification.object as Any)
        }
    }
}
