//
//  ArticleCardReactionCellReactor.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class ArticleCardReactionCellReactor: Reactor {
  enum Action {
    case createComment
  }

  enum Mutation {
  }

  struct State {
    var articleID: String
  }

  let initialState: State

  init(articleID: String) {
    defer { _ = self.state }
    self.initialState = State(articleID: articleID)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .createComment:
      return Observable.create { [weak self] observer in
        if let articleID = self?.currentState.articleID {
          let comment = Comment.random(articleID: articleID)
          Comment.event.onNext(.create(comment))
        }
        observer.onCompleted()
        return Disposables.create()
      }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    return state
  }
}
