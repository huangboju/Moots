//
//  ArticleListViewReactor.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class ArticleListViewReactor: Reactor {
  enum Action {
    case refresh
  }

  enum Mutation {
    case setRefreshing(Bool)
    case setArticles([Article])
  }

  struct State {
    var isRefreshing: Bool = false
    fileprivate var articleSectionReactors: [ArticleSectionReactor] = []
    var sections: [ArticleListViewSection] {
      return self.articleSectionReactors.map(ArticleListViewSection.article)
    }
  }

  let initialState: State
  fileprivate let articleService: ArticleServiceType
  fileprivate let articleSectionReactorFactory: (Article) -> ArticleSectionReactor

  init(
    articleService: ArticleServiceType,
    articleSectionReactorFactory: @escaping (Article) -> ArticleSectionReactor
  ) {
    defer { _ = self.state }
    self.articleService = articleService
    self.articleSectionReactorFactory = articleSectionReactorFactory
    self.initialState = State()
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      guard self.currentState.isRefreshing == false else { return .empty() }
      return .concat([
        Observable.just(Mutation.setRefreshing(true)),
        self.articleService.articles().map(Mutation.setArticles),
        Observable.just(Mutation.setRefreshing(false)),
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setRefreshing(isRefreshing):
      state.isRefreshing = isRefreshing
      return state

    case let .setArticles(articles):
      state.articleSectionReactors = articles.map(self.articleSectionReactorFactory)
      return state
    }
  }

  func transform(state: Observable<State>) -> Observable<State> {
    return state.with(section: \.articleSectionReactors)
  }
}
