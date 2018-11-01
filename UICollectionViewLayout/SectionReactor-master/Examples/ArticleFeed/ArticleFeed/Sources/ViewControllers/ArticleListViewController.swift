//
//  ViewController.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import RxSwift
import UICollectionViewFlexLayout

final class ArticleListViewController: UIViewController, View {

  // MARK: Properties

  var disposeBag = DisposeBag()
  lazy var dataSource = self.createDataSource()
  let articleSectionDelegate = ArticleSectionDelegate()
  private let articleCardAuthorCellDependencyFactory: (Article, UIViewController) -> ArticleCardAuthorCell.Dependency
  private let articleCardTextCellDependencyFactory: (Article, UIViewController) -> ArticleCardTextCell.Dependency
  private let articleCardReactionCellDependencyFactory: (Article, UIViewController) -> ArticleCardReactionCell.Dependency


  // MARK: UI

  let refreshControl: UIRefreshControl = UIRefreshControl().then {
    $0.layer.zPosition = -999
  }
  let collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlexLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
  }


  // MARK: Initializing

  init(
    reactor: ArticleListViewReactor,
    articleCardAuthorCellDependencyFactory: @escaping (Article, UIViewController) -> ArticleCardAuthorCell.Dependency,
    articleCardTextCellDependencyFactory: @escaping (Article, UIViewController) -> ArticleCardTextCell.Dependency,
    articleCardReactionCellDependencyFactory: @escaping (Article, UIViewController) -> ArticleCardReactionCell.Dependency
  ) {
    defer { self.reactor = reactor }
    self.articleCardAuthorCellDependencyFactory = articleCardAuthorCellDependencyFactory
    self.articleCardTextCellDependencyFactory = articleCardTextCellDependencyFactory
    self.articleCardReactionCellDependencyFactory = articleCardReactionCellDependencyFactory
    super.init(nibName: nil, bundle: nil)
    self.title = "Articles"
    self.articleSectionDelegate.registerReusables(to: self.collectionView)
  }

  required convenience init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ArticleListViewSection> {
    return .init(
      configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
        guard let `self` = self else { return collectionView.emptyCell(for: indexPath) }

        let articleCardAuthorCellDependency: ArticleCardAuthorCell.Dependency
        let articleCardTextCellDependency: ArticleCardTextCell.Dependency
        let articleCardReactionCellDependency: ArticleCardReactionCell.Dependency

        let section = dataSource[indexPath.section]
        switch section {
        case let .article(sectionReactor):
          let article = sectionReactor.currentState.article
          articleCardAuthorCellDependency = self.articleCardAuthorCellDependencyFactory(article, self)
          articleCardTextCellDependency = self.articleCardTextCellDependencyFactory(article, self)
          articleCardReactionCellDependency = self.articleCardReactionCellDependencyFactory(article, self)
        }

        switch sectionItem {
        case let .articleCard(item):
          return self.articleSectionDelegate.cell(
            collectionView: collectionView,
            indexPath: indexPath,
            sectionItem: item,
            articleCardAuthorCellDependency: articleCardAuthorCellDependency,
            articleCardTextCellDependency: articleCardTextCellDependency,
            articleCardReactionCellDependency: articleCardReactionCellDependency
          )
        }
      },
      configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
        guard let `self` = self else { return collectionView.emptyView(for: indexPath, kind: kind) }
        switch dataSource[indexPath] {
        case .articleCard:
          return self.articleSectionDelegate.background(
            collectionView: collectionView,
            kind: kind,
            indexPath: indexPath,
            sectionItems: dataSource[indexPath.section].articleCardSectionItems
          )
        }
      }
    )
  }


  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = 0xEDEDED.color
    self.view.addSubview(self.collectionView)
    self.collectionView.refreshControl = self.refreshControl

    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }


  // MARK: Binding

  func bind(reactor: ArticleListViewReactor) {
    // Action
    self.rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.refreshControl.rx.controlEvent(.valueChanged)
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    reactor.state.map { $0.isRefreshing }
      .distinctUntilChanged()
      .bind(to: self.refreshControl.rx.isRefreshing)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.sections }
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    // View
    self.collectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)
  }
}

extension ArticleListViewController: UICollectionViewDelegateFlexLayout {
  // section padding
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    paddingForSectionAt section: Int
  ) -> UIEdgeInsets {
    return .init(top: 10, left: 10, bottom: 10, right: 10)
  }

  // section spacing
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    verticalSpacingBetweenSectionAt section: Int,
    and nextSection: Int
  ) -> CGFloat {
    return 10
  }

  // item spacing
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    verticalSpacingBetweenItemAt indexPath: IndexPath,
    and nextIndexPath: IndexPath
  ) -> CGFloat {
    switch (self.dataSource[indexPath], self.dataSource[nextIndexPath]) {
    case let (.articleCard(item), .articleCard(nextItem)):
      return self.articleSectionDelegate.cellVerticalSpacing(
        sectionItem: item,
        nextSectionItem: nextItem
      )
    }
  }

  // item margin
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    marginForItemAt indexPath: IndexPath
  ) -> UIEdgeInsets {
    switch self.dataSource[indexPath] {
    case let .articleCard(item):
      return self.articleSectionDelegate.cellMargin(
        collectionView: collectionView,
        layout: collectionViewLayout,
        indexPath: indexPath,
        sectionItem: item
      )
    }
  }

  // item padding
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    paddingForItemAt indexPath: IndexPath
  ) -> UIEdgeInsets {
    switch self.dataSource[indexPath] {
    case let .articleCard(item):
      return self.articleSectionDelegate.cellPadding(
        layout: collectionViewLayout,
        indexPath: indexPath,
        sectionItem: item
      )
    }
  }

  // item size
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let maxWidth = collectionViewLayout.maximumWidth(forItemAt: indexPath)
    switch self.dataSource[indexPath] {
    case let .articleCard(item):
      return self.articleSectionDelegate.cellSize(maxWidth: maxWidth, sectionItem: item)
    }
  }
}
