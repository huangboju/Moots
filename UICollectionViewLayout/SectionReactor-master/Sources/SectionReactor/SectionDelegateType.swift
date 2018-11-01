public protocol SectionDelegateType {
  associatedtype SectionReactor: _SectionReactor
  typealias SectionItem = SectionReactor.State.SectionItem
}
