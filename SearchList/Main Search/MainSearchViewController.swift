//
//  MainSearchViewController.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit

class MainSearchViewController: UIViewController {

    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!

    // EmtpyView 추가하기

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {
        let customFilterView = FilterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: filterView.frame.height))
        filterView.addSubview(customFilterView)
        customFilterView.selectFilter = { [weak self] type in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        customFilterView.touchSortButton = {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let titleButton = UIAlertAction(title: "Title", style: .default) { _ in
                self.tableView.reloadData()
            }
            let dateButton = UIAlertAction(title: "Date", style: .default) { _ in
                self.tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(titleButton)
            alert.addAction(dateButton)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }

}


extension MainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as! SearchTableViewCell
        return cell
    }
}


extension MainSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - 테이블 정보 보내주기
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
}

extension MainSearchViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: - sender 정보 받아와서 넘겨주기
        guard let dest = segue.destination as? SearchDetailViewController else { return }
    }
}
