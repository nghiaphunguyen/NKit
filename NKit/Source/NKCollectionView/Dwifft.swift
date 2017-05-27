//
////
////  LCS.swift
////  Dwifft
////
////  Created by Jack Flintermann on 3/14/15.
////  Copyright (c) 2015 jflinter. All rights reserved.
////
//import Foundation
//
//public protocol NKDiffable {
//    var diffIdentifier: String {get}
//}
//
//public struct Diff {
//    public let results: [DiffStep]
//    public var insertions: [DiffStep] {
//        return results.filter({ $0.isInsertion }).sorted { $0.idx < $1.idx }
//    }
//    public var deletions: [DiffStep] {
//        return results.filter({ !$0.isInsertion }).sorted { $0.idx > $1.idx }
//    }
//    public func reversed() -> Diff {
//        let reversedResults = self.results.reversed().map { (result: DiffStep) -> DiffStep in
//            switch result {
//            case .insert(let i, let j):
//                return .delete(i, j)
//            case .delete(let i, let j):
//                return .insert(i, j)
//            }
//        }
//        return Diff(results: reversedResults)
//    }
//}
//
//public func +(left: Diff, right: DiffStep) -> Diff {
//    return Diff(results: left.results + [right])
//}
//
///// These get returned from calls to Array.diff(). They represent insertions or deletions that need to happen to transform array a into array b.
//public enum DiffStep : CustomDebugStringConvertible {
//    case insert(Int, NKDiffable)
//    case delete(Int, NKDiffable)
//    var isInsertion: Bool {
//        switch(self) {
//        case .insert:
//            return true
//        case .delete:
//            return false
//        }
//    }
//    public var debugDescription: String {
//        switch(self) {
//        case .insert(let i, let j):
//            return "+\(j)@\(i)"
//        case .delete(let i, let j):
//            return "-\(j)@\(i)"
//        }
//    }
//    public var idx: Int {
//        switch(self) {
//        case .insert(let i, _):
//            return i
//        case .delete(let i, _):
//            return i
//        }
//    }
//    public var value: NKDiffable {
//        switch(self) {
//        case .insert(let j):
//            return j.1
//        case .delete(let j):
//            return j.1
//        }
//    }
//}
//
//struct Dwifft {
//    public static func diff(oldModels: [NKDiffable], newModels: [NKDiffable]) -> Diff {
//        let table = MemoizedSequenceComparison.buildTable(oldModels, newModels, oldModels.count, newModels.count)
//        return self.diffFromIndices(table, oldModels, newModels, oldModels.count, newModels.count)
//    }
//    
//    fileprivate static func diffFromIndices(_ table: [[Int]], _ x: [NKDiffable], _ y: [NKDiffable], _ i: Int, _ j: Int) -> Diff {
//        if i == 0 && j == 0 {
//            return Diff(results: [])
//        } else if i == 0 {
//            return diffFromIndices(table, x, y, i, j-1) + DiffStep.insert(j-1, y[j-1])
//        } else if j == 0 {
//            return diffFromIndices(table, x, y, i - 1, j) + DiffStep.delete(i-1, x[i-1])
//        } else if table[i][j] == table[i][j-1] {
//            return diffFromIndices(table, x, y, i, j-1) + DiffStep.insert(j-1, y[j-1])
//        } else if table[i][j] == table[i-1][j] {
//            return diffFromIndices(table, x, y, i - 1, j) + DiffStep.delete(i-1, x[i-1])
//        } else {
//            return diffFromIndices(table, x, y, i-1, j-1)
//        }
//    }
//    
//    public static func apply(_ diff: Diff, to array: [NKDiffable]) -> [NKDiffable] {
//        var copy = array
//        for result in diff.deletions {
//            copy.remove(at: result.idx)
//        }
//        for result in diff.insertions {
//            copy.insert(result.value, at: result.idx)
//        }
//        return copy
//    }
//}
//
////public extension Array {
////    
////    /// Returns the sequence of ArrayDiffResults required to transform one array into another.
////    public func diff(_ other: [Element]) -> Diff<Element> {
////        let table = MemoizedSequenceComparison.buildTable(self, other, self.count, other.count)
////        return Array.diffFromIndices(table, self, other, self.count, other.count)
////    }
////    
////    /// Walks back through the generated table to generate the diff.
////    fileprivate static func diffFromIndices(_ table: [[Int]], _ x: [Element], _ y: [Element], _ i: Int, _ j: Int) -> Diff<Element> {
////        if i == 0 && j == 0 {
////            return Diff<Element>(results: [])
////        } else if i == 0 {
////            return diffFromIndices(table, x, y, i, j-1) + DiffStep.insert(j-1, y[j-1])
////        } else if j == 0 {
////            return diffFromIndices(table, x, y, i - 1, j) + DiffStep.delete(i-1, x[i-1])
////        } else if table[i][j] == table[i][j-1] {
////            return diffFromIndices(table, x, y, i, j-1) + DiffStep.insert(j-1, y[j-1])
////        } else if table[i][j] == table[i-1][j] {
////            return diffFromIndices(table, x, y, i - 1, j) + DiffStep.delete(i-1, x[i-1])
////        } else {
////            return diffFromIndices(table, x, y, i-1, j-1)
////        }
////    }
////    
////    /// Applies a generated diff to an array. The following should always be true:
////    /// Given x: [T], y: [T], x.apply(x.diff(y)) == y
////    public func apply(_ diff: Diff<Element>) -> Array<Element> {
////        var copy = self
////        for result in diff.deletions {
////            copy.remove(at: result.idx)
////        }
////        for result in diff.insertions {
////            copy.insert(result.value, at: result.idx)
////        }
////        return copy
////    }
////    
////}
//
////public extension Array where Element == NKDiffable {
////    
////    /// Returns the longest common subsequence between two arrays.
////    public func LCS(_ other: [Element]) -> [Element] {
////        let table = MemoizedSequenceComparison.buildTable(self, other, self.count, other.count)
////        return Array.lcsFromIndices(table, self, other, self.count, other.count)
////    }
////    
////    /// Walks back through the generated table to generate the LCS.
////    fileprivate static func lcsFromIndices(_ table: [[Int]], _ x: [Element], _ y: [Element], _ i: Int, _ j: Int) -> [Element] {
////        if i == 0 || j == 0 {
////            return []
////        } else if x[i-1].diffIdentifier == y[j-1].diffIdentifier {
////            return lcsFromIndices(table, x, y, i - 1, j - 1) + [x[i - 1]]
////        } else if table[i-1][j] > table[i][j-1] {
////            return lcsFromIndices(table, x, y, i - 1, j)
////        } else {
////            return lcsFromIndices(table, x, y, i, j - 1)
////        }
////    }
////    
////}
//
//internal struct MemoizedSequenceComparison {
//    static func buildTable(_ x: [NKDiffable], _ y: [NKDiffable], _ n: Int, _ m: Int) -> [[Int]] {
//        var table = Array(repeating: Array(repeating: 0, count: m + 1), count: n + 1)
//        for i in 0...n {
//            for j in 0...m {
//                if (i == 0 || j == 0) {
//                    table[i][j] = 0
//                }
//                else if x[i-1].diffIdentifier == y[j-1].diffIdentifier {
//                    table[i][j] = table[i-1][j-1] + 1
//                } else {
//                    table[i][j] = max(table[i-1][j], table[i][j-1])
//                }
//            }
//        }
//        return table
//    }
//}
