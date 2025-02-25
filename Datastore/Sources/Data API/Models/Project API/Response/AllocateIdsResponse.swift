import Core

public struct AllocateIdsResponse: Codable {
    /// The keys specified in the request (in the same order), each with its key path completed with a newly allocated ID.
    public let keys: [Key]
}
