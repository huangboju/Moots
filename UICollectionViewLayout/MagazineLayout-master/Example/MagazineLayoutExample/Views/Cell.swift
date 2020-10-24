// Created by bryankeller on 11/30/18.
// Copyright © 2018 Airbnb, Inc.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import MagazineLayout
import UIKit

final class Cell: MagazineLayoutCollectionViewCell {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    label = UILabel(frame: .zero)

    super.init(frame: frame)

    label.font = UIFont.systemFont(ofSize: 24)
    label.textColor = .white
    label.numberOfLines = 0
    contentView.addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
      label.topAnchor.constraint(equalTo: contentView.topAnchor),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  override func prepareForReuse() {
    super.prepareForReuse()

    label.text = nil
    contentView.backgroundColor = nil
  }

  func set(_ itemInfo: ItemInfo) {
    label.text = itemInfo.text
    contentView.backgroundColor = itemInfo.color
  }

  // MARK: Private

  private let label: UILabel

}
