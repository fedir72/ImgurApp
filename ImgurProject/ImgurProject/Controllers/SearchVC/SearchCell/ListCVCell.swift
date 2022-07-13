//
//  ListCVCell.swift
//  ImgurProject
//
//  Created by Fedii Ihor on 13.07.2022.
//

import UIKit
import SDWebImage

class ListCVCell: UICollectionViewCell {
    static let id = "ListCVCell"
    static func nib() -> UINib {
        return UINib(nibName: ListCVCell.id, bundle: nil)
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
    }
    
    func setupCell(with item: ImageItem) {
        titleLabel.text = item.titleText()
        let url = URL(string: item.link ?? "")
        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: ""))
    }

}
