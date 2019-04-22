public struct BitSet {
  private (set)  public var size: Int

  private let N = 64
  public typealias Word = UInt64
  fileprivate(set) public var words: [Word]

  public init(size: Int) {
    precondition(size > 0)
    self.size = size

    let n = (size + (N - 1)) / N
    words = [Word](repeating: 0, count: n)
  }
}
