import Core

public enum GoogleCloudIAMServiceAccountCredentialsScope: GoogleCloudAPIScope {
    /// View and manage your data across Google Cloud Platform services
    
    case cloudPlatform
    case iam
    
    public var value: String {
        return switch self {
            case .cloudPlatform: "https://www.googleapis.com/auth/cloud-platform"
            case .iam: "https://www.googleapis.com/auth/iam"
        }
    }
}
