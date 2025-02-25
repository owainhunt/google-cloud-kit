import Core
import Foundation
import AsyncHTTPClient
import NIO

public final class GoogleCloudDatastoreClient {
    
    public var project: DatastoreProjectAPI
    var datastoreRequest: GoogleCloudDatastoreRequest
    
    public init(
        strategy: CredentialsLoadingStrategy,
        client: HTTPClient,
        base: String = "https://datastore.googleapis.com",
        scope: [GoogleCloudDatastoreScope]
    ) async throws {
        
        datastoreRequest = try await .request(
            strategy: strategy,
            client: client,
            scope: scope
        )
        
        project = GoogleCloudDatastoreProjectAPI(
            request: datastoreRequest,
            endpoint: base
        )
    }
}
