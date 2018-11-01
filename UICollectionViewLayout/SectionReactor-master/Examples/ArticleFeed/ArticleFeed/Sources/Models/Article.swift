//
//  Article.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import LoremIpsum

struct Article {
  var id: String
  var author: User
  var text: String?
  var comments: [Comment]

  static func random() -> Article {
    let id = UUID().uuidString
    let comments: [Comment] = (0..<Int(arc4random() % 3)).map { _ in Comment.random(articleID: id) }
    return Article(id: id, author: .random(), text: LoremIpsum.paragraph(), comments: comments)
  }
}
