//
//  CreditScoreModelProvider.swift
//  Credit Score
//
//  Created by Nithin Bhaktha on 14/10/22.
//

import Foundation

enum JSONError: Error {
    case invalidPath
    case noJSONData
    case badJSONData
}

protocol UserProvider {
    
    func fetchCreditCardUser(_ completion: @escaping (Result<User, JSONError>) -> ())
}

class UserManager: UserProvider {
    
    static let shared = UserManager()
    private init() {
        // Intentionally blank...
    }
    
    var jsonDataProvider: JSONProviderService = NetworkClient.Shared
    
    struct Constants {
        static let endPoint = "https://ntnbkta.github.io/valid.json"
    }
    
    /*! @abstract Fetches the Credit card User from a given JSONProvider, by default this is Network Client.
     @param completion: Result with User model if success, JSONError on failure
     */
    func fetchCreditCardUser(_ completion: @escaping (Result<User, JSONError>) -> ()) {
        
        let api = APIRequest(urlString: Constants.endPoint)
        jsonDataProvider.requestData(for: api) { result in
            
            switch result {
            case .success(let jsonData):
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                do {
                    let card = try decoder.decode(CreditCardDetail.self, from: jsonData)
                    completion(.success(card.users.first!))
                } catch {
                    completion(.failure(.badJSONData))
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
                completion(.failure(.noJSONData))
            }
        }
    }
}
