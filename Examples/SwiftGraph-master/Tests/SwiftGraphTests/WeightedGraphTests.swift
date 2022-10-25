//
//  WeightedGraphTests.swift
//  SwiftGraphTests
//
//  Created by Ferran Pujol Camins on 05/03/2019.
//  Copyright © 2019 Oak Snow Consulting. All rights reserved.
//

import XCTest
import SwiftGraph

class WeightedGraphTests: XCTestCase {

    func testEdgeExists() {
        let g = WeightedGraph<String, String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", weight: "AB", directed: true)
        XCTAssertTrue(g.edgeExists(from: "A", to: "B"))
        XCTAssertFalse(g.edgeExists(from: "B", to: "A"))
        XCTAssertTrue(g.edgeExists(from: "A", to: "B", withWeight: "AB"))
        XCTAssertFalse(g.edgeExists(from: "B", to: "A", withWeight: "AB"))
        XCTAssertFalse(g.edgeExists(from: "B", to: "A", withWeight: "X"))
        XCTAssertFalse(g.edgeExists(from: "A", to: "Y", withWeight: "AB"))
        XCTAssertFalse(g.edgeExists(from: "X", to: "Y", withWeight: "AB"))
    }

    func testWeights() {
        let g = WeightedGraph<String, String>(
            vertices: ["A", "B", "C"]
        )
        g.addEdge(from: "A", to: "B", weight: "AB", directed: true)
        g.addEdge(from: "B", to: "C", weight: "BC", directed: true)
        g.addEdge(from: "A", to: "B", weight: "AB2", directed: true)
        g.addEdge(from: "B", to: "C", weight: "BC", directed: true)

        XCTAssertEqual(g.edgeCount, 4, "Wrong number of edges.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "A", to: "B"),
            ["AB", "AB2"]
        ), "Edges from same vertices but different value must both be in the graph.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "B", to: "C"),
            ["BC", "BC"]
        ), "Duplicated edge 'BC' must appear twice.")
    }
    
    func testSku() {
        let graph = WeightedGraph<String, Set<String>>(vertices: ["红色", "紫色", "套餐一", "套餐二", "64G", "128G", "256G"])
        
        graph.addEdge(from: "紫色", to: "红色", weight: ["紫色,红色"])
        graph.addEdge(from: "紫色", to: "套餐一", weight: ["紫色,套餐一,64G", "紫色,套餐一,128G"])
        graph.addEdge(from: "紫色", to: "套餐二", weight: ["紫色,套餐二,128G"])
        graph.addEdge(from: "紫色", to: "64G", weight: ["紫色,套餐一,64G"])
        graph.addEdge(from: "紫色", to: "128G", weight: ["紫色,套餐一,128G"])
        
        
        graph.addEdge(from: "红色", to: "紫色", weight: ["紫色,红色"])
        graph.addEdge(from: "红色", to: "套餐二", weight: ["红色,套餐二,256G"])
        graph.addEdge(from: "红色", to: "256G", weight: ["红色,套餐二,256G"])
        
        graph.addEdge(from: "套餐一", to: "紫色", weight: ["紫色,套餐一,64G", "紫色,套餐一,128G"])
        graph.addEdge(from: "套餐一", to: "套餐二", weight: ["套餐一,套餐二"])
        graph.addEdge(from: "套餐一", to: "64G", weight: ["紫色,套餐一,64G"])
        graph.addEdge(from: "套餐一", to: "128G", weight: ["紫色,套餐一,128G"])
        
        print("\n\n")
        guard let arr1 = graph.edgesForVertex("紫色") else {
            return
        }
        let set1 = Set(arr1.map { $0.weight })
        print("set1:", set1)
        guard let arr2 = graph.edgesForVertex("套餐一") else {
            return
        }
        let set2 = Set(arr2.map { $0.weight })
        print("set2:", set2)
        print(set2.intersection(set1))
        print("\n")
        guard let arr3 = graph.edgesForVertex("64G") else {
            return
        }
        let set3 = Set(arr3.map { $0.weight })
        print("set3:", set3)
        print(set1.intersection(set2).intersection(set3))
        print("\n\n")
    }
}
