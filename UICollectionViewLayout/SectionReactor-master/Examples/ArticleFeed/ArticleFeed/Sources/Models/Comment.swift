//
//  Comment.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import LoremIpsum
import RxSwift

struct Comment {
  enum Event {
    case create(Comment)
  }
  static let event = PublishSubject<Event>()

  var id: String
  var articleID: String
  var author: User
  var text: String

  static func random(articleID: String) -> Comment {
    return Comment(
      id: UUID().uuidString,
      articleID: articleID,
      author: .random(),
      text: LoremIpsum.sentence()
    )
  }
}
