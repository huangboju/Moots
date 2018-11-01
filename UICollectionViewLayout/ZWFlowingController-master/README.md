# ZWFlowingController
## 流水UI布局，板块化地随性所欲定制UI流和事件流(Easily Flowing UI, deal with data source and UI flow conveniently)
### 创作灵感（Creative inspiration）
#### 1.很多APP的首页都是固定的UI（如搜索栏+轮播图+9宫格+广告等）且内容众多需要支持上下滑动
#### 2.产品汪一言不合就经常变更需求（根据监控用户使用率和偏好，需要变化这些固定UI的位置或者图片内容）
#### In order to creat and  change such all kinds of UI cenveniently reference to users' preferences and Product manager‘s requirements.
### 综上所述
##### 希望多注册点各种各样的UI模块放入应用，产品汪需要改变就快速改变，最好能通过服务器设置，模块化UI,更加灵活。
##### 更好利用重用机制，全局为CollocationView.整个界面的各个view（如搜索栏+轮播图+9宫格+广告等），根据板块的不同分类放入各个CollectionCell中注册放入缓存池中，需要则去寻找调用。
#### Make the different UI  register into each CollectionCells by the classification of different function，easily to use each UI and  deal with data source  in one interface.
### 流水UI布局实例
### Show some Flowing UI
  ![image](https://github.com/liunianhuaguoyanxi/ZWFlowingController/blob/master/Gif/FlowUI.gif)
### 详情都在demo中，若能给大家带来帮助，记得star🙂
### All in the demo,wish it can help you!
