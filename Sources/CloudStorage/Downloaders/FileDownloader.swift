//
//  FileDownloader.swift
//  CloudStorage
//
//  Created by James Robinson on 2/5/20.
//

#if canImport(Combine) && canImport(CryptoKit)
import Foundation
import Combine
import CryptoKit

/// A publisher which defines a method for downloading a file referenced by a given `Downloadable`.
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol FileDownloader: Publisher
    where Output == DownloadProgress,
    Failure == DownloadError {
    
    associatedtype DownloadableType: Downloadable
    associatedtype DeleterType: FileDeleter
    
    /// Prepares to download data for a `Downloadable` from an external service.
    ///
    /// - Parameters:
    ///   - file: The `Downloadable` which identifies the data to fetch.
    ///   - outputDirectory: The location of a directory or file destination to put the downloaded (and
    ///     optionally decrypted) file. The downloader should download the relevant data into a temporary folder before
    ///     moving that data into the `outputDirectory` and finishing.
    ///   - decryptionKey: The symmetric key used to encrypt the data when it was uploaded. Pass `nil` to
    ///     return the data as it is received from the server.
    ///
    /// - Throws: `DownloadError.notAuthenticated` if the user is not presently authenticated.
    /// - Returns: A publisher of the result of the download operation. Subscribe to this publisher to begin the download.
    static func downloadFile(_ file: DownloadableType,
                             to outputDirectory: URL,
                             decryptingUsing decryptionKey: SymmetricKey?) throws -> Self
    
    /// Prepares to delete a file from an external service.
    ///
    /// - Parameters:
    ///   - file: The `Downloadable` which identifies the data to delete.
    /// - Throws: `DownloadError.notAuthenticated` if the user is not presently authenticated.
    /// - Returns: A publisher that completes when the deletion finishes. Subscribe to this publisher to begin the deletion.
    static func deleteFile(_ file: DownloadableType) throws -> DeleterType
    
}

/// A publisher which completes successfully at the end of a successful deletion operation.
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol FileDeleter: Publisher where Output == Never, Failure == DownloadError {
    associatedtype Deletable: Downloadable
}

public struct DownloadProgress {
    public var completedBytes: Int
    public var totalBytes: Int?
    public var fractionCompleted: Double? {
        guard let total = totalBytes else { return nil }
        return Double(completedBytes) / Double(total)
    }
}

/// A type that conforms to this protocol may be used by objects that conform to the `FileDownloader` protocol.
public protocol Downloadable: Identifiable where ID == UUID {
    associatedtype PayloadType: Uploadable
    var recordIdentifier: UUID { get }
    var fileExtension: String? { get }
    
    /// Local storage for the uploadable type.
    var storage: PayloadType? { get set }
}

extension Downloadable {
    
    public var localData: Data? {
        return storage?.payload
    }
    
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum DownloadError: Swift.Error {
    /// The download was cancelled.
    case cancelled
    /// An error occurred while decrypting downloaded data.
    case decryption(CryptoKitError)
    /// An error occurred during a disk operation.
    case disk(CocoaError)
    /// The requested item was not found on the server.
    case itemNotFound
    /// Multiple errors occurred. These are mapped by their file ID.
    indirect case multiple([UUID: DownloadError])
    /// The network is temporarily unavailable.
    case networkUnavailable
    /// The storage service is temporarily unavailable.
    case serviceUnavailable
    /// The user is not signed in.
    case notAuthenticated
    /// The signed-in user does not have permission to access the file.
    case unauthorized
    /// An error which should only come up under development and pre-launch circumstances.
    case development(String)
    /// An unknown error has occurred. If this error was derrived from a
    /// specific service's error codes, you may need to handle that error specially.
    case unknown
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension DownloadError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .cancelled: return "Cancelled"
        case .decryption(let error): return error.localizedDescription
        case .development(let reason): return reason
        case .disk(let error): return error.localizedDescription
        case .itemNotFound: return "Item not found"
        case .multiple(let errors): return "\(errors.count) error\(errors.count == 1 ? "" : "s")"
        case .networkUnavailable: return "Network unavailable"
        case .notAuthenticated: return "Sign-in required"
        case .serviceUnavailable: return "Service unavailable. Try again later"
        case .unauthorized: return "No permission"
        case .unknown: return "Unknown error"
        }
    }
    
}
#endif
