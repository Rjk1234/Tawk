//
//  Webservice.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 02/09/22.
//
import Foundation

class WebService {
    
    let apiClient = ApiClient()
    
    func getAllUsers(
        page: Int,
        completion: @escaping ([UserListElement]?, Error?) -> Void
    ) -> Void {
        var pageSize = 30
        if page > 0 {
            pageSize = 10
        }
        let url = URL(string: "\(baseUrl)\(userList)\(page)&per_page=\(pageSize)")!
        let resource: Resource<UserListModel> = Resource(url: url, httpMethod: .get)
        apiClient.loadWithQue(resource: resource) { result in
            switch result{
            case .success(let result):
                print(result.count)
//                DatabaseService().clearData()
                completion(result,nil)
            case .failure(let error):
                print(error)
                completion(nil,error)
            }
        }
    }
    
    func getDetailFromServer(List: [UserListElement]) {
        for i in 0..<List.count {
            if let obj = List[i] as? UserListElement {
                getUserProfileWith(Name: obj.login ?? ""){result, error in
                    if error == nil {
                        UserProfileRepository().update(object: result!)
                    }
                }
            }
        }
    }
    
    func getUserProfileWith(
        Name: String,
        completion: @escaping (UserModel?, Error?) -> Void
    ) -> Void{
        let url = URL(string: "\(baseUrl)\(userProfile)\(Name)")!
        print(url)
        let resource: Resource<UserModel> = Resource(url: url, httpMethod: .get)
        apiClient.loadWithQue(resource: resource) { result in
            switch result{
            case .success(let result):
                print(result)
                completion(result, nil)
            case .failure(let error):
                print(error)
                completion(nil,error)
            }
        }
    }
    
}
