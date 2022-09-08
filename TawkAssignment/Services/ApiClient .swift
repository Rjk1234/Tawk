//
//  ApiClient .swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 02/09/22.
//

import Foundation
import Combine

enum NetworkError: Error{
    case decodeError
    case domainError
    case urlError
    case sessionError
}
enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HTTPMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url:URL){
        self.url = url
    }
}

class ApiClient {
    
    var session: URLSession?
    var dataTask: URLSessionDataTask?
    
    init(session: URLSession = URLSession.shared){
        self.session = session
    }
    
    func fetch<T>(
        resource: Resource<T>,
        completion: @escaping (Result<T, NetworkError>)->Void
    ){
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let session = session else {
            completion(.failure(.sessionError))
            return
        }
        dataTask = session.dataTask(with: request){ data, response, err in
            guard let data = data, err == nil else{
                completion(.failure(.decodeError))
                return
            }
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodeError))
            }
            
        }
        dataTask?.resume()
    }
    
    let downloadQueue = DispatchQueue.global(qos: .background)
    let downloadGroup = DispatchGroup()
    let uploadSemaphore = DispatchSemaphore(value: 1)
    ///Keeping network call one at a time
    func fetchWithQueue<T>(
        resource: Resource<T>,
        completion: @escaping (Result<T, NetworkError>)->Void
    ){
        downloadQueue.async(group: downloadGroup) { [weak self] in
            guard let self = self else { return }
            self.downloadGroup.enter()
            self.uploadSemaphore.wait()
            self.fetch(resource: resource) { result in
                completion(result)
                self.downloadGroup.leave()
                self.uploadSemaphore.signal()
            }
        }
    }
    
}




