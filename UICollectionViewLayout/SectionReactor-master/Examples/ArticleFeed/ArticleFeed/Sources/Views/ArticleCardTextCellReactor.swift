//
//  ArticleCardTextCellReactor.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class ArticleCardTextCellReactor: Reactor {
  enum Action {
  }

  enum Mutation {
  }

  struct State {
    var text: String
  }

  let initialState: State

  init(text: String) {
    defer { _ = self.state }
    self.initialState = State(text: text)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    return .empty()
  }

  func reduce(state: State, mutation: Mutation) -> State {
    return state
  }
}
