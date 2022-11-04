#if !canImport(ObjectiveC)
import XCTest

extension ConstructorsPerformanceTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConstructorsPerformanceTests = [
        ("testCompleteGraphConstructor", testCompleteGraphConstructor),
        ("testCycleUniqueElementsHashableConstructor", testCycleUniqueElementsHashableConstructor),
        ("testCycleUnweightedGraphConstructor", testCycleUnweightedGraphConstructor),
        ("testCycleUnweightedUniqueElementsGraphConstructor", testCycleUnweightedUniqueElementsGraphConstructor),
        ("testPathUnweightedGraphConstructor", testPathUnweightedGraphConstructor),
        ("testPathUnweightedUniqueElementsGraphConstructor", testPathUnweightedUniqueElementsGraphConstructor),
        ("testPathUnweightedUniqueElementsGraphHashableConstructor", testPathUnweightedUniqueElementsGraphHashableConstructor),
        ("testStarGraphConstructor", testStarGraphConstructor),
    ]
}

extension SearchPerformanceTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SearchPerformanceTests = [
        ("testBfsInCompleteGraphWithGoalTest", testBfsInCompleteGraphWithGoalTest),
        ("testBfsInCompleteGraphWithGoalTestByIndex", testBfsInCompleteGraphWithGoalTestByIndex),
        ("testBfsInPath", testBfsInPath),
        ("testBfsInPathByIndex", testBfsInPathByIndex),
        ("testBfsInPathWithGoalTest", testBfsInPathWithGoalTest),
        ("testBfsInPathWithGoalTestByIndex", testBfsInPathWithGoalTestByIndex),
        ("testBfsInStarGraph", testBfsInStarGraph),
        ("testBfsInStarGraphByIndex", testBfsInStarGraphByIndex),
        ("testBfsInStarGraphWithGoalTest", testBfsInStarGraphWithGoalTest),
        ("testBfsInStarGraphWithGoalTestByIndex", testBfsInStarGraphWithGoalTestByIndex),
        ("testDfsInCompleteGraphWithGoalTest", testDfsInCompleteGraphWithGoalTest),
        ("testDfsInCompleteGraphWithGoalTestByIndex", testDfsInCompleteGraphWithGoalTestByIndex),
        ("testDfsInPath", testDfsInPath),
        ("testDfsInPathByIndex", testDfsInPathByIndex),
        ("testDfsInPathWithGoalTest", testDfsInPathWithGoalTest),
        ("testDfsInPathWithGoalTestByIndex", testDfsInPathWithGoalTestByIndex),
        ("testDfsInStarGraph", testDfsInStarGraph),
        ("testDfsInStarGraphByIndex", testDfsInStarGraphByIndex),
        ("testDfsInStarGraphWithGoalTest", testDfsInStarGraphWithGoalTest),
        ("testDfsInStarGraphWithGoalTestByIndex", testDfsInStarGraphWithGoalTestByIndex),
    ]
}

extension UnionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__UnionTests = [
        ("testDisjointUnion", testDisjointUnion),
        ("testUnionWithSelf", testUnionWithSelf),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ConstructorsPerformanceTests.__allTests__ConstructorsPerformanceTests),
        testCase(SearchPerformanceTests.__allTests__SearchPerformanceTests),
        testCase(UnionTests.__allTests__UnionTests),
    ]
}
#endif