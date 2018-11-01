uicollectionview-gridlayout
===========================

Simple grid layout for UICollectionView with sticky headers.

See the included sample projects.

Requires [TLIndexPathTools][1] for internal implementation. The collection view itself does not necessarily need to use TLIndexPathTools, but the sample projects do.

##Note about iOS7
The original intent of this library was to fix a multitude of animation issues with `UICollectionViewFlowLayout` and batch updates in iOS6. The "Expand" and "Sort & Filter" sample projects illustrate two such issues with side-by-side comparisons of `UICollectionViewFlowLayout` and `VCollectionViewGridLayout`. Note that in iOS7, both of these sample projects work correctly with `UICollectionViewFlowLayout`, so this library may not provide any benefit over `UICollectionViewFlowLayout` beyond sticky headers.

##Installation

Use CocoaPods or install manually:

1. Copy `VCollectionViewGridLayout.*` into your project
2. Install [TLIndexPathTools][1].

## Examples

Be sure to open the workspace for each example rather than the project.

[1]:https://github.com/wtmoose/TLIndexPathTools
