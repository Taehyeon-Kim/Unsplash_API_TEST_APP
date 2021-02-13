//
//  PhotoCVC.swift
//  iOS-api-test
//
//  Created by taehy.k on 2021/02/08.
//

import UIKit

import Kingfisher

class PhotoCVC: UICollectionViewCell {
    static let identifier = "PhotoCVC"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
//    let likeButton: UIButton = {
//        let likeButton = UIButton()
//        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        likeButton.tintColor = .white
//        likeButton.backgroundColor = .darkGray
//        likeButton.frame = CGRect(x: 150, y: 5, width: 30, height: 30)
//        likeButton.clipsToBounds = true
//        return likeButton
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        // 이미지뷰에 하위뷰로 넣는 것이 아닌 콜렉션뷰셀의 하위뷰로 넣어야 함!
//        self.addSubview(likeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        imageView.layer.cornerRadius = 10
//        likeButton.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.main.async {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        }
    }
}
