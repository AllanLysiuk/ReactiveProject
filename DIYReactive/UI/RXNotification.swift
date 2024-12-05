import Foundation

public final class RxNotificationCenter {
    private init() {}
    
    public static let shared: RxNotificationCenter = .init()
    
    private var publisher = RxPublisher<Notification>()
    private var registeredNames: [Notification.Name] = []
    
    public func observe(
        name: Notification.Name
    ) -> RxPublisher<Notification> {
        registerNameIfNeeded(name: name)
        return publisher
            .filter { $0.name == name }
    }
    
    @objc private func handle(notification: Notification) {
        publisher.send(event: notification)
    }
    
    private func registerNameIfNeeded(name: Notification.Name) {
        guard !registeredNames.contains(name) else { return }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handle(notification:)),
            name: name,
            object: nil
        )
    }
}
