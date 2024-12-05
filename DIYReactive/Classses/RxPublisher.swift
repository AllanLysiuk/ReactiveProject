public class RxPublisher<T: Any> {
    
    private var subscribers: [RxClosure<T>] = []
    
    private var bag: [RxReleasable] = []
    
    public init() { }
    
    public func subscribe(
        _ handler: @escaping (T) -> Void
    ) -> RxReleasable {
        let closure = RxClosure(body: handler)
        subscribers.append(closure)
        
        return RxReleasable { [weak self] in
            self?.subscribers.removeAll(where: { closure == $0 })
        }
    }
    
    public func filter(
        _ handler: @escaping (T) -> Bool
    ) -> RxPublisher<T> {
        let filteredPublisher = RxPublisher<T>()
        
        self.subscribe { event in
            if handler(event) {
                filteredPublisher.send(event: event)
            }
        }.store(in: &bag)
        
        return filteredPublisher
    }
    
    public func map<MappedType: Any>(
        _ handler: @escaping (T) -> MappedType
    ) -> RxPublisher<MappedType> {
        let mapPublisher = RxPublisher<MappedType>()
        
        self.subscribe { event in
            let mappedValue = handler(event)
            mapPublisher.send(event: mappedValue)
        }.store(in: &bag)
        
        return mapPublisher
    }
    
    public func compactMap<MappedType: Any>(
        _ handler: @escaping (T) -> MappedType?
    ) -> RxPublisher<MappedType> {
        let compactMapPublisher = RxPublisher<MappedType>()
        
        self.subscribe { event in
            if let mappedValue = handler(event) {
                compactMapPublisher.send(event: mappedValue)
            }
        }.store(in: &bag)
        
        return compactMapPublisher
    }
    
    public func skip(_ n: Int) -> RxPublisher<T> {
        let skipPublisher = RxPublisher<T>()
        var count = 0
        
        self.subscribe { event in
            if count >= n {
                skipPublisher.send(event: event)
            } else {
                count += 1
            }
        }.store(in: &bag)
        
        return skipPublisher
    }
    
    public func throttle(_ interval: TimeInterval) -> RxPublisher<T> {
        let throttlePublisher = RxPublisher<T>()
        var lastEventTimestamp: Date?
        
        self.subscribe { event in
            let now = Date()
            
            if let lastTimestamp = lastEventTimestamp {
                let timeInterval = now.timeIntervalSince(lastTimestamp)
                
                // Если прошло больше или равно interval секунд, отправляем событие
                if timeInterval >= interval {
                    throttlePublisher.send(event: event)
                    lastEventTimestamp = now
                }
            } else {
                // Если это первое событие, отправляем его сразу
                throttlePublisher.send(event: event)
                lastEventTimestamp = now
            }
        }.store(in: &bag)
        
        return throttlePublisher
    }
    
    public func merge(
        _ publishers: RxPublisher<T>...
    ) -> RxPublisher<T> {
        let mergePublisher = RxPublisher<T>()
        let allPublishers = publishers + [self]
        allPublishers.forEach { publisher in
            bag.append(
                publisher.subscribe { event in
                    mergePublisher.send(event: event)
                }
            )
        }
        return mergePublisher
    }
    
    public func observeOn(
        queue: DispatchQueue
    ) -> RxPublisher<T> {
        let queuePublisher = RxPublisher<T>()
        self.subscribe { event in
            queue.async {
                queuePublisher.send(event: event)
            }
        }.store(in: &bag)
        
        return queuePublisher
    }
    
    public func send(
        event: T
    ) {
        subscribers.forEach { $0.body(event) }
    }
}
