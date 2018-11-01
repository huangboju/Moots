//
//  ArticleCardTextCell.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class ArticleCardTextCell: BaseArticleCardSectionItemCell, View {

  // MARK: Constants

  fileprivate enum Metric {
  }

  fileprivate enum Font {
    static let textLabel = UIFont.systemFont(ofSize: 13)
  }

  fileprivate enum Color {
  }

  struct Dependency {
    let presentArticleViewController: () -> Void
  }


  // MARK: Properties

  var dependency: Dependency?


  // MARK: UI

  let textLabel: UILabel = UILabel().then {
    $0.numberOfLines = 0
    $0.font = Font.textLabel
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.textLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Binding

  func bind(reactor: ArticleCardTextCellReactor) {
    // State
    reactor.state.map { $0.text }
      .distinctUntilChanged()
      .bind(to: self.textLabel.rx.text)
      .disposed(by: self.disposeBag)

    // View
    reactor.state.map { _ in }
      .bind(to: self.rx.setNeedsLayout)
      .disposed(by: self.disposeBag)

    self.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.dependency?.presentArticleViewController()
      })
      .disposed(by: self.disposeBag)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.textLabel.frame = self.contentView.bounds
  }

  class func size(width: CGFloat, reactor: ArticleCardTextCellReactor) -> CGSize {
    let height = reactor.currentState.text.height(thatFitsWidth: width, font: Font.textLabel)
    return CGSize(width: width, height: height)
  }
}
