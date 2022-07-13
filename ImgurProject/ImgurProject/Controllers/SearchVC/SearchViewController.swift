//
//  ViewController.swift
//  ImgurProject
//
//  Created by Fedii Ihor on 12.07.2022.
//

import UIKit
import SafariServices
import SnapKit

private struct Constant {
    static let numberOfitemsInRow: CGFloat = 2
    static let minimumSpasing: CGFloat = 2
    static let searchbarHight: CGFloat = 50
}

class SearchViewController: UIViewController {
    let network = ImgurNetManager()
    
    private var datasourse = [ImageItem]() {
        didSet {
            collectionview.reloadData()
            print(datasourse)
        }
    }
    private var searchBarState: Bool = false {
        didSet {
           // print("change")
            searchbar.snp.updateConstraints {
                $0.height.equalTo(searchBarState ? 50 : 0)
            }
            UIView.animate(withDuration: 0.5,
                           delay: 0.1,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.2) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    lazy private var searchbar: UISearchBar = {
        let search = UISearchBar()
        return search
    }()
    
    lazy private var collectionview: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constant.minimumSpasing
        layout.minimumInteritemSpacing = Constant.minimumSpasing
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: Constant.minimumSpasing,
                                           bottom: 0,
                                           right: Constant.minimumSpasing)
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray4
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ListCVCell.nib(),
                                forCellWithReuseIdentifier: ListCVCell.id)
        return collectionView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Imgur images"
        addSubViews()
        network.downloadFotos(by: "red") { [weak self] json, err in
            DispatchQueue.main.async {
                guard let json = json else { return }
                self?.datasourse = json.data
            }
        }
    }
    
    @IBAction func turnOnSearchBar(_ sender: Any) {
        searchBarState.toggle()
    }
    
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasourse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = datasourse[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCVCell.id,for: indexPath) as? ListCVCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(with: item)
        return cell
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let item = datasourse[indexPath.item]
        guard let link = item.link else {
            self.someWrongAlert("Atension", "Some wrong, you can't go to this link")
            return
        }
        showDetailImage(with: link)
      }
    
}
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = datasourse[indexPath.row]
        let width = (view.bounds.width - (Constant.minimumSpasing*(Constant.numberOfitemsInRow+1)))/Constant.numberOfitemsInRow
        var height: CGFloat = width
        let divider = width/CGFloat(item.width ?? 0)
        if let h = item.height {
            height = CGFloat(h)*divider
        }
        return CGSize(width: width, height: height)
    }
}

private extension SearchViewController {
    
    func addSubViews() {
        view.addSubview(searchbar)
        view.addSubview(collectionview)
        setupConstraints()
    }
    
    func setupConstraints() {
        searchbar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        collectionview.snp.makeConstraints {
            $0.top.equalTo(searchbar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    func showDetailImage(with link: String) {
        if  (link.split(separator: ".").last ?? "") == "jpg" {
            let vc = DetailViewController(with: link )
            navigationController?.pushViewController(vc, animated: true)
        }else{
        guard let url = URL(string:link) else { return }
        let vc = SFSafariViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
