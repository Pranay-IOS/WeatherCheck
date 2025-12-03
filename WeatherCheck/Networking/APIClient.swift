//
//  APIClient.swift
//  WeatherCheck
//
//  Created by Pranay Barua on 01/12/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case noData
}

class APIClientService {
    
    static let shared = APIClientService()
    private init() {} // Singleton
    
    func get<T: Decodable>(
        urlString: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(APIError.decodingFailed))
            }
            
        }.resume()
    }
}
