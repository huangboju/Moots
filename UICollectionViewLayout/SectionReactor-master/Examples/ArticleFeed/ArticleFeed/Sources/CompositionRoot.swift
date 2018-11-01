//
//  CompositionRoot.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 08/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class CompositionRoot {
  static func rootViewController() -> UIViewController {
    let articleService = ArticleService()

    let articleSectionReactorFactory: (Article) -> ArticleSectionReactor = { article in
      return ArticleSectionReactor(
        article: article,
        authorCellReactorFactory: ArticleCardAuthorCellReactor.init,
        textCellReactorFactory: ArticleCardTextCellReactor.init,
        reactionCellReactorFactory: ArticleCardReactionCellReactor.init,
        commentCellReactorFactory: ArticleCardCommentCellReactor.init
      )
    }

    let presentArticleViewControllerFactory: (Article, UIViewController) -> () -> Void = {
      (article: Article, from: UIViewController) in
      return { [weak from] in
        guard let from = from else { return }
        let reactor = ArticleViewReactor(
          article: article,
          articleSectionReactorFactory: articleSectionReactorFactory
        )
        let viewController = ArticleViewController(
          reactor: reactor,
          articleCardAuthorCellDependencyFactory: { _, _ in .init(presentArticleViewController: {}) },
          articleCardTextCellDependencyFactory: { _, _ in .init(presentArticleViewController: {}) },
          articleCardReactionCellDependencyFactory: { _, _ in .init(presentArticleViewController: {}) }
        )
        from.navigationController?.pushViewController(viewController, animated: true)
      }
    }

    let articleCardAuthorCellDependencyFactory: (Article, UIViewController) -> ArticleCardAuthorCell.Dependency = { article, fromViewController in
      .init(presentArticleViewController: presentArticleViewControllerFactory(article, fromViewController))
    }
    let articleCardTextCellDependencyFactory: (Article, UIViewController) -> ArticleCardTextCell.Dependency = { article, fromViewController in
      .init(presentArticleViewController: presentArticleViewControllerFactory(article, fromViewController))
    }
    let articleCardReactionCellDependencyFactory: (Article, UIViewController) -> ArticleCardReactionCell.Dependency = { article, fromViewController in
      .init(presentArticleViewController: presentArticleViewControllerFactory(article, fromViewController))
    }

    let reactor = ArticleListViewReactor(
      articleService: articleService,
      articleSectionReactorFactory: articleSectionReactorFactory
    )
    let viewController = ArticleListViewController(
      reactor: reactor,
      articleCardAuthorCellDependencyFactory: articleCardAuthorCellDependencyFactory,
      articleCardTextCellDependencyFactory: articleCardTextCellDependencyFactory,
      articleCardReactionCellDependencyFactory: articleCardReactionCellDependencyFactory
    )
    let navigationController = UINavigationController(rootViewController: viewController)
    return navigationController
  }
}
