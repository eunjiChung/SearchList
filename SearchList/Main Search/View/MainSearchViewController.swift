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

    let searchView = CustomSearchBarView()

    lazy var customFilterView = {
        return FilterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: filterView.frame.height))
    }()

    var scrollOffsetY: CGFloat = 0 {
        didSet {
            guard scrollOffsetY > 50 else { return }
            changeFilterView(oldValue < scrollOffsetY)
        }
    }

    lazy var viewModel: MainSearchViewModel = {
        return MainSearchViewModel()
    }()

    // EmtpyView 추가하기

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initViewModel()
    }

    private func initView() {
        navigationItem.titleView = searchView
        searchView.searchKeyword = { [weak self] keyword in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.hideKeyboard()
        }

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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }

    private func initViewModel() {
        viewModel.requestSearch()

        viewModel.didFinishRequest = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.emptyView.isHidden = self.viewModel.resultModel.count > 0
                self.tableView.reloadData()
            }
        }
    }

    @objc func hideKeyboard() {
        searchView.endEditing(true)
    }

    private func changeFilterView(_ isScrollDown: Bool) {
        if filterView.isHidden && isScrollDown { return }
        filterView.isHidden = isScrollDown
        filterViewHeightConstraint.constant = isScrollDown ? 0 : 50
    }
}


extension MainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.resultModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as! SearchTableViewCell
        cell.updateSelectedStatus = { 
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.model = viewModel.resultModel[indexPath.row]
        return cell
    }
}


extension MainSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - 테이블 정보 보내주기
        performSegue(withIdentifier: "showDetail", sender: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY: CGFloat = scrollView.contentOffset.y
        scrollOffsetY = contentOffsetY
    }
}

extension MainSearchViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: - sender 정보 받아와서 넘겨주기
        guard let dest = segue.destination as? SearchDetailViewController else { return }
    }
}
