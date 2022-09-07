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
    
    func load<T>(
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
            print(String(data: data, encoding: .utf8)!)
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                print(result)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodeError))
            }
            
        }
        dataTask?.resume()
    }
    
    let uploadQueue = DispatchQueue.global(qos: .background)
    let uploadGroup = DispatchGroup()
    let uploadSemaphore = DispatchSemaphore(value: 1)
    ///Keeping network call one at a time
    func loadWithQue<T>(
        resource: Resource<T>,
        completion: @escaping (Result<T, NetworkError>)->Void
    ){
        uploadQueue.async(group: uploadGroup) { [weak self] in
            guard let self = self else { return }
            self.uploadGroup.enter()
            self.uploadSemaphore.wait()
            self.load(resource: resource) { result in
                completion(result)
                self.uploadGroup.leave()
                self.uploadSemaphore.signal()
            }
        }
    }
    
}




