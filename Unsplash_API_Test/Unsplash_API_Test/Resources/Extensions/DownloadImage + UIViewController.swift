//
//  DownloadImage + UIViewController.swift
//  Unsplash_API_Test
//
//  Created by taehy.k on 2021/02/14.
//

import UIKit

extension UIViewController {
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, _, _ in
            DispatchQueue.main.async() {
                let activityViewController = UIActivityViewController(activityItems: [data ?? ""], applicationActivities: nil)
                activityViewController.modalPresentationStyle = .fullScreen
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
}
