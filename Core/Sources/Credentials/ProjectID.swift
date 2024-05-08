import Foundation

public var projectId: String {
    ProcessInfo.processInfo.environment["PROJECT_ID"]
    ?? ProcessInfo.processInfo.environment["GOOGLE_PROJECT_ID"]
    ?? "default"
}
