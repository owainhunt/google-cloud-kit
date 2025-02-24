import Core

public struct SignJWTResponse: Codable {
    public let keyId: String
    public let signedJwt: String
}
