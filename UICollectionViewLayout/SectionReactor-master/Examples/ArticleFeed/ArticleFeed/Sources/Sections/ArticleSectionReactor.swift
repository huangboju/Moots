//
//  ArticleSectionReactor.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift
import SectionReactor

final class ArticleSectionReactor: SectionReactor {
  enum SectionItem {
    case author(ArticleCardAuthorCellReactor)
    case text(ArticleCardTextCellReactor)
    case reaction(ArticleCardReactionCellReactor)
    case comment(ArticleCardCommentCellReactor)
  }

  enum Action {
  }

  enum Mutation {
    case appendComment(Comment)
  }

  struct State: SectionReactorState {
    var article: Article
    var sectionItems: [SectionItem]
  }

  let initialState: State
  let authorCellReactorFactory: (User) -> ArticleCardAuthorCellReactor
  let textCellReactorFactory: (String) -> ArticleCardTextCellReactor
  let reactionCellReactorFactory: (String) -> ArticleCardReactionCellReactor
  let commentCellReactorFactory: (Comment) -> ArticleCardCommentCellReactor

  init(
    article: Article,
    authorCellReactorFactory: @escaping (User) -> ArticleCardAuthorCellReactor,
    textCellReactorFactory: @escaping (String) -> ArticleCardTextCellReactor,
    reactionCellReactorFactory: @escaping (String) -> ArticleCardReactionCellReactor,
    commentCellReactorFactory: @escaping (Comment) -> ArticleCardCommentCellReactor
  ) {
    defer { _ = self.state }
    self.authorCellReactorFactory = authorCellReactorFactory
    self.textCellReactorFactory = textCellReactorFactory
    self.reactionCellReactorFactory = reactionCellReactorFactory
    self.commentCellReactorFactory = commentCellReactorFactory

    var sectionItems: [SectionItem] = [
      .author(ArticleCardAuthorCellReactor(user: article.author))
    ]
    if let text = article.text {
      sectionItems.append(.text(ArticleCardTextCellReactor(text: text)))
    }
    sectionItems.append(.reaction(ArticleCardReactionCellReactor(articleID: article.id)))
    for comment in article.comments {
      sectionItems.append(.comment(ArticleCardCommentCellReactor(comment: comment)))
    }
    self.initialState = State(article: article, sectionItems: sectionItems)
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let fromCommentEvent = Comment.event.flatMap { [weak self] event -> Observable<Mutation> in
      guard let `self` = self else { return .empty() }
      switch event {
      case let .create(comment):
        guard comment.articleID == self.currentState.article.id else { return .empty() }
        return .just(Mutation.appendComment(comment))
      }
    }
    return Observable.merge(mutation, fromCommentEvent)
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .appendComment(comment):
      state.article.comments.append(comment)
      state.sectionItems.append(.comment(ArticleCardCommentCellReactor(comment: comment)))
      return state
    }
  }
}
