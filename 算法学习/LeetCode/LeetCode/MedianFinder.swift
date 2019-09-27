class MedianFinder {

    var values: [Int] = []

    init() {
        
    }
    
    func addNum(_ num: Int) {
        if values.isEmpty {
            values.append(num)
            return
        }
        
        var left = 0
        var right = values.count
        while left < right {
            let mid = left + (right - left) / 2
            if values[mid] < num {
                left = mid + 1
            } else if values[mid] == num {
                left = mid
                break
            } else {
                right = mid
            }
        }
        
        values.insert(num, at: left)
    }

    func findMedian() -> Double {
        if values.isEmpty {
            return 0
        }

        let mid = values.count / 2

        if values.count % 2 == 1 {
            return Double(values[mid])
        } else {
            return Double(values[mid] + values[mid - 1]) / 2
        }
    }
}
