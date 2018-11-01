//
//  ArticleViewSetion.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 07/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxDataSources

enum ArticleViewSection {
  case article(ArticleSectionReactor)
}

extension ArticleViewSection: SectionModelType {
  var items: [ArticleViewSectionItem] {
    switch self {
    case let .article(sectionReactor):
      return sectionReactor.currentState.sectionItems
    }
  }

  init(original: ArticleViewSection, items: [ArticleViewSectionItem]) {
    self = original
  }
}

typealias ArticleViewSectionItem = ArticleSectionReactor.SectionItem
