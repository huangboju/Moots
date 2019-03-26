func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
    let length = s.count
    //dp[i]表示
    var dp = Array(repeating: false, count: length + 1)
    dp[0] = true;
    
    for i in 0 ... length {
        for j in 0 ..< i {
            let sub = s[j..<i]
            if (dp[j] && wordDict.contains(sub)) {
                dp[i] = true
                break
            }
        }
    }
    return dp[length]
}


