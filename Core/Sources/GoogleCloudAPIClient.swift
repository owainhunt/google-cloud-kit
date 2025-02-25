//
//  GoogleCloudAPIClient.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 8/5/19.
//

import Foundation
import AsyncHTTPClient

public protocol GoogleCloudAPIClient {
    
    var tokenProvider: AccessTokenProvider { get }
    
    static func request<T: GoogleCloudAPIClient>(
        strategy: CredentialsLoadingStrategy,
        client: HTTPClient,
        scope: [GoogleCloudAPIScope]
    ) async throws -> T
    
    init(
        tokenProvider: AccessTokenProvider,
        client: HTTPClient,
        project: String
    )
}

public extension GoogleCloudAPIClient {
    static func request<T: GoogleCloudAPIClient>(
        strategy: CredentialsLoadingStrategy,
        client: HTTPClient,
        scope: [GoogleCloudAPIScope]
    ) async throws -> T {
        
        let resolvedCredentials = try await CredentialsResolver.resolveCredentials(strategy: strategy)
        let provider: AccessTokenProvider
        let projectId: String
        
        switch resolvedCredentials {
            case .gcloud(let gCloudCredentials):
                provider = GCloudCredentialsProvider(
                    client: client,
                    credentials: gCloudCredentials
                )
                projectId = gCloudCredentials.projectId
                
            case .serviceAccount(let serviceAccountCredentials):
                provider = ServiceAccountCredentialsProvider(
                    client: client,
                    credentials: serviceAccountCredentials,
                    scope: scope
                )
                projectId = serviceAccountCredentials.projectId
                
            case .computeEngine(let metadataUrl):
                projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ?? "default"
                switch strategy {
                    case .computeEngine(let client):
                        provider = ComputeEngineCredentialsProvider(
                            client: client,
                            scopes: scope,
                            url: metadataUrl
                        )
                    default:
                        provider = ComputeEngineCredentialsProvider(
                            client: client,
                            scopes: scope,
                            url: metadataUrl
                        )
                }
        }
        
        return T(
            tokenProvider: provider,
            client: client,
            project: projectId
        )
    }
}
