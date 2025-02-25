import Core
import Foundation
import AsyncHTTPClient
import NIO

public struct GoogleCloudSecretManagerClient {
    
    public var secrets: SecretVersionAPI
    let secretManagerRequest: GoogleCloudSecretManagerRequest
    
    public init(
        strategy: CredentialsLoadingStrategy,
        client: HTTPClient,
        base: String = "https://secretmanager.googleapis.com",
        scope: [GoogleCloudSecretManagerScope]
    ) async throws {
        
        secretManagerRequest = try await .request(
            strategy: strategy,
            client: client,
            scope: scope
        )
        
        secrets = GoogleCloudSecretManagerSecretVersionAPI(
            request: secretManagerRequest,
            endpoint: base
        )
    }
}
