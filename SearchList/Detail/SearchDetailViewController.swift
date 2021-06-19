//
//  SearchDetailViewController.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit

class SearchDetailViewController: UIViewController {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var urlLinkLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {

    }

    @IBAction func touchDetailInfo(_ sender: Any) {
    }
}
