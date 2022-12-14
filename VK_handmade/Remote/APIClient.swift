//
//  APIClient.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 20.08.2022.
//

import UIKit

protocol NetworkRequestManager {
    func fetch<Request, Response>(_ endpoint: API.Types.Endpoint,
                                  method: API.Types.Method,
                                  body: Request?,
                                  then callback: (
                                    (Result<Response, API.Types.Error>
                                    ) -> Void)?) where Request: Encodable, Response: Decodable

    func get<Response>(_ endpoint: API.Types.Endpoint,
                       callback: ((Result<Response, API.Types.Error>) -> Void)?
    ) where Response: Decodable
}

extension API {
    class NetworkRequestManagerImpl: NetworkRequestManager {
        static let shared = NetworkRequestManagerImpl()
        private let encoder = JSONEncoder()
        private let decoder = JSONDecoder()

        func fetch<Request, Response>(_ endpoint: Types.Endpoint,
                                      method: Types.Method = .get,
                                      body: Request? = nil,
                                      then callback: (
                                        (Result<Response, Types.Error>
                                        ) -> Void)? = nil) where Request: Encodable, Response: Decodable {
            var urlRequest = URLRequest(url: endpoint.url)
            urlRequest.httpMethod = method.rawValue

            if let body = body {
                do {
                    urlRequest.httpBody = try encoder.encode(body)
                } catch {
                    callback?(.failure(.iternal(reason: "Could not encode body")))
                    return
                }
            }

            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                if let error = error {
                    print(error)
                    callback?(.failure(.generic(reason: "Could not fetch data: \(error.localizedDescription)")))
                } else {
                    if let data = data {
                            do {
                                let result = try self.decoder.decode(Response.self, from: data)
                                DispatchQueue.main.async {
                                    callback?(.success(result))
                                }
                            } catch {
                                print("Decoding error: \(error)")
                                DispatchQueue.main.async {
                                    callback?(
                                        .failure(
                                            .generic(reason: "Could not decode data: \(error.localizedDescription)")
                                        )
                                    )
                                }
                            }
                    }
                }
            }.resume()

        }

        func get<Response>(_ endpoint: Types.Endpoint,
                           callback: ((Result<Response, Types.Error>) -> Void)? = nil
        ) where Response: Decodable {
            let body: Types.Request.Empty? = nil
            fetch(endpoint, method: .get, body: body) { result in
                callback?(result)
            }
        }
    }

}
