//
//  FileUploader.swift
//  CloudStorage
//
//  Created by James Robinson on 2/7/20.
//

import Foundation
#if canImport(Combine)
import Combine
#endif
#if canImport(CryptoKit)
import CryptoKit
#endif

#if canImport(Combine)
/// A publisher which defines a method for uploading a file referenced by a given `Uploadable` value.
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol FileUploader: Publisher where Failure == UploadError, Output == UploadProgress {
    
    associatedtype UploadableType: Uploadable
    
    #if canImport(CryptoKit)
    /// Prepares to upload data from a `fileObject` to an external service.
    ///
    /// - Parameters:
    ///   - file: The `Uploadable` with data to upload. There must be some data in the object's
    ///     `data` property, or this method will throw an error.
    ///   - encryptionKey: A symmetric key used to encrypt the file data at its remote destination. Pass `nil`
    ///     to send the file data as-is.
    ///
    /// - Important: The `FileUploader` may not store the given `encryptionKey` automatically. The
    ///   caller should expect to handle key management themselves.
    ///
    /// - Throws: An `UploadError` if the upload is unable to begin.
    /// - Returns: A publisher of the same `Uploadable` whose data was uploaded, having been set
    ///   with relevant data for retrieval.
    static func uploadFile(_ file: UploadableType,
                           encryptingWithKey encryptionKey: SymmetricKey?) throws -> Self
    #endif
    
}
#endif

public struct UploadProgress {
    
    public init(completedBytes: Int, totalBytes: Int) {
        self.completedBytes = completedBytes
        self.totalBytes = totalBytes
    }
    
    public var completedBytes: Int
    public var totalBytes: Int
    public var fractionCompleted: Double { Double(completedBytes) / Double(totalBytes) }
    
}

/// A type that conforms to this protocol may be used by objects that conform to the `FileUploader` protocol.
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Uploadable {
    associatedtype Metadata: Downloadable
    var metadata: Metadata { get }
    var payload: Data? { get }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Uploadable {
    public var id: UUID { self.metadata.id }
}

public enum UploadError: Swift.Error {
    /// The upload was cancelled.
    case cancelled
    #if canImport(CryptoKit)
    /// An error occurred while encrypting the payload for transport.
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    case encryption(CryptoKitError)
    #endif
    /// There is no data to upload.
    case noData
    /// The network is temporarily unavailable.
    case networkUnavailable
    /// The storage service is temporarily unavailable.
    case serviceUnavailable
    /// Multiple errors occurred. These are mapped by their file ID.
    indirect case multiple([UUID: UploadError])
    /// The user is not signed in.
    case notAuthenticated
    /// The signed-in user dows not have permission to upload the file.
    case unauthorized
    /// The specified zone does not exist yet.
    case zoneNotFound(named: String)
    /// An error which should only come up under development and pre-launch circumstances.
    case development(String)
    /// An unknown error has occurred. If this error was derrived from a
    /// specific service's error codes, you may need to handle that error specially.
    case unknown
}
