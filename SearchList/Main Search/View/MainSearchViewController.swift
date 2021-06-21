//
//  MainSearchViewController.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit

class MainSearchViewController: UIViewController {

    @IBOutlet weak var filterView: FilterView!
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    let searchView = CustomSearchBarView()

    var viewModel: SearchViewModel!

    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView(frame: tableView.bounds)
        emptyView.isHidden = true
        return emptyView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initViewModel()
    }

    private func initView() {
        navigationItem.titleView = searchView

        tableView.backgroundView = emptyView
        tableView.estimatedRowHeight = 122.0

        searchView.searchKeyword = { [weak self] keyword in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.hideKeyboard()
        }

        filterView.selectFilter = { [weak self] type in
            guard let self = self else { return }
            self.viewModel.filter = type
        }
        filterView.touchSortButton = {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let titleButton = UIAlertAction(title: "Title", style: .default) { _ in self.viewModel.sort = .title }
            let dateButton = UIAlertAction(title: "Date", style: .default) { _ in self.viewModel.sort = .datetime }
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
        viewModel = SearchViewModel(delegate: self)
        viewModel.query = "아이유"

        viewModel.request()
    }

    @objc func hideKeyboard() {
        searchView.endEditing(true)
    }

    private func reloadTable(_ completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.emptyView.isHidden = self.viewModel.isListEmpty

            if self.viewModel.isFirstPage {
                self.tableView.reloadData()
            } else {
                self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows ?? [], with: .none)
            }

            if self.tableView.refreshControl?.isRefreshing ?? false {
                self.tableView.refreshControl?.endRefreshing()
            }

            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

            completion?()
        }
    }
}

extension MainSearchViewController: SearchViewModelDelegate {
    func onFetchCompleted(with indexPaths: [IndexPath]?, completion: (() -> Void)?) {
        guard let newIndexPaths = indexPaths else {
            reloadTable { completion?() }
            return
        }

        DispatchQueue.main.async {
            self.tableView.performBatchUpdates {
                if self.viewModel.isEnd {
                    self.tableView.deleteRows(at: [IndexPath(row: self.viewModel.deleteIndex, section: 0)], with: .fade)
                }
                self.tableView.insertRows(at: newIndexPaths, with: .fade)
            } completion: { _ in
                completion?()
            }
        }
    }

    func onFetchFailed(completion: (() -> Void)?) {
        let alert = UIAlertController(title: "알림", message: "데이터 가져오기에 실패했습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)

        completion?()
    }
}

extension MainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingPosition(of: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.id, for: indexPath) as! LoadingTableViewCell
            cell.startLoading()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as! SearchTableViewCell
            cell.model = viewModel.exposingList[indexPath.row]
            return cell
        }
    }

    private func isLoadingPosition(of indexPath: IndexPath) -> Bool {
        return !viewModel.isEnd && indexPath.row == viewModel.rowCount-1
    }
}

extension MainSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: viewModel.exposingList[indexPath.row])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY: CGFloat = scrollView.contentOffset.y
        let isScrollDown: Bool = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        let isLoadingPosition: Bool = (contentOffsetY + scrollView.frame.size.height) >= scrollView.contentSize.height

        if contentOffsetY > 50 || contentOffsetY < (scrollView.frame.size.height - 50) {
            changeFilterView(isScrollDown)
        }

        if isLoadingPosition {
            viewModel.request()
        }
    }

    private func changeFilterView(_ isScrollDown: Bool) {
        if filterView.isHidden && isScrollDown { return }
        filterView.isHidden = isScrollDown
        filterViewHeightConstraint.constant = isScrollDown ? 0 : 50
    }
}

extension MainSearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchDetailViewController,
           let model = sender as? Document {
            dest.viewModel.documentModel = model
        }
    }
}
