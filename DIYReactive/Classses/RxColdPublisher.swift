import Foundation

public class RxColdPublisher<T: Any>: RxPublisher<T> {
    
    private let maxCached: Int
    
    private var cache: [T] = [] {
        didSet {
            if cache.count > maxCached {
                cache.removeFirst()
            }
        }
    }
    
    public init(
        maxCached: Int
    ) {
        self.maxCached = maxCached
        super.init()
    }
    
    public override func subscribe(
        _ handler: @escaping (T) -> Void
    ) -> RxReleasable {
        cache.forEach(handler)
        return super.subscribe(handler)
    }
    
    public override func send(event: T) {
        cache.append(event)
        super.send(event: event)
    }
    
}
