import Core

public enum GoogleCloudDatastoreScope: GoogleCloudAPIScope {
    /// View and manage your Google Cloud Datastore data
    case datastore
    /// View and manage your data across Google Cloud Platform services
    case cloudPlatform
    
    public var value: String {
        switch self {
        case .datastore: return "https://www.googleapis.com/auth/datastore"
        case .cloudPlatform: return "https://www.googleapis.com/auth/cloud-platform"
        }
    }
}
