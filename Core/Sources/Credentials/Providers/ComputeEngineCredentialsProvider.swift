//
//  ComputeEngineCredentialsProvider.swift
//  
//
//  Created by Andrew Edwards on 2/19/22.
//

import Foundation
import AsyncHTTPClient
import NIO

public actor ComputeEngineCredentialsProvider: AccessTokenProvider {
    static let metadataServerUrl = "http://metadata.google.internal"
    let scopes: [String]
    let client: HTTPClient
    let url: String?
    var accessToken: AccessToken?
    var tokenExpiration: Date?
    let decoder = JSONDecoder()
    
    public init(client: HTTPClient, scopes: [String], url: String?) {
        self.client = client
        self.scopes = scopes
        self.url = url
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func getAccessToken() async throws -> String {
        if let existingToken = accessToken,
           let expiration = tokenExpiration {
            if expiration >= Date() {
                return existingToken.accessToken
            } else {
                return try await refresh()
            }
        } else {
            return try await refresh()
        }
    }
    
    private func buildRequest() -> HTTPClientRequest {
        let finalUrl = "\(url ?? Self.metadataServerUrl)/computeMetadata/v1/instance/service-accounts/default/token?scopes=\(scopes.joined(separator: ","))"
        
        var request = HTTPClientRequest(url: finalUrl)
        request.headers = ["Metadata-Flavor": "Google"]
        return request
    }
    
    @discardableResult
    private func refresh() async throws -> String {
        let response = try await client.execute(buildRequest(), timeout: .seconds(10))
        guard response.status == .ok else {
            throw OauthRefreshError.noResponse(response.status)
        }
        
        let body = try await response.body.collect(upTo: 1024 * 1024) // 1mb
        
        let token = try decoder.decode(AccessToken.self, from: Data(buffer: body))
        accessToken = token
        // scrape off 5 minutes so we're not runnung up against time boundaries.
        tokenExpiration = Date().addingTimeInterval(TimeInterval(token.expiresIn - 300))
        return token.accessToken
    }
}
