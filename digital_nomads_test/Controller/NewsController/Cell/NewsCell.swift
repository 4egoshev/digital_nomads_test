//
//  NewsCell.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 27.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsCell: UITableViewCell {
    
    @IBOutlet private weak var photo: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    struct Model {
        let title: String?
        let description: String?
        let imageUrl: URL?
    }
    
    var model: Model? {
        didSet {
            titleLabel.text = model?.title
            descriptionLabel.text = model?.description
            guard let url = model?.imageUrl else { return }
            photo.af_setImage(withURL: url, placeholderImage: Image.placeholder)
        }
    }
}
