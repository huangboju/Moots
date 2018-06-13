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

protocol GamesTableViewControllerDelegate: class {
  func gamesTableViewController(controller: GamesTableViewController, didSelectGames selectedGames: Games)
}

final class GamesTableViewController: UITableViewController {

  // MARK: - Properties
  weak var delegate: GamesTableViewControllerDelegate?
  var gamesArray: [Games]!
}

// MARK: - UITableViewDataSource
extension GamesTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return gamesArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GamesCell", for: indexPath) as! GamesTableViewCell

    let games = gamesArray[indexPath.row]
    cell.hostLabel.text = games.host
    cell.yearLabel.text = games.year
    cell.logoImageView.image = UIImage(named: games.flagImageName)

    return cell
  }
}

// MARK: - UITableViewDelegate
extension GamesTableViewController {

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedGames = gamesArray[indexPath.row]
    delegate?.gamesTableViewController(controller: self, didSelectGames: selectedGames)
  }
}
