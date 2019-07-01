//
//  ListCollectionViewCell.swift
//  SahibindenCase
//
//  Created by salih topcu on 27.06.2019.
//  Copyright © 2019 salih topcu. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellİmageView: ImageLoader!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .white
    }
    
    func setView(imageUrl: String, title: String, trackName: String){
        titleLabel.text = title
        trackNameLabel.text = trackName
        guard let imgUrl = URL(string: imageUrl) else {return}
        cellİmageView.loadImageWithUrl(imgUrl)
        cellİmageView.layer.borderWidth = 2
        cellİmageView.layer.borderColor = UIColor.yellow.cgColor
    }

}
