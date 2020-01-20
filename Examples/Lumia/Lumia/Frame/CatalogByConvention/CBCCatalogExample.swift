//
//  CBCCatalogExample.swift
//  Lumia
//
//  Created by xiAo_Ju on 2020/1/20.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import Foundation

protocol CBCCatalogExample: class {
    static var catalogMetadata: [String: Any]? { get }
    
    static var catalogBreadcrumbs: [String] { get }
    
    static var catalogIsPrimaryDemo: Bool { get }
    
    static var catalogIsPresentable: Bool { get }
    
    static var catalogIsDebug: Bool { get }
    
    static var catalogRelatedInfo: URL? { get }
    
    static var catalogDescription: String? { get }
    
    static var catalogStoryboardName: String? { get }
}

extension CBCCatalogExample {
    static var catalogMetadata: [String: Any]? {
        return nil
    }
    
    static var catalogBreadcrumbs: [String] {
        return []
    }
    
    static var catalogIsPrimaryDemo: Bool {
        return false
    }
    
    static var catalogIsPresentable: Bool {
        return false
    }
    
    static var catalogIsDebug: Bool {
        return false
    }
    
    static var catalogRelatedInfo: URL? {
        return nil
    }
    
    static var catalogDescription: String? {
        return nil
    }
    
    static var catalogStoryboardName: String? {
        return nil
    }
}
