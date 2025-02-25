//
//  StorageClient.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/16/18.
//

import Core
import Foundation
import AsyncHTTPClient
import NIO

public struct GoogleCloudStorageClient {
    
    public var bucketAccessControl: BucketAccessControlAPI
    public var buckets: StorageBucketAPI
    public var channels: ChannelsAPI
    public var defaultObjectAccessControl: DefaultObjectACLAPI
    public var objectAccessControl: ObjectAccessControlsAPI
    public var notifications: StorageNotificationsAPI
    public var object: StorageObjectAPI

    let cloudStorageRequest: GoogleCloudStorageRequest
    
    public init(
        strategy: CredentialsLoadingStrategy,
        client: HTTPClient,
        scope: [GoogleCloudStorageScope]
    ) async throws {
        
        cloudStorageRequest = try await .request(
            strategy: strategy,
            client: client,
            scope: scope
        )
        
        bucketAccessControl = GoogleCloudStorageBucketAccessControlAPI(request: cloudStorageRequest)
        buckets = GoogleCloudStorageBucketAPI(request: cloudStorageRequest)
        channels = GoogleCloudStorageChannelsAPI(request: cloudStorageRequest)
        defaultObjectAccessControl = GoogleCloudStorageDefaultObjectACLAPI(request: cloudStorageRequest)
        objectAccessControl = GoogleCloudStorageObjectAccessControlsAPI(request: cloudStorageRequest)
        notifications = GoogleCloudStorageNotificationsAPI(request: cloudStorageRequest)
        object = GoogleCloudStorageObjectAPI(request: cloudStorageRequest)
    }
}
