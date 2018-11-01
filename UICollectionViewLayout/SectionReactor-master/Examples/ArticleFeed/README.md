# ArticleFeed

![articlefeed](https://user-images.githubusercontent.com/931655/30236985-8c0c0db4-94f5-11e7-8598-f33e06bbc7c1.png)

The each parts of the screenshot are separated cells. A single section item contains partial information of the article. A single section contains complete information of an article. Each cell and reactor can have its corresponding reactor.

```
.---- ArticleListViewController -----.    ArticleListViewReactor ([Article])
|                                    |    |
| .-----section 0------------------. |    |- SectionReactor (Article)
| | [0, 0] ArticleCardAuthorCell   | |    |  |- CellReactor (Article.author)
| | [0, 1] ArticleCardTextCell     | |    |  |- CellReactor (Article.text)
| | [0, 2] ArticleCardReactionCell | |    |  |- CellReactor (Article.id)
| | [0, 3] ArticleCardCommentCell  | |    |  |- CellReactor (Article.comments[0])
| | [0, 4] ArticleCardCommentCell  | |    |  '- CellReactor (Article.comments[1])
| |                                | |    |
| |-----section 1------------------| |    |- SectionReactor (Article)
| | [1, 0] ArticleCardAuthorCell   | |    |  |- CellReactor (Article.author)
| | [1, 1] ArticleCardTextCell     | |    |  |- CellReactor (Article.text)
| | [1, 2] ArticleCardReactionCell | |    |  |- CellReactor (Article.id)
| | [1, 3] ArticleCardCommentCell  | |    |  |- CellReactor (Article.comments[0])
| | [1, 4] ArticleCardCommentCell  | |    |  '- CellReactor (Article.comments[1])
| |                                | |    |
| |-----section 2------------------| |    '- SectionReactor (Article)
| | [2, 0] ArticleCardAuthorCell   | |       |- CellReactor (Article.author)
| | [2, 1] ArticleCardTextCell     | |       '- CellReactor (Article.text)
| |              ...               | |
| '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' |
|                                    |
'------------------------------------'
```

## How to Run

```swift
$ pod install
$ open ArticleFeed.xcworkspace
```
