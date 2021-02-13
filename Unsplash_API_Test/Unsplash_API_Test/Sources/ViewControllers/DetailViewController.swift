//
//  DetailViewController.swift
//  Unsplash_API_Test
//
//  Created by taehy.k on 2021/02/14.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var fullImage: UIImageView!
    
    var fullImageURL: URL?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        print("DetailVC - viewDidLoad()")
        
        fullImage.kf.setImage(with: fullImageURL)
    }
    
    // MARK: - Custom Function
    func setData(url: URL) {
        fullImageURL = url
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
