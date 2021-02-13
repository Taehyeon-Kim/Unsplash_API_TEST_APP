//
//  PhotoSingleService.swift
//  Unsplash_API_Test
//
//  Created by taehy.k on 2021/02/14.
//

import Foundation

import Alamofire

struct PhotoSingleService {
    static let shared = PhotoSingleService()
    
    func makeURL(clientID: String, id: String) -> String {
        var url = APIConstants.getPhotoURL
        url = url.replacingOccurrences(of: "{client_id}", with: clientID)
        url = url.replacingOccurrences(of: ":id", with: id)

        return url
    }
    
    func getSinglePhoto(clientID: String, id: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = makeURL(clientID: clientID, id: id)
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
                    completion(judgeSinglePhoto(status: statusCode, data: data, url: url))
                case .failure(let err):
                    print(err)
                    completion(.networkFail)
            }
        }
    }
    
    private func judgeSinglePhoto(status: Int, data: Data, url: String) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(PhotoSingleResponse.self, from: data) else{
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
