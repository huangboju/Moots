
extension String {
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }

    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }

    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}

// s = "leetcode", wordDict = ["leet", "code"]
func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
    var result = Array(repeating: false, count: s.count + 1)
    result[0] = true
    let wordSet = Set(wordDict)
    for i in 1 ... s.count {
        for j in 0 ..< i {
            if result[j] && wordSet.contains(String(s[j..<i])) {
                result[i] = true
                break
            }
        }
    }
    return result[s.count]
}
