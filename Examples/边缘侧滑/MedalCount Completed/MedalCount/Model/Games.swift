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

import Foundation

struct Games {
  
  // MARK: - Properties
  let year: String
  let host: String
  let country: String
  let isSummer: Bool
  let medalCount: MedalCount
  
  var seasonYear: String {
    return "\(season.capitalized) \(year)"
  }
  
  var flagImageName: String {
    let name = country.lowercased().replacingOccurrences(of: " ", with: "_")
    return "\(name)_large"
  }
  
  private var season: String {
    return isSummer ? "summer" : "winter"
  }
  
  // MARK: - Initializers
  init(dictionary: [String: AnyObject]) {
    self.year = dictionary["year"] as! String
    self.host = dictionary["host"] as! String
    self.country = dictionary["country"] as! String
    self.isSummer = dictionary["isSummer"] as! Bool
    
    let rawMedals = dictionary["medal_count"] as! [[String: AnyObject]]
    self.medalCount = MedalCount(array: rawMedals)
  }
}

// MARK: - CustomStringConvertible
extension Games: CustomStringConvertible {
  
  var description: String {
    return "\(seasonYear) - \(host)\nMedal Winners:\n\(medalCount)"
  }
}
