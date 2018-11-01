//
//  ArticleCardAuthorCell.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class ArticleCardAuthorCell: BaseArticleCardSectionItemCell, View {

  // MARK: Constants

  fileprivate enum Metric {
    static let avatarViewSize = 30.f
    static let nameLabelLeft = 10.f
  }

  fileprivate enum Font {
    static let nameLabel = UIFont.boldSystemFont(ofSize: 13)
  }

  fileprivate enum Color {
  }

  struct Dependency {
    let presentArticleViewController: () -> Void
  }


  // MARK: Properties

  var dependency: Dependency?


  // MARK: UI

  let avatarView: UIImageView = UIImageView().then {
    $0.backgroundColor = 0xCCCCCC.color
    $0.layer.cornerRadius = Metric.avatarViewSize / 2
    $0.clipsToBounds = true
  }
  let nameLabel: UILabel = UILabel().then {
    $0.font = Font.nameLabel
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.avatarView)
    self.contentView.addSubview(self.nameLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Binding

  func bind(reactor: ArticleCardAuthorCellReactor) {
    // State
    reactor.state.map { $0.name }
      .distinctUntilChanged()
      .bind(to: self.nameLabel.rx.text)
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

    self.avatarView.width = Metric.avatarViewSize
    self.avatarView.height = Metric.avatarViewSize

    self.nameLabel.sizeToFit()
    self.nameLabel.left = self.avatarView.right + Metric.nameLabelLeft
    self.nameLabel.centerY = self.avatarView.centerY
  }

  class func size(width: CGFloat, reactor: ArticleCardAuthorCellReactor) -> CGSize {
    return CGSize(width: width, height: Metric.avatarViewSize)
  }
}
