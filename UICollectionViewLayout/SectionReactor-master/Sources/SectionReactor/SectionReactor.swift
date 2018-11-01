import ReactorKit
import RxDataSources
import RxSwift

public protocol SectionReactorState {
  associatedtype SectionItem
  var sectionItems: [SectionItem] { get }
}

public protocol SectionReactorArrayConvertible {
  associatedtype SectionReactor
  var sectionReactors: [SectionReactor] { get }
}

public typealias _SectionReactor = SectionReactor
public protocol SectionReactor: Reactor, SectionReactorArrayConvertible where State: SectionReactorState {
}

extension SectionReactor {
  public var sectionReactors: [Self] {
    return [self]
  }
}

extension Array: SectionReactorArrayConvertible {
  public var sectionReactors: [Element] {
    return self
  }
}

public extension ObservableType {
  public func with<State, R>(
    section sectionReactorsKeyPath: KeyPath<State, R>
  ) -> Observable<State> where E == State, R: SectionReactorArrayConvertible, R.SectionReactor: SectionReactor {
    return self.flatMap { state -> Observable<E> in
      let sectionReactors = state[keyPath: sectionReactorsKeyPath].sectionReactors
      let sectionStates = Observable.merge(sectionReactors.map { $0.state.skip(1) })
      return Observable.merge(.just(state), sectionStates.map { _ in state })
    }
  }
}
