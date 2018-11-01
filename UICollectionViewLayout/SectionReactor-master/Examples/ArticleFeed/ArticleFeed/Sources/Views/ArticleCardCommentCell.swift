//
//  ArticleCardCommentCell.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class ArticleCardCommentCell: BaseArticleCardSectionItemCell, View {

  // MARK: Constants

  fileprivate enum Metric {
    static let avatarViewSize = 20.f
    static let nameLabelLeft = 6.f
    static let textLabelLeft = 4.f
  }

  fileprivate enum Font {
    static let nameLabel = UIFont.boldSystemFont(ofSize: 12)
    static let textLabel = UIFont.systemFont(ofSize: 12)
  }

  fileprivate enum Color {
  }


  // MARK: UI

  let avatarView: UIImageView = UIImageView().then {
    $0.backgroundColor = 0xCCCCCC.color
    $0.layer.cornerRadius = Metric.avatarViewSize / 2
    $0.clipsToBounds = true
  }
  let nameLabel = UILabel().then { $0.font = Font.nameLabel }
  let textLabel = UILabel().then { $0.font = Font.textLabel }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.avatarView)
    self.contentView.addSubview(self.nameLabel)
    self.contentView.addSubview(self.textLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Binding

  func bind(reactor: ArticleCardCommentCellReactor) {
    // State
    reactor.state.map { $0.name }
      .distinctUntilChanged()
      .bind(to: self.nameLabel.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.text }
      .distinctUntilChanged()
      .bind(to: self.textLabel.rx.text)
      .disposed(by: self.disposeBag)

    // View
    reactor.state.map { _ in }
      .bind(to: self.rx.setNeedsLayout)
      .disposed(by: self.disposeBag)
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.avatarView.width = Metric.avatarViewSize
    self.avatarView.height = Metric.avatarViewSize

    self.nameLabel.sizeToFit()
    self.nameLabel.left = self.avatarView.right + Metric.nameLabelLeft
    self.nameLabel.centerY = self.avatarView.centerY - 1

    self.textLabel.sizeToFit()
    self.textLabel.left = self.nameLabel.right + Metric.textLabelLeft
    self.textLabel.centerY = self.nameLabel.centerY
    self.textLabel.width = min(self.textLabel.width, self.contentView.width - self.textLabel.left)
  }

  class func size(width: CGFloat, reactor: ArticleCardCommentCellReactor) -> CGSize {
    return CGSize(width: width, height: Metric.avatarViewSize)
  }
}
