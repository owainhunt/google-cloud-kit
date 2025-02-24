import Core

public enum GoogleCloudPubSubScope: GoogleCloudAPIScope {
    /// View and manage Pub/Sub topics and subscriptions
    case pubsub
    
    /// See, edit, configure, and delete your Google Cloud Platform data
    case cloudPlatform

    public var value: String {
        switch self {
        case .pubsub: return "https://www.googleapis.com/auth/pubsub"
        case .cloudPlatform: return "https://www.googleapis.com/auth/cloud-platform"
        }
    }
}
