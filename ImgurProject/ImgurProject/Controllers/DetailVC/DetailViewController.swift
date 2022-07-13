//
//  DetailViewController.swift
//  ImgurProject
//
//  Created by Fedii Ihor on 13.07.2022.
//

import UIKit
import SDWebImage
import SnapKit

class DetailViewController: UIViewController {

    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: .save,
                                  target: self,
                                  action: #selector(saveImage))
        return btn
    }()
    
    init(with link: String) {
        super.init(nibName: nil, bundle: nil)
        let url = URL(string: link)
        self.imageView.sd_setImage(with: url,
                                   placeholderImage: UIImage(systemName: "questionmark.circle"))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }
    
    @objc func saveImage() {
        print(#function)
    }
   
    func setupUI() {
        navigationItem.rightBarButtonItem = saveButton
        self.view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}


