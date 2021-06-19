//
//  SearchDetailViewController.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit
import SDWebImage

class SearchDetailViewController: UIViewController {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var urlLinkLabel: UILabel!

    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    lazy var viewModel: SearchDetailViewModel = {
        return SearchDetailViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {
        guard let model = viewModel.documentModel else { fatalError() }

        self.title = model.type.rawValue

        if let url = URL(string: model.thumbnail) {
            contentImageView.sd_setImage(with: url) { image, _, _, _ in
                if let image = image {
                    let height: CGFloat = self.contentImageView.frame.size.width * image.size.height / image.size.width
                    self.imageViewHeightConstraint.constant = height
                    self.view.setNeedsLayout()
                }
            }
        }

        typeLabel.text = model.name
        titleLabel.text = model.title
        contentLabel.text = model.contents
        dateLabel.text = model.datetime
        urlLinkLabel.text = model.url
    }

    @IBAction func touchDetailInfo(_ sender: Any) {
        performSegue(withIdentifier: "showWebPage", sender: viewModel.documentModel?.url)
    }
}

extension SearchDetailViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailWebViewController,
           let url = sender as? String {

        }
    }
}
