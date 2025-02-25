import Core
import Foundation
import AsyncHTTPClient
import NIO

public final class GoogleCloudPubSubClient {
    public var pubSubTopic: TopicsAPI
    public var pubSubSubscription: SubscriptionsAPI
    var pubSubRequest: GoogleCloudPubSubRequest
    
    public init(
        strategy: CredentialsLoadingStrategy,
        client: HTTPClient,
        base: String = "https://pubsub.googleapis.com",
        scope: [GoogleCloudPubSubScope]
    ) async throws {
        
        pubSubRequest = try await .request(
            strategy: strategy,
            client: client,
            scope: scope
        )
        
        pubSubTopic = GoogleCloudPubSubTopicsAPI(request: pubSubRequest, endpoint: base)
        pubSubSubscription = GoogleCloudPubSubSubscriptionsAPI(request: pubSubRequest, endpoint: base)
    }
}
