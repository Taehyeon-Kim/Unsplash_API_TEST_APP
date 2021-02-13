//
//  MainViewController.swift
//  iOS-api-test
//
//  Created by taehy.k on 2021/02/08.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    
    private var API_KEY: String = ""
    var photoData: [Result] = []
    var singlePhotoData: PhotoSingleResponse!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Custom Function
    
    func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        setupSearchBar()
        setupCollectionView()
    }
    
    /// 검색한 사진 가져오기
    func fetchSearchPhoto(query: String = "cat") {
        fetchAPIKey()
        PhotoSearchService.shared.getSearchPhoto(clientID: API_KEY, query: query, page: 1) { (result) -> (Void) in
            switch result {
            case .success(let data):
                if let response = data as? PhotoSearchResponse {
                    DispatchQueue.main.async {
                        self.photoData = response.results
                        self.collectionView.reloadData()
                    }
                }
            case .requestErr(let msg):
                print(msg)
            case .pathErr:
                print("path Err")
            case .serverErr:
                print("server Err")
            case .networkFail:
                print("network Fail")
            }
        }
    }
    
    func fetchSinglePhoto(photoID: String) {
        PhotoSingleService.shared.getSinglePhoto(clientID: API_KEY, id: photoID) { (result) -> (Void) in
            switch result {
            case .success(let data):
                if let response = data as? PhotoSingleResponse {
                    self.singlePhotoData = response
                }
            case .requestErr(let msg):
                print(msg)
            case .pathErr:
                print("path Err")
            case .serverErr:
                print("server Err")
            case .networkFail:
                print("network Fail")
            }
        }
    }
    
    /// Info.plist에 있는 API_KEY값 가져오기
    func fetchAPIKey(){
        if let infoDic: [String:Any] = Bundle.main.infoDictionary {
            if let UNSPLASH_API_KEY = infoDic["UNSPLASH_API_KEY"] as? String {
                API_KEY = UNSPLASH_API_KEY
            }
        }
    }
    
}

extension MainViewController {
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func setupCollectionView() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 셀 등록
        collectionView.register(PhotoCVC.self, forCellWithReuseIdentifier: PhotoCVC.identifier)
        
        // 콤포지셔널 레이아웃 등록
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            // 아이템에 대한 사이즈
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            // 아이템 사이즈로 아이템 만들기
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 5, bottom: 5, trailing: 5)
            
            // 그룹 사이즈
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/4))
            
            // 그룹 사이즈로 그룹 만들기
            /// count는 subitem의 개수이다
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
            // 그룹으로 섹션 만들기
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 15, leading: 10, bottom: 15, trailing: 10)
            return section
        }
        return layout
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            collectionView.reloadData()
            fetchSearchPhoto(query: text)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchSinglePhoto(photoID: photoData[indexPath.row].id)
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        if let url = URL(string: self.photoData[indexPath.row].urls.full) {
            detailVC.setData(url: url)
        } 
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true, completion: nil)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as? PhotoCVC else { return UICollectionViewCell() }
//        cell.likeButton.tag = indexPath.row
//        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked(_:)), for: .touchUpInside)
        cell.tag = indexPath.row
        cell.configure(with: photoData[indexPath.row].urls.full)
        return cell
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        let imgID = photoData[sender.tag].id
        print("아이디: \(imgID) - 클릭")
    }
}
