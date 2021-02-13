//
//  PhotoSearchData.swift
//  iOS-api-test
//
//  Created by taehy.k on 2021/02/08.
//
import Foundation

struct PhotoSearchResponse: Codable {
    var total: Int
    var total_pages: Int
    var results: [Result]
}

struct Result: Codable {
    var id: String
    var urls: URLS
}

struct URLS: Codable {
    var full: String
}
