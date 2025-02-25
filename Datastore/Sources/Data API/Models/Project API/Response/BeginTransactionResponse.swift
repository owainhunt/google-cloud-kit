import Core

public struct BeginTransactionResponse: Codable {
    /// The transaction identifier (always present).
    public let transaction: String
}
