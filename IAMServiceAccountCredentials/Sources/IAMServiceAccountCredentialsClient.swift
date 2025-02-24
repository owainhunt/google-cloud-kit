import Core
import Foundation
import AsyncHTTPClient

public final class IAMServiceAccountCredentialsClient {
    
    public var api: IAMServiceAccountCredentialsAPI
    var request: IAMServiceAccountCredentialsRequest
    
    public init(
        strategy: CredentialsLoadingStrategy,
        client: HTTPClient,
        base: String = "https://iamcredentials.googleapis.com",
        scope: [GoogleCloudIAMServiceAccountCredentialsScope]
    ) async throws {
        
        let resolvedCredentials = try await CredentialsResolver.resolveCredentials(strategy: strategy)
        
        switch resolvedCredentials {
            case .gcloud(let gCloudCredentials):
                let provider = GCloudCredentialsProvider(client: client, credentials: gCloudCredentials)
                request = .init(tokenProvider: provider, client: client, project: gCloudCredentials.quotaProjectId)
                
            case .serviceAccount(let serviceAccountCredentials):
                let provider = ServiceAccountCredentialsProvider(client: client, credentials: serviceAccountCredentials, scope: scope)
                request = .init(tokenProvider: provider, client: client, project: serviceAccountCredentials.projectId)
                
            case .computeEngine(let metadataUrl):
                let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ?? "default"
                switch strategy {
                    case .computeEngine(let client):
                        let provider = ComputeEngineCredentialsProvider(client: client, scopes: scope, url: metadataUrl)
                        request = .init(tokenProvider: provider, client: client, project: projectId)
                    default:
                        let provider = ComputeEngineCredentialsProvider(client: client, scopes: scope, url: metadataUrl)
                        request = .init(tokenProvider: provider, client: client, project: projectId)
                }
        }
        
        api = GoogleCloudServiceAccountCredentialsAPI(request: request, endpoint: base)
    }
}
