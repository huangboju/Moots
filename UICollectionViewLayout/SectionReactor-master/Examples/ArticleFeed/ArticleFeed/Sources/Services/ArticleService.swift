//
//  ArticleService.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

protocol ArticleServiceType {
  func articles() -> Observable<[Article]>
}

final class ArticleService: ArticleServiceType {
  func articles() -> Observable<[Article]> {
    return Observable
      .just((0..<30).map { _ in Article.random() })
      .delay(0.7, scheduler: ConcurrentDispatchQueueScheduler(qos: DispatchQoS.utility))
  }
}
