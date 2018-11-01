#if os(iOS) || os(tvOS)
import UIKit

public extension UICollectionView {
  func emptyCell(for indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = "SectionReactor.UICollectionView.emptyCell"
    self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
    let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    cell.isHidden = true
    return cell
  }

  func emptyView(for indexPath: IndexPath, kind: String) -> UICollectionReusableView {
    let identifier = "SectionReactor.UICollectionView.emptyView"
    self.register(UICollectionReusableView.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    let view = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    view.isHidden = true
    return view
  }
}

public extension UITableView {
  func emptyCell(for indexPath: IndexPath) -> UITableViewCell {
    let identifier = "SectionReactor.UITableView.emptyCell"
    self.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    cell.isHidden = true
    return cell
  }
}
#endif
