import Foundation
import JWTKit

struct SignJWTRequest: Codable {
    
    public init(jwt: JWTPayload) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .integerSecondsSince1970
        guard let data = try? encoder.encode(jwt),
                let payload = String(data: data, encoding: .utf8) else
        {
            fatalError()
        }
        
        self.payload = payload
    }
    
    let payload: String
    var delegates: [String] = []
    
}
