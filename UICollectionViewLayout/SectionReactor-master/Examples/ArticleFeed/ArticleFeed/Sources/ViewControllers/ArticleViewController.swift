//
//  ArticleViewController.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 07/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import RxSwift
import UICollectionViewFlexLayout

final class ArticleViewController: UIViewController, View {

  // MARK: Properties

  var disposeBag = DisposeBag()
  lazy var dataSource = self.createDataSource()
  let articleSectionDelegate = ArticleSectionDelegate()
  private let articleCardAuthorCellDependencyFactory: (Article, UIViewController) -> ArticleCardAuthorCell.Dependency
  private let articleCardTextCellDependencyFactory: (Article, UIViewController) -> ArticleCardTextCell.Dependency
  private let articleCardReactionCellDependencyFactory: (Article, UIViewController) -> ArticleCardReactionCell.Dependency


  // MARK: UI

  let collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlexLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
  }


  // MARK: Initializing

  init(
    reactor: ArticleViewReactor,
    articleCardAuthorCellDependencyFactory: @escaping (Article, UIViewController) -> ArticleCardAuthorCell.Dependency,
    articleCardTextCellDependencyFactory: @escaping (Article, UIViewController) -> ArticleCardTextCell.Dependency,
    articleCardReactionCellDependencyFactory: @escaping (Article, UIViewController) -> ArticleCardReactionCell.Dependency
  ) {
    defer { self.reactor = reactor }
    self.articleCardAuthorCellDependencyFactory = articleCardAuthorCellDependencyFactory
    self.articleCardTextCellDependencyFactory = articleCardTextCellDependencyFactory
    self.articleCardReactionCellDependencyFactory = articleCardReactionCellDependencyFactory
    super.init(nibName: nil, bundle: nil)
    self.title = "Article"
    self.articleSectionDelegate.registerReusables(to: self.collectionView)
  }

  required convenience init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ArticleViewSection> {
    return .init(
      configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
        guard let `self` = self else {
          collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "__empty")
          return collectionView.dequeueReusableCell(withReuseIdentifier: "__empty", for: indexPath)
        }

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

        return self.articleSectionDelegate.cell(
          collectionView: collectionView,
          indexPath: indexPath,
          sectionItem: sectionItem,
          articleCardAuthorCellDependency: articleCardAuthorCellDependency,
          articleCardTextCellDependency: articleCardTextCellDependency,
          articleCardReactionCellDependency: articleCardReactionCellDependency
        )
      },
      configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
        guard let `self` = self else {
          collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: "__empty")
          return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "__empty", for: indexPath)
        }
        switch dataSource[indexPath.section] {
        case .article:
          return self.articleSectionDelegate.background(
            collectionView: collectionView,
            kind: kind,
            indexPath: indexPath,
            sectionItems: dataSource[indexPath.section].items
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

    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }


  // MARK: Binding

  func bind(reactor: ArticleViewReactor) {
    // State
    reactor.state.map { $0.authorName }
      .distinctUntilChanged()
      .map { $0.components(separatedBy: " ").first ?? $0 }
      .map { "\($0)'s Article" }
      .bind(to: self.rx.title)
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

extension ArticleViewController: UICollectionViewDelegateFlexLayout {
  // section padding
  func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, paddingForSectionAt section: Int ) -> UIEdgeInsets {
    return .init(top: 10, left: 10, bottom: 10, right: 10)
  }

  // section spacing
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, verticalSpacingBetweenSectionAt section: Int, and nextSection: Int) -> CGFloat {
    return 10
  }

  // item spacing
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    verticalSpacingBetweenItemAt indexPath: IndexPath,
    and nextIndexPath: IndexPath
  ) -> CGFloat {
    return self.articleSectionDelegate.cellVerticalSpacing(
      sectionItem: self.dataSource[indexPath],
      nextSectionItem: self.dataSource[nextIndexPath]
    )
  }

  // item margin
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    marginForItemAt indexPath: IndexPath
  ) -> UIEdgeInsets {
    return self.articleSectionDelegate.cellMargin(
      collectionView: collectionView,
      layout: collectionViewLayout,
      indexPath: indexPath,
      sectionItem: self.dataSource[indexPath]
    )
  }

  // item padding
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewFlexLayout,
    paddingForItemAt indexPath: IndexPath
  ) -> UIEdgeInsets {
    return self.articleSectionDelegate.cellPadding(
      layout: collectionViewLayout,
      indexPath: indexPath,
      sectionItem: self.dataSource[indexPath]
    )
  }

  // item size
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxWidth = collectionViewLayout.maximumWidth(forItemAt: indexPath)
    return self.articleSectionDelegate.cellSize(
      maxWidth: maxWidth,
      sectionItem: self.dataSource[indexPath]
    )
  }
}
