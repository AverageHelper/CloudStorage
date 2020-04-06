//
//  FileManagerExtensions.swift
//  CloudStorage
//
//  Created by James Robinson on 4/5/20.
//

import Foundation

extension FileManager {
    
    /// Returns the size of the file at the given `URL` in bytes.
    @available(OSX 10.11, iOS 9.0, *)
    public func size(ofFileAt url: URL) throws -> UInt64 {
        guard !url.hasDirectoryPath else { throw CocoaError(.fileReadUnknown) }
        
        let attrs = try self.attributesOfItem(atPath: url.path)
        let size = attrs[.size] as? NSNumber
        return size?.uint64Value ?? 0
    }
    
}
