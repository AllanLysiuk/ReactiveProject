class RxClosure<T: Any>: Equatable {
    private let id = UUID()
    let body: (T) -> Void
    
    init(body: @escaping (T) -> Void) {
        self.body = body
    }
    
    static func == (
        lhs: RxClosure<T>,
        rhs: RxClosure<T>
    ) -> Bool {
        return lhs.id == rhs.id
    }
}
