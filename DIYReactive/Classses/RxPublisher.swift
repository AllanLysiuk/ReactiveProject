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
        _ handler: @escaping (T) -> MappedType
    ) -> RxPublisher<MappedType> {
        let mapPublisher = RxPublisher<MappedType>()
        
        self.subscribe { event in
            let mappedValue = handler(event)
            mapPublisher.send(event: mappedValue)
        }.store(in: &bag)
        
        return mapPublisher
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
