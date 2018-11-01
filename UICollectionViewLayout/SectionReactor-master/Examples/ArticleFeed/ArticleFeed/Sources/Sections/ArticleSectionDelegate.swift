//
//  ArticleSectionDelegate.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 09/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReusableKit
import SectionReactor
import UICollectionViewFlexLayout

final class ArticleSectionDelegate: SectionDelegateType {
  typealias SectionReactor = ArticleSectionReactor

  fileprivate enum Reusable {
    static let authorCell = ReusableCell<ArticleCardAuthorCell>()
    static let textCell = ReusableCell<ArticleCardTextCell>()
    static let reactionCell = ReusableCell<ArticleCardReactionCell>()
    static let commentCell = ReusableCell<ArticleCardCommentCell>()
    static let sectionBackgroundView = ReusableView<CollectionBorderedBackgroundView>()
    static let itemBackgroundView = ReusableView<CollectionBorderedBackgroundView>()
  }

  func registerReusables(to collectionView: UICollectionView) {
    collectionView.register(Reusable.authorCell)
    collectionView.register(Reusable.textCell)
    collectionView.register(Reusable.reactionCell)
    collectionView.register(Reusable.commentCell)
    collectionView.register(Reusable.sectionBackgroundView, kind: UICollectionElementKindSectionBackground)
    collectionView.register(Reusable.itemBackgroundView, kind: UICollectionElementKindItemBackground)
  }

  func cell(
    collectionView: UICollectionView,
    indexPath: IndexPath,
    sectionItem: SectionItem,
    articleCardAuthorCellDependency: ArticleCardAuthorCell.Dependency,
    articleCardTextCellDependency: ArticleCardTextCell.Dependency,
    articleCardReactionCellDependency: ArticleCardReactionCell.Dependency
  ) -> UICollectionViewCell {
    switch sectionItem {
    case let .author(cellReactor):
      let cell = collectionView.dequeue(Reusable.authorCell, for: indexPath)
      cell.dependency = articleCardAuthorCellDependency
      cell.reactor = cellReactor
      return cell

    case let .text(cellReactor):
      let cell = collectionView.dequeue(Reusable.textCell, for: indexPath)
      cell.dependency = articleCardTextCellDependency
      cell.reactor = cellReactor
      return cell

    case let .reaction(cellReactor):
      let cell = collectionView.dequeue(Reusable.reactionCell, for: indexPath)
      cell.dependency = articleCardReactionCellDependency
      cell.reactor = cellReactor
      return cell

    case let .comment(cellReactor):
      let cell = collectionView.dequeue(Reusable.commentCell, for: indexPath)
      cell.reactor = cellReactor
      return cell
    }
  }

  func background(
    collectionView: UICollectionView,
    kind: String,
    indexPath: IndexPath,
    sectionItems: [SectionItem]
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionBackground:
      let view = collectionView.dequeue(Reusable.sectionBackgroundView, kind: kind, for: indexPath)
      view.backgroundColor = .white
      view.borderedLayer?.borders = [.top, .bottom]
      return view

    case UICollectionElementKindItemBackground:
      let view = collectionView.dequeue(Reusable.itemBackgroundView, kind: kind, for: indexPath)
      switch sectionItems[indexPath.item] {
      case .comment:
        view.backgroundColor = 0xFAFAFA.color
        if self.isFirstComment(indexPath, in: sectionItems) {
          view.borderedLayer?.borders = [.top]
        } else if self.isLast(indexPath, in: collectionView) {
          view.borderedLayer?.borders = [.bottom]
        } else {
          view.borderedLayer?.borders = []
        }

      default:
        view.backgroundColor = .white
        view.borderedLayer?.borders = []
      }
      return view

    default:
      return collectionView.emptyView(for: indexPath, kind: kind)
    }
  }

  func cellVerticalSpacing(
    sectionItem: SectionItem,
    nextSectionItem: SectionItem
  ) -> CGFloat {
    switch (sectionItem, nextSectionItem) {
    case (.comment, .comment): return 0
    case (_, .comment): return 15
    case (.author, _): return 10
    case (.text, _): return 10
    case (.reaction, _): return 10
    case (.comment, _): return 10
    }
  }

  func cellMargin(
    collectionView: UICollectionView,
    layout: UICollectionViewFlexLayout,
    indexPath: IndexPath,
    sectionItem: SectionItem
  ) -> UIEdgeInsets {
    switch sectionItem {
    case .comment:
      let sectionPadding = layout.padding(forSectionAt: indexPath.section)
      let isLast = self.isLast(indexPath, in: collectionView)
      return UIEdgeInsets(
        top: 0,
        left: -sectionPadding.left,
        bottom: isLast ? -sectionPadding.bottom : 0,
        right: -sectionPadding.right
      )

    default:
      return .zero
    }
  }

  func cellPadding(
    layout: UICollectionViewFlexLayout,
    indexPath: IndexPath,
    sectionItem: SectionItem
  ) -> UIEdgeInsets {
    switch sectionItem {
    case .comment:
      let sectionPadding = layout.padding(forSectionAt: indexPath.section)
      return UIEdgeInsets(
        top: 10,
        left: sectionPadding.left,
        bottom: 10,
        right: sectionPadding.right
      )

    default:
      return .zero
    }
  }

  func cellSize(maxWidth: CGFloat, sectionItem: SectionItem) -> CGSize {
    switch sectionItem {
    case let .author(cellReactor):
      return Reusable.authorCell.class.size(width: maxWidth, reactor: cellReactor)

    case let .text(cellReactor):
      return Reusable.textCell.class.size(width: maxWidth, reactor: cellReactor)

    case let .reaction(cellReactor):
      return Reusable.reactionCell.class.size(width: maxWidth, reactor: cellReactor)

    case let .comment(cellReactor):
      return Reusable.commentCell.class.size(width: maxWidth, reactor: cellReactor)
    }
  }


  // MARK: Utils

  private func isFirstComment(_ indexPath: IndexPath, in sectionItems: [SectionItem]) -> Bool {
    let prevItemIndex = indexPath.item - 1
    guard sectionItems.indices.contains(prevItemIndex) else { return true }
    if case .comment = sectionItems[prevItemIndex] {
      return false
    } else {
      return true
    }
  }

  private func isLast(_ indexPath: IndexPath, in collectionView: UICollectionView) -> Bool {
    let lastItem = collectionView.numberOfItems(inSection: indexPath.section) - 1
    return indexPath.item == lastItem
  }
}
