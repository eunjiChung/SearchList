//
//  SearchTableViewCell.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit
import SDWebImage

final class SearchTableViewCell: UITableViewCell {

    static let id = "SearchTableViewCell"

    @IBOutlet weak var docTypeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    var model: DocumentModel? {
        didSet {
            guard let model = model else { return }
            docTypeLabel.text = model.type.rawValue
            nameLabel.text = model.name
            titleLabel.text = model.title
            dateLabel.text = model.datetime

            if let url = URL(string: model.thumbnail) {
                thumbnailImageView.sd_setImage(with: url, completed: nil)
            }

            if model.isSelected {
                self.backgroundColor = .lightGray
            }
        }
    }
}
