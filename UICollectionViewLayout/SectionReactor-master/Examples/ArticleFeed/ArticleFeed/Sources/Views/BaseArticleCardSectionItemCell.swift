//
//  ArticleCardSectionItemCell.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 07/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class BaseArticleCardSectionItemCell: UICollectionViewCell {

  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: UI

  let tapGestureRecognizer = UITapGestureRecognizer()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addGestureRecognizer(self.tapGestureRecognizer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension Reactive where Base: BaseArticleCardSectionItemCell {
  var tap: ControlEvent<Void> {
    let source = self.base.tapGestureRecognizer.rx.event.map { _ in }
    return ControlEvent(events: source)
  }
}
