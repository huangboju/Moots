//
//  ArticleViewReactor.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 07/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class ArticleViewReactor: Reactor {
  enum Action {
  }

  enum Mutation {
  }

  struct State {
    var authorName: String
    var articleSectionReactor: ArticleSectionReactor
    var sections: [ArticleViewSection] {
      return [.article(self.articleSectionReactor)]
    }
  }

  let initialState: State

  init(
    article: Article,
    articleSectionReactorFactory: (Article) -> ArticleSectionReactor
  ) {
    defer { _ = self.state }
    self.initialState = State(
      authorName: article.author.name,
      articleSectionReactor: articleSectionReactorFactory(article)
    )
  }

  func transform(state: Observable<State>) -> Observable<State> {
    return state.with(section: \.articleSectionReactor)
  }
}
