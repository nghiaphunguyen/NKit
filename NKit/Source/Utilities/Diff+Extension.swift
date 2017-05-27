//
//  Diff+Extension.swift
//  NKit
//
//  Created by Apple on 5/26/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import Diff

public protocol NKDiffable {
    var diffIdentifier: String {get}
}

public extension Collection where Iterator.Element == NKDiffable {
    public func diff(
        _ other: Self
        ) -> Diff {
        return diff(other, isEqual: { $0.diffIdentifier == $1.diffIdentifier })        
    }
    
    /// - seealso: `diffTraces(to:isEqual:)`
    public func diffTraces(
        to: Self
        ) -> [Trace] {
        return diffTraces(to: to, isEqual: { $0.diffIdentifier == $1.diffIdentifier })
    }
    
    /// - seealso: `outputDiffPathTraces(to:isEqual:)`
    public func outputDiffPathTraces(
        to: Self
        ) -> [Trace] {
        return outputDiffPathTraces(to: to, isEqual: { $0.diffIdentifier == $1.diffIdentifier })
    }
}

public extension Diff {
    public static var backgroundQueue = DispatchQueue.init(label: "diff")
    
    public static func diff(oldModels: [NKDiffable], newModels: [NKDiffable], result: @escaping (Diff) -> Void) {
        
        self.backgroundQueue.async {
            let diff = oldModels.diff(newModels)
            
            DispatchQueue.main.async {
                result(diff)
            }
        }
    }
    
    public var insertions: [Diff.Element] {
        return self.elements.filter { $0.isInsert }
    }
    
    public var deletions: [Diff.Element] {
        return self.elements.filter { $0.isDelete }
    }
}

public extension Diff.Element {
    public var isInsert: Bool {
        switch self {
        case .insert(at: _):
            return true
        default:
            return false
        }
    }
    
    public var isDelete: Bool {
        switch self {
        case .delete(at: _):
            return true
        default:
            return false
        }
    }
    
    public var idx: Int {
        switch self {
        case .delete(at: let index):
            return index
        case .insert(at: let index):
            return index
        }
    }
}
