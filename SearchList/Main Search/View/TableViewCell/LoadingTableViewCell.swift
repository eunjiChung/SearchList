//
//  LoadingTableViewCell.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import UIKit

final class LoadingTableViewCell: UITableViewCell {

    static let id = "LoadingTableViewCell"

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    deinit {
        loadingIndicator.stopAnimating()
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
    }
}
