import XCTest
import ReactorKit
import RxDataSources
import RxExpect
import RxSwift
import RxTest
@testable import SectionReactor

final class SectionReactorTests: XCTestCase {
  func testInitialState_single() {
    let reactor = ArticleListViewReactor(testType: .single)
    XCTAssertEqual(reactor.currentState.sections.count, 3)
    XCTAssertEqual(reactor.currentState.sections[0].items.count, 0)
    XCTAssertEqual(reactor.currentState.sections[1].items.count, 0)
    XCTAssertEqual(reactor.currentState.sections[2].items.count, 0)
  }

  func testInitialState_multiple() {
    let reactor = ArticleListViewReactor(testType: .multiple(2))
    XCTAssertEqual(reactor.currentState.sections.count, 3)
    XCTAssertEqual(reactor.currentState.sections[0].items.count, 0)
    XCTAssertEqual(reactor.currentState.sections[1].items.count, 0)
    XCTAssertEqual(reactor.currentState.sections[2].items.count, 0)
  }

  func testInitialState_both() {
    let reactor = ArticleListViewReactor(testType: .both)
    XCTAssertEqual(reactor.currentState.sections.count, 3)
    XCTAssertEqual(reactor.currentState.sections[0].items.count, 0)
    XCTAssertEqual(reactor.currentState.sections[1].items.count, 0)
    XCTAssertEqual(reactor.currentState.sections[2].items.count, 0)
  }

  func testTitleIsChanged_withSingleReactor() {
    let test = RxExpect()
    let reactor = test.retain(ArticleListViewReactor(testType: .single))
    test.input(reactor.action, [
      next(100, .setTitle("Hello, Single!"))
    ])
    test.assert(reactor.state.map { $0.title }) { events in
      XCTAssertEqual(events.last?.value.element ?? nil, "Hello, Single!")
    }
  }

  func testTitleIsChanged_withEmptyMultipleReactors() {
    let test = RxExpect()
    let reactor = test.retain(ArticleListViewReactor(testType: .multiple(0)))
    test.input(reactor.action, [
      next(100, .setTitle("Hello, Empty Multiple!"))
    ])
    test.assert(reactor.state.map { $0.title }) { events in
      XCTAssertEqual(events.last?.value.element ?? nil, "Hello, Empty Multiple!")
    }
  }

  func testTitleIsChanged_withMultipleReactors() {
    let test = RxExpect()
    let reactor = test.retain(ArticleListViewReactor(testType: .multiple(3)))
    test.input(reactor.action, [
      next(100, .setTitle("Hello, Multiple!"))
    ])
    test.assert(reactor.state.map { $0.title }) { events in
      XCTAssertEqual(events.last?.value.element ?? nil, "Hello, Multiple!")
    }
  }

  func testTitleIsChanged_withBothReactors() {
    let test = RxExpect()
    let reactor = test.retain(ArticleListViewReactor(testType: .both))
    test.input(reactor.action, [
      next(100, .setTitle("Hello, Both!"))
    ])
    test.assert(reactor.state.map { $0.title }) { events in
      XCTAssertEqual(events.last?.value.element ?? nil, "Hello, Both!")
    }
  }

  func testSections_areChanged_whenSingleSectionReactorIsChanged() {
    let test = RxExpect()
    let reactor = test.retain(ArticleListViewReactor(testType: .single))
    test.input(reactor.currentState.singleSectionReactor.action, [
      next(100, .append),
      next(200, .append),
    ])
    test.assert(reactor.state.map { $0.sections }) { events in
      let sections = events.last?.value.element
      XCTAssertEqual(sections?.count, 3)
      XCTAssertEqual(sections?[0].items.count, 2)
      XCTAssertEqual(sections?[1].items.count, 0)
      XCTAssertEqual(sections?[2].items.count, 0)
    }
  }

