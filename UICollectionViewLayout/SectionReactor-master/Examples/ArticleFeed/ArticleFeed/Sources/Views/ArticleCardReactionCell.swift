//
//  ArticleCardReactionCell.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class ArticleCardReactionCell: BaseArticleCardSectionItemCell, View {

  // MARK: Constants

  fileprivate enum Metric {
  }

  fileprivate enum Font {
    static let commentButtonTitle = UIFont.systemFont(ofSize: 13)
  }

  fileprivate enum Color {
  }

  struct Dependency {
    let presentArticleViewController: () -> Void
  }


  // MARK: Properties

  var dependency: Dependency?


  // MARK: UI

  let commentButton: UIButton = UIButton(type: .system).then {
    $0.titleLabel?.font = Font.commentButtonTitle
    $0.setTitle("Create a comment", for: .normal)
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.commentButton)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Binding

  func bind(reactor: ArticleCardReactionCellReactor) {
    // Action
    self.commentButton.rx.tap
      .map { Reactor.Action.createComment }
      .bind(to: reactor.action)
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
    self.commentButton.sizeToFit()
    self.commentButton.centerY = self.contentView.height / 2
  }

  class func size(width: CGFloat, reactor: ArticleCardReactionCellReactor) -> CGSize {
    return CGSize(width: width, height: snap(Font.commentButtonTitle.lineHeight))
  }
}
