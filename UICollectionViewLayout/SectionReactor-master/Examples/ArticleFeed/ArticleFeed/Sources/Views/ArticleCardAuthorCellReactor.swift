//
//  ArticleCardAuthorCellReactor.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class ArticleCardAuthorCellReactor: Reactor {
  enum Action {
  }

  enum Mutation {
  }

  struct State {
    var name: String
  }

  let initialState: State

  init(user: User) {
    defer { _ = self.state }
    self.initialState = State(name: user.name)
  }
}
