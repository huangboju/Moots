# SectionReactor

![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/SectionReactor.svg)](https://cocoapods.org/pods/SectionReactor)
[![Build Status](https://travis-ci.org/devxoul/SectionReactor.svg?branch=master)](https://travis-ci.org/devxoul/SectionReactor)
[![Codecov](https://img.shields.io/codecov/c/github/devxoul/SectionReactor.svg)](https://codecov.io/gh/devxoul/SectionReactor)

SectionReactor is a ReactorKit extension for managing table view and collection view sections with RxDataSources.

## Getting Started

This is a draft. I have no idea how would I explain this concept 🤦‍♂️ It would be better to see the [ArticleFeed](https://github.com/devxoul/SectionReactor/tree/master/Examples/ArticleFeed) example.

**ArticleViewSection.swift**

```swift
enum ArticleViewSection: SectionModelType {
  case article(ArticleSectionReactor)

  var items: [ArticleViewSection] {
    switch self {
    case let .article(sectionReactor):
      return sectionReactor.currentState.sectionItems
    }
  }
}
```

**ArticleSectionReactor.swift**

```swift
import SectionReactor

final class ArticleSectionItem: SectionReactor {
  struct State: SectionReactorState {
    var sectionItems: [ArticleSectionItem]
  }
}
```

**ArticleListViewReactor.swift**

```swift
final class ArticleListViewReactor: Reactor {
  struct State {
    var articleSectionReactors: [ArticleSectionReactor]
    var sections: [ArticleViewSection] {
      return self.articleSectionReactors.map(ArticleViewSection.article)
    }
  }

  func transform(state: Observable<State>) -> Observable<State> {
    return state.merge(sections: [
      { $0.articleSectionReactors },
    ])
  }
}
```

## Dependencies

* [ReactorKit](https://github.com/ReactorKit/ReactorKit) >= 0
* [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) >= 2.0

## Installation

```ruby
pod 'SectionReactor'
```

## License

SectionReactor is under MIT license. See the [LICENSE](LICENSE) for more info.
