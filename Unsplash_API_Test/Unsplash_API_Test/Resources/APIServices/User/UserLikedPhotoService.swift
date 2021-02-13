//
//  UserLikedPhotoService.swift
//  Unsplash_API_Test
//
//  Created by taehy.k on 2021/02/14.
//

import Foundation

import Alamofire

struct UserLikedPhotoService {
    static let shared = UserLikedPhotoService()
    
    func makeURL(clientID: String, username: String) -> String {
        var url = APIConstants.userLikedPhotoURL
        url = url.replacingOccurrences(of: "{client_id}", with: clientID)
        url = url.replacingOccurrences(of: ":username", with: username)
        return url
    }
    
    func getUserLikedPhoto(clientID: String, username: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = makeURL(clientID: clientID, username: username)
        print(url)
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default)
        dataRequest.responseData{ (response) in
            switch response.result{
                case .success:
                    guard let statusCode = response.response?.statusCode else{
                        return
                    }
                    guard let data = response.value else{
                        return
                    }
                    completion(judgeUserLikedPhoto(status: statusCode, data: data, url: url))
                case .failure(let err):
                    print(err)
                    completion(.networkFail)
            }
        }
    }
    
    private func judgeUserLikedPhoto(status: Int, data: Data, url: String) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode([Result].self, from: data) else{
            print("no data")
            return .pathErr
        }
        switch status{
            case 200:
                return .success(decodedData)
            case 400..<500:
                return .requestErr(decodedData)
            case 500:
                return .serverErr
            default:
                return .networkFail
        }
    }
}
