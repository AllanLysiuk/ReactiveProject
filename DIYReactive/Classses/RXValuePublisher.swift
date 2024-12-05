import Foundation

public class RxValuePublisher<T: Any>: RxPublisher<T> {
    
    public var value: T
    
    init(initialValue: T) {
        self.value = initialValue
    }
    
    public override func subscribe(
        _ handler: @escaping (T) -> Void
    ) -> RxReleasable {
        handler(value)
        return super.subscribe(handler)
    }
    
    public override func send(event: T) {
        value = event
        super.send(event: event)
    }
    
}
