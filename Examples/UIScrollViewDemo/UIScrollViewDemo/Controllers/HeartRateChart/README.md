# 心率区间图表视图 (Heart Rate Interval Chart View)

这是一个使用 Swift UIKit 实现的心率区间对比图表视图。

## 功能特性

- ✅ 深色主题背景
- ✅ 水平虚线网格
- ✅ X轴标签（公里数：2, 3, 4, 5, 6）
- ✅ 图例显示（本次心率区间 - 红色，基准心率区间 - 灰色）
- ✅ 支持绘制多条数据线
- ✅ 自动缩放数据以适应图表高度

## 使用方法

### 基本使用

```swift
let chartView = HeartRateIntervalChartView()

// 设置本次心率数据（对应 2, 3, 4, 5, 6 公里）
chartView.setCurrentHeartRateData([120, 135, 140, 145, 150])

// 设置基准心率数据
chartView.setBenchmarkHeartRateData([110, 125, 130, 135, 140])

// 可选：自定义 X 轴标签
chartView.setXAxisLabels(["2", "3", "4", "5", "6"])
```

### 在 ViewController 中使用

```swift
import UIKit

class YourViewController: UIViewController {
    private let chartView = HeartRateIntervalChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // 设置数据
        chartView.setCurrentHeartRateData([120, 135, 140, 145, 150])
        chartView.setBenchmarkHeartRateData([110, 125, 130, 135, 140])
    }
}
```

## 自定义选项

### 修改颜色主题

在 `HeartRateIntervalChartView.swift` 中，你可以修改：

- `backgroundColor`: 图表背景色
- `gridLayer.strokeColor`: 网格线颜色
- 图例颜色：在 `setupLegend()` 方法中修改

### 调整布局

修改以下常量来调整布局：

```swift
private let padding: CGFloat = 40
private let bottomPadding: CGFloat = 60
private let topPadding: CGFloat = 20
private let leftPadding: CGFloat = 50
private let rightPadding: CGFloat = 20
```

## 文件说明

- `HeartRateIntervalChartView.swift`: 主要的图表视图类
- `HeartRateIntervalChartViewController.swift`: 示例 ViewController，展示如何使用图表视图

## 注意事项

- 数据数组的长度必须与 X 轴标签数量一致（默认 5 个）
- 图表会在 `layoutSubviews` 时自动重绘
- 如果数据为空，图表将只显示网格和轴，不绘制数据线
