//
//  CBCNodeListViewController.swift
//  Lumia
//
//  Created by xiAo_Ju on 2020/1/20.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

// https://github.com/material-foundation/cocoapods-catalog-by-convention

/**
A node describes a single navigable page in the Catalog by Convention.

A node either has children or it is an example.

- If a node has children, then the node should be represented by a list of some sort.
- If a node is an example, then the example controller can be instantiated with
  createExampleViewController.
*/
class CBCNode {
    /** The title for this node. */
    private(set) var title: String

    /** The children of this node. */
    var children: [CBCNode] = []

    /**
     The example you wish to debug as the initial view controller.
     If there are multiple examples with catalogIsDebug returning YES
     the debugLeaf will hold the example that has been iterated on last
     in the hierarchy tree.
     */
    var debugLeaf: CBCNode?

    /**
     This NSDictionary holds all the metadata related to this CBCNode.
     If it is an example noe, a primary demo, related info,
     if presentable in Catalog, etc.
     */
    var metadata: [String: Any]?

    /** Returns true if this is an example node. */
    var isExample: Bool {
        return exampleClass != nil
    }

    /**
     Returns YES if this the primary demo for this component.

     Can only return true if isExample also returns YES.
     */
    var isPrimaryDemo: Bool {
        guard let v = metadata?[CBCIsPrimaryDemo] as? Bool else {
            return false
        }
        return v
    }

    /** Returns YES if this is a presentable example.  */
    var isPresentable: Bool {
        guard let v = metadata?[CBCIsPresentable] as? Bool else {
            return false
        }
        return v
    }

    /** Returns String representation of exampleViewController class name if it exists */
    var exampleViewControllerName: String? {
        assert(exampleClass != nil, "This node has no associated example.")
        return exampleClass?.description()
    }

    /**
     Returns an instance of a UIViewController for presentation purposes.

     Check that isExample returns YES before invoking.
     */
    var createExampleViewController: UIViewController {
        assert(exampleClass != nil, "This node has no associated example.")
        return CBCViewControllerFromClass(exampleClass!, metadata!)
    }

    /**
     Returns a description of the example.

     Check that isExample returns YES before invoking.
     */
    var exampleDescription: String? {
        guard let description = metadata?[CBCDescription] as? String else {
            return nil
        }
        return description
    }

    /** Returns a link to related information for the example. */
    var exampleRelatedInfo: URL? {
        guard let relatedInfo = metadata?[CBCRelatedInfo] as? URL else {
            return nil
        }
        return relatedInfo
    }
    
    fileprivate var map: [String: Any] = [:]
    
    fileprivate var exampleClass: UIViewController.Type?
    
    init(title: String) {
        self.title = title
        CBCFixViewDebuggingIfNeeded()
    }
    
    fileprivate func add(_ child: CBCNode) {
        map[child.title] = child
        children.append(child)
    }
    
    fileprivate func finalizeNode() {
        children = children.sorted(by: { $0.title == $1.title })
    }
}

public class CBCNodeListViewController: UIViewController {
    /** Initializes a CBCNodeViewController instance with a non-example node. */
    init(node: CBCNode) {
        super.init(nibName: nil, bundle: nil)
        self.node = node

        title = node.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    /** The node that this view controller must represent. */
    private(set) var node: CBCNode!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let selectedRow = tableView.indexPathForSelectedRow else { return }
        transitionCoordinator?.animate(alongsideTransition: { context in
            self.tableView.deselectRow(at: selectedRow, animated: true)
        }, completion: { context in
            if context.isCancelled {
                self.tableView.selectRow(at: selectedRow, animated: false, scrollPosition: .none)
            }
        })
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }
}

extension CBCNodeListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return node.children.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = node.children[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell;
    }
}

extension CBCNodeListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = self.node.children[indexPath.row]
        var viewController: UIViewController? = CBCNodeListViewController(node: node)
        if node.isExample {
          viewController = node.createExampleViewController
        }
        show(viewController!, sender: nil)
    }
}

func CBCAddNodeFromBreadCrumbs(_ tree: CBCNode, _ breadCrumbs: [String], _ aClass: UIViewController.Type, _ metadata: [String: Any]) {
    // Walk down the navigation tree one breadcrumb at a time, creating nodes along the way.

    var node = tree
    for (ix, title) in breadCrumbs.enumerated() {
        let isLastCrumb = ix == breadCrumbs.count - 1

      // Don't walk the last crumb

        if let n = node.map[title] as? CBCNode, !isLastCrumb {
            node = n
            continue
        }

        let child = CBCNode(title: title)
        node.add(child)
        child.metadata = metadata

        if child.metadata?[CBCIsPrimaryDemo] as? Bool ?? false {
            node.metadata = child.metadata
        }
        
        if child.metadata?[CBCIsDebug] as? Bool ?? false {
            tree.debugLeaf = child
        }
        node = child
    }

    node.exampleClass = aClass
}

func CBCCreateTreeWithOnlyPresentable(_ onlyPresentable: Bool) -> CBCNode {
    let allClasses = CBCGetAllCompatibleClasses()
    let filteredClasses = allClasses.filter { objc in
        let metadata = CBCCatalogMetadataFromClass(objc)
        let breadcrumbs = metadata[CBCBreadcrumbs]
        var validObject =  breadcrumbs != nil && (breadcrumbs as? [Any] != nil)
        if onlyPresentable {
            validObject = validObject && (metadata[CBCIsPresentable] as? Bool ?? false)
        }
        return validObject
    }

    let tree = CBCNode(title: "Root")
    for aClass in filteredClasses {
      // Each example view controller defines its own breadcrumbs (metadata[CBCBreadcrumbs]).
        let metadata = CBCCatalogMetadataFromClass(aClass)
        let breadCrumbs = metadata[CBCBreadcrumbs] as? [Any]
        if (breadCrumbs?.first as? String) != nil {
            CBCAddNodeFromBreadCrumbs(tree, breadCrumbs as! [String], aClass, metadata);
        } else if (breadCrumbs?.first as? [String]) != nil {
            for parallelBreadCrumb in breadCrumbs! {
                CBCAddNodeFromBreadCrumbs(tree, parallelBreadCrumb as! [String], aClass, metadata)
            }
      }
    }

    // Perform final post-processing on the nodes.
    var queue = [tree]
    while queue.count > 0 {
        let node = queue.first
        queue.remove(at: 0)
        queue.append(contentsOf: node!.children)
        node?.finalizeNode()
    }

    return tree
}

func CBCCreateNavigationTree() -> CBCNode {
  return CBCCreateTreeWithOnlyPresentable(false)
}

func CBCCreatePresentableNavigationTree() -> CBCNode {
  return CBCCreateTreeWithOnlyPresentable(true)
}
