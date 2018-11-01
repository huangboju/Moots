//
//  Author.swift
//  ArticleFeed
//
//  Created by Suyeol Jeon on 01/09/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import LoremIpsum

struct User {
  var id: String
  var name: String

  static func random() -> User {
    return User(id: UUID().uuidString, name: LoremIpsum.name())
  }
}
