//
//  NetworkClient.swift
//  Credit Score
//
//  Created by Nithin Bhaktha on 14/10/22.
//

import Foundation

protocol JSONProviderService {
    func requestData(for api: APIRequest, completion: @escaping (Result<Data, NetworkError>) -> ())
}

enum NetworkError: Error {
    case badStatus(Int)
    case invalidRequest
    case noJSONData
    case unknown(Error?)
}

/// Network client, used to request data from network.
class NetworkClient: JSONProviderService {
    
    static let Shared = NetworkClient()
    let session = URLSession.shared

    /*! @abstract Requests data from the internet using URLSession from a given APIRequest
     @param api: APIReqeust, formed of URL to request data
     @param completion: Result with a JSON data leading to a User model if success, Network Error on failure
     */
    func requestData(for api: APIRequest, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        guard let req = api.makeURLRequest() else {
            completion(.failure(.invalidRequest))
            return
        }
        session.dataTask(with: req) { (data, response, error) in
            guard error == nil else {
                return completion(.failure(.unknown(error)))
            }

            guard let response = response as? HTTPURLResponse, let responseData = data else {
                return completion(.failure(.noJSONData))
            }

            switch response.statusCode {
                case 200...299:
                    return completion(.success(responseData))
                
                default:
                    completion(.failure(.badStatus(response.statusCode)))
            }
        }.resume()
    }
}

struct APIRequest {
    var urlString: String
}

extension APIRequest {
    func makeURLRequest() -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        let req = URLRequest(url: url)
        return req
    }
}
