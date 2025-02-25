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
        
        request = try await .request(
            strategy: strategy,
            client: client,
            scope: scope
        )
        
        api = GoogleCloudServiceAccountCredentialsAPI(request: request, endpoint: base)
    }
}
