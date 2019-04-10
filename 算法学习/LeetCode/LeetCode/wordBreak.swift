
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
    let length = s.count
    //dp[i]表示
    var dp = Array(repeating: false, count: length + 1)
    dp[0] = true;
    
    for i in 0 ... length {
        for j in 0 ..< i {
            let sub = s[j..<i]
            if (dp[j] && wordDict.contains(String(sub))) {
                dp[i] = true
                break
            }
        }
    }
    return dp[length]
}