  func testSections_areChanged_whenMultipleSectionReactorsAreChanged() {
    let test = RxExpect()
    let reactor = test.retain(ArticleListViewReactor(testType: .multiple(2)))
    test.input(reactor.currentState.multipleSectionReactors[0].action, [
      next(100, .append),
      next(200, .append),
      next(300, .append),
    ])
    test.input(reactor.currentState.multipleSectionReactors[1].action, [
      next(400, .append),
    ])
    test.assert(reactor.state.map { $0.sections }) { events in
      let sections = events.last?.value.element
      XCTAssertEqual(sections?.count, 3)
      XCTAssertEqual(sections?[0].items.count, 0)
      XCTAssertEqual(sections?[1].items.count, 3)
      XCTAssertEqual(sections?[2].items.count, 1)
    }
  }

  func testSections_areChanged_whenBothSectionReactorsAreChanged() {
    let test = RxExpect()
    let reactor = test.retain(ArticleListViewReactor(testType: .both))
    test.input(reactor.currentState.singleSectionReactor.action, [
      next(100, .append),
      next(200, .append),
      next(300, .append),
    ])
    test.input(reactor.currentState.multipleSectionReactors[0].action, [
      next(400, .append),
    ])
    test.input(reactor.currentState.multipleSectionReactors[1].action, [
      next(500, .append),
      next(600, .append),
    ])
    test.assert(reactor.state.map { $0.sections }) { events in
      let sections = events.last?.value.element
      XCTAssertEqual(sections?.count, 3)
      XCTAssertEqual(sections?[0].items.count, 3)
      XCTAssertEqual(sections?[1].items.count, 1)
      XCTAssertEqual(sections?[2].items.count, 2)
    }
  }
}


// MARK: - Section Model

struct ArticleListSection: SectionModelType {
  var sectionReactor: ArticleSectionReactor
  var items: [ArticleListSectionItem] {
    return self.sectionReactor.currentState.sectionItems
  }

  init(sectionReactor: ArticleSectionReactor) {
    self.sectionReactor = sectionReactor
  }

  init(original: ArticleListSection, items: [ArticleListSectionItem]) {
    self = original
    self.sectionReactor = original.sectionReactor
  }
}

typealias ArticleListSectionItem = Void


// MARK: - View Reactor

final class ArticleListViewReactor: Reactor {
  enum Action {
    case setTitle(String)
  }

  enum Mutation {
    case setTitle(String)
  }

  struct State {
    var title: String?
    var singleSectionReactor: ArticleSectionReactor
    var multipleSectionReactors: [ArticleSectionReactor]
    var sections: [ArticleListSection] {
      var sections: [ArticleListSection] = []
      sections.append(ArticleListSection(sectionReactor: self.singleSectionReactor))
      sections += self.multipleSectionReactors.map(ArticleListSection.init)
      return sections
    }
  }

  enum TestType {
    case single
    case multiple(Int)
    case both
  }

  let initialState: State
  let testType: TestType

  init(testType: TestType) {
    defer { _ = self.state }
    self.initialState = State(
      title: nil,
      singleSectionReactor: ArticleSectionReactor(),
      multipleSectionReactors: {
        if case let .multiple(count) = testType {
          return (0..<count).map { _ in ArticleSectionReactor() }
        } else {
          return (0..<2).map { _ in ArticleSectionReactor() }
        }
      }()
    )
    self.testType = testType
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .setTitle(title):
      return .just(.setTitle(title))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setTitle(title):
      newState.title = title
    }
    return newState
  }

  func transform(state: Observable<State>) -> Observable<State> {
    switch self.testType {
    case .single:
      return state.with(section: \.singleSectionReactor)

    case .multiple:
      return state.with(section: \.multipleSectionReactors)

    case .both:
      return state.with(section: \.singleSectionReactor).with(section: \.multipleSectionReactors)
    }
  }
}


// MARK: - Section Reactor

final class ArticleSectionReactor: SectionReactor {
  enum Action {
    case append
  }

  enum Mutation {
    case appendArticle
  }

  struct State: SectionReactorState {
    var sectionItems: [ArticleListSectionItem] = []
  }

  let initialState: State

  init() {
    defer { _ = self.state }
    self.initialState = State()
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .append:
      return .just(.appendArticle)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .appendArticle:
      state.sectionItems.append(ArticleListSectionItem())
    }
    return state
  }
}
