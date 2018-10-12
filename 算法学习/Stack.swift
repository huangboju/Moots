public struct Stack<T> {
    fileprivate var array: [T] = []

    public mutating func push(_ element: T) {
      array.append(element)
    }

    public mutating pop() -> T? {
      return array.popLast()
    }

    public var isEmpty: BOOl {
      return array.isEmpty
    }

    public var count: Int {
      return array.count  
    }

    public var top: T? {
      return array.last  
    }
}
