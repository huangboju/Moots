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

final class MainViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var hostLabel: UILabel!
  @IBOutlet weak var medalCountButton: UIButton!
  @IBOutlet weak var logoImageView: UIImageView!

  // MARK: - Properties
  lazy var slideInTransitioningDelegate = SlideInPresentationManager()
  private let dataStore = GamesDataStore()
  fileprivate var presentedGames: Games? {
    didSet {
      configurePresentedGames()
    }
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    presentedGames = nil
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let controller = segue.destination as? GamesTableViewController {
      if segue.identifier == "SummerSegue" {
        controller.gamesArray = dataStore.summer
        slideInTransitioningDelegate.direction = .left
      } else if segue.identifier == "WinterSegue" {
        controller.gamesArray = dataStore.winter
        slideInTransitioningDelegate.direction = .right
      }
      controller.delegate = self
      slideInTransitioningDelegate.disableCompactHeight = false
      controller.transitioningDelegate = slideInTransitioningDelegate
      controller.modalPresentationStyle = .custom
    } else if let controller = segue.destination as? MedalCountViewController {
      controller.medalCount = presentedGames?.medalCount
      slideInTransitioningDelegate.direction = .bottom
      slideInTransitioningDelegate.disableCompactHeight = true
      controller.transitioningDelegate = slideInTransitioningDelegate
      controller.modalPresentationStyle = .custom
    }
  }
}

// MARK: - Private
private extension MainViewController {

  func configurePresentedGames() {
    guard let presentedGames = presentedGames else {
      logoImageView.image = UIImage(named: "medals")
      hostLabel.text = nil
      yearLabel.text = nil
      medalCountButton.isHidden = true
      return
    }

    logoImageView.image = UIImage(named: presentedGames.flagImageName)
    hostLabel.text = presentedGames.host
    yearLabel.text = presentedGames.seasonYear
    medalCountButton.isHidden = false
  }
}

// MARK: - GamesTableViewControllerDelegate
extension MainViewController: GamesTableViewControllerDelegate {

  func gamesTableViewController(controller: GamesTableViewController, didSelectGames selectedGames: Games) {
    presentedGames = selectedGames
    dismiss(animated: true)
  }
}
