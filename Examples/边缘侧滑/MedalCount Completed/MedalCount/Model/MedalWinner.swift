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

struct MedalWinner {

  // MARK: - Properties
  let country: String
  let gold: Int
  let silver: Int
  let bronze: Int

  // MARK: - Initializers
  init(dictionary: [String: AnyObject]) {
    self.country = dictionary["country"] as! String
    self.gold = dictionary["gold"] as! Int
    self.silver = dictionary["silver"] as! Int
    self.bronze = dictionary["bronze"] as! Int
  }
}

// MARK: - Internal
extension MedalWinner {

  var flagImage: UIImage? {
    let imageName = country.lowercased().replacingOccurrences(of: " ", with: "_")
    return UIImage(named: imageName)
  }

  var goldString: String {
    return "\(gold)"
  }

  var silverString: String {
    return "\(silver)"
  }

  var bronzeString: String {
    return "\(bronze)"
  }
}

// MARK: - CustomStringConvertible
extension MedalWinner: CustomStringConvertible {

  var description: String {
    return "\(country) - Gold:\(gold), Silver:\(silver), Bronze:\(bronze)"
  }
}
