import Core
import Foundation
import AsyncHTTPClient
import NIO

public struct GoogleCloudTranslationClient {
    
    public var translation: TranslationBasicAPI
    let translationRequest: GoogleCloudTranslationRequest

    public init(
        strategy: CredentialsLoadingStrategy,
        client: HTTPClient,
        base: String = "https://translation.googleapis.com",
        scope: [GoogleCloudTranslationScope]
    ) async throws {
        
        translationRequest = try await .request(
            strategy: strategy,
            client: client,
            scope: scope
        )
        
        translation = GoogleCloudTranslationBasicAPI(
            request: translationRequest,
            endpoint: base
        )
    }
}
