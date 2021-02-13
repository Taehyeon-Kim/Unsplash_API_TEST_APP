//
//  APIConstants.swift
//  iOS-api-test
//
//  Created by taehy.k on 2021/02/08.
//

import Foundation

struct APIConstants {
    // 기본 url
    static let baseURL = "https://api.unsplash.com"
    
    // api-1: 사진 검색
    static let searchPhotosURL = baseURL + "/search/photos?client_id={client_id}&query={query}&page={page}"
    
    // api-2: 사용자 공개 프로필
    static let userProfileURL = baseURL + "/users/:username?client_id={client_id}"
    
    // api-3: 사용자 좋아요 사진 리스트
    static let userLikedPhotoURL = baseURL + "/users/:username/likes?client_id={client_id}"
}
