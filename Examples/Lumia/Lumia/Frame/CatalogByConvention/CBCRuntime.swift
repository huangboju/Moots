//
//  CBCRuntime.swift
//  Lumia
//
//  Created by xiAo_Ju on 2020/1/20.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

let CBCBreadcrumbs    = "breadcrumbs"
let CBCIsDebug        = "debug"
let CBCDescription    = "description"
let CBCIsPresentable  = "presentable"
let CBCIsPrimaryDemo  = "primaryDemo"
let CBCRelatedInfo    = "relatedInfo"
let CBCStoryboardName = "storyboardName"

func CBCCatalogBreadcrumbsFromClass(_ aClass: CBCCatalogExample.Type) -> [String] {
    return aClass.catalogMetadata?[CBCBreadcrumbs] as? [String] ?? []
}

func CBCCatalogIsPrimaryDemoFromClass(_ aClass: CBCCatalogExample.Type) -> Bool {
    return aClass.catalogMetadata?[CBCIsPrimaryDemo] as? Bool ?? false
}

func CBCCatalogIsPresentableFromClass(_ aClass: CBCCatalogExample.Type) -> Bool {
    return aClass.catalogMetadata?[CBCIsPresentable] as? Bool ?? false
}

func CBCCatalogIsDebugLeaf(_ aClass: CBCCatalogExample.Type) -> Bool {
    return aClass.catalogMetadata?[CBCIsDebug] as? Bool ?? false
}

func CBCRelatedInfoFromClass(_ aClass: CBCCatalogExample.Type) -> URL? {
    return aClass.catalogMetadata?[CBCRelatedInfo] as? URL
}

func CBCDescriptionFromClass(_ aClass: CBCCatalogExample.Type) -> String? {
    return aClass.catalogMetadata?[CBCDescription] as? String
}

func CBCStoryboardNameFromClass(_ aClass: CBCCatalogExample.Type) -> String? {
    return aClass.catalogMetadata?[CBCStoryboardName] as? String
}

func CBCFixViewDebuggingIfNeeded() {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//      Method original = class_getInstanceMethod([UIView class], @selector(viewForBaselineLayout));
//      class_addMethod([UIView class], @selector(viewForFirstBaselineLayout),
//                      method_getImplementation(original), method_getTypeEncoding(original));
//      class_addMethod([UIView class], @selector(viewForLastBaselineLayout),
//                      method_getImplementation(original), method_getTypeEncoding(original));
//    });
}

func CBCViewControllerFromClass(_ aClass: UIViewController.Type, _ metadata: [String: Any]) -> UIViewController {
    guard let storyboardName = metadata[CBCStoryboardName] as? String else { return aClass.init() }
    let bundle = Bundle(for: aClass)
    let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
//    assert(storyboard, "expecting a storyboard to exist at \(storyboardName)")
    let vc = storyboard.instantiateInitialViewController()
    assert(vc != nil, "expecting a initialViewController in the storyboard \(storyboardName)")
    return vc!
}

func getClassList() -> [AnyClass] {
    let expectedClassCount = objc_getClassList(nil, 0)
    let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))

    let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
    let actualClassCount: Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

    var classes = [AnyClass]()
    for i in 0 ..< actualClassCount {
        if let currentClass: AnyClass = allClasses[Int(i)] {
            classes.append(currentClass)
        }
    }

    allClasses.deallocate()
    return classes
}

func CBCGetAllCompatibleClasses() -> [UIViewController.Type] {
    let classList = getClassList()

    var classes: [UIViewController.Type] = []

    let ignoredClasses: Set<String> = [
    "SwiftObject",
    "Object",
    "FigIrisAutoTrimmerMotionSampleExport",
    "NSLeafProxy"
    ]
    let ignoredPrefixes = ["Swift.", "_", "JS", "WK", "PF" ]

    for aClass in classList {
        let className = NSStringFromClass(aClass)
        if ignoredClasses.contains(className) {
            continue
        }
        var hasIgnoredPrefix = false
        for prefix in ignoredPrefixes {
            if className.hasPrefix(prefix) {
                hasIgnoredPrefix = true
                break
            }
        }
        if hasIgnoredPrefix {
            continue
        }

        guard let vClass = aClass as? UIViewController.Type else {
            continue
        }
        classes.append(vClass)
  }

  return classes
}

func CBCCatalogMetadataFromClass(_ aClass: UIViewController.Type) -> [String: Any] {
    guard let catalogMetadata = (aClass as? CBCCatalogExample.Type)?.catalogMetadata else {
        return CBCConstructMetadataFromMethods(aClass)
    }
    return catalogMetadata
}

func CBCConstructMetadataFromMethods(_ aClass: UIViewController.Type) -> [String: Any] {
    var catalogMetadata: [String: Any] = [:]

    if let instance = aClass as? CBCCatalogExample.Type {
        catalogMetadata[CBCBreadcrumbs] = CBCCatalogBreadcrumbsFromClass(instance)
        catalogMetadata[CBCIsPrimaryDemo] = CBCCatalogIsPrimaryDemoFromClass(instance)
        catalogMetadata[CBCIsPresentable] = CBCCatalogIsPresentableFromClass(instance)
        catalogMetadata[CBCIsDebug] = CBCCatalogIsDebugLeaf(instance)

        if let relatedInfo = CBCRelatedInfoFromClass(instance) {
            catalogMetadata[CBCRelatedInfo] = relatedInfo
        }
        if let description = CBCDescriptionFromClass(instance){
            catalogMetadata[CBCDescription] = description
        }
        if let storyboardName = CBCStoryboardNameFromClass(instance) {
            catalogMetadata[CBCStoryboardName] = storyboardName
        }
    }
    return catalogMetadata;
}
