/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

final class MedalCountViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var medalCountStackView: UIStackView!
  @IBOutlet var countryFlags: [UIImageView]!
  @IBOutlet var countryNames: [UILabel]!
  @IBOutlet var countryGolds: [UILabel]!
  @IBOutlet var countrySilvers: [UILabel]!
  @IBOutlet var countryBronzes: [UILabel]!

  // MARK: - Properties
  var medalCount: MedalCount!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Adding these constraints in code becuase storyboard froze when I tried adding the there
    medalCountStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      medalCountStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      medalCountStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    for (index, winner) in medalCount.winners.enumerated() {
      countryFlags[index].image = winner.flagImage
      countryNames[index].text = winner.country
      countryGolds[index].text = winner.goldString
      countrySilvers[index].text = winner.silverString
      countryBronzes[index].text = winner.bronzeString
    }

    setupGestureRecognizers()
  }
}

// MARK: - Private
private extension MedalCountViewController {

  func setupGestureRecognizers() {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
    view.addGestureRecognizer(tapRecognizer)
  }
}

// MARK: - GestureRecognizerSelectors
private extension MedalCountViewController {

  @objc dynamic func handleTap(gestureRecognizer: UITapGestureRecognizer) {
    dismiss(animated: true)
  }
}
