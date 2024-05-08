import Core
import Foundation
import AsyncHTTPClient
import NIO

public struct GoogleCloudServiceAccountCredentialsClient {
    
    public var iam: ServiceAccountCredentialsAPI
    
    let iamRequest: GoogleCloudServiceAccountCredentialsRequest
    
    public init(strategy: CredentialsLoadingStrategy,
                client: HTTPClient,
                base: String = "https://iamcredentials.googleapis.com",
                scope: [GoogleCloudServiceAccountCredentialsScope]) async throws {
        let resolvedCredentials = try await CredentialsResolver.resolveCredentials(strategy: strategy)
        
        switch resolvedCredentials {
        case .gcloud(let gCloudCredentials):
            let provider = GCloudCredentialsProvider(client: client, credentials: gCloudCredentials)
            iamRequest = .init(tokenProvider: provider, client: client, project: gCloudCredentials.quotaProjectId)
            
        case .serviceAccount(let serviceAccountCredentials):
            let provider = ServiceAccountCredentialsProvider(client: client, credentials: serviceAccountCredentials, scope: scope)
            iamRequest = .init(tokenProvider: provider, client: client, project: serviceAccountCredentials.projectId)
            
        case .computeEngine(let metadataUrl):
            let projectId = Core.projectId
            switch strategy {
            case .computeEngine(let client):
                let provider = ComputeEngineCredentialsProvider(client: client, scopes: scope, url: metadataUrl)
                iamRequest = .init(tokenProvider: provider, client: client, project: projectId)
            default:
                let provider = ComputeEngineCredentialsProvider(client: client, scopes: scope, url: metadataUrl)
                iamRequest = .init(tokenProvider: provider, client: client, project: projectId)
            }
        }
        
        iam = GoogleCloudServiceAccountCredentialsAPI(request: iamRequest, endpoint: base)
    }
}
