//
//  PageUpdateDelegate.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/23.
//

import UIKit

protocol PageUpdateDelegate: AnyObject {
    func tableView(insertAndUpdate indexPaths: [IndexPath])
    func tableView(_ isReloadAll: Bool)
    func setRefreshControl(_ target: Any?, selector: Selector)
}

extension UITableView: PageUpdateDelegate {
    func tableView(insertAndUpdate indexPaths: [IndexPath]) {
        self.performBatchUpdates ({
            self.insertRows(at: indexPaths, with: .none)
        }, completion: nil)

        if let visibleRows = self.indexPathsForVisibleRows {
            let intersectionRows = Set(indexPaths).intersection(Set(visibleRows))
            if intersectionRows.count > 0 {
                self.reloadRows(at: Array(intersectionRows), with: .none)
            }
        }
    }

    func tableView(_ isReloadAll: Bool) {
        if isReloadAll { self.reloadData() }
        refreshControl?.endRefreshing()
    }

    func setRefreshControl(_ target: Any?, selector: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: selector, for: .valueChanged)
        refreshControl.beginRefreshing()
        self.refreshControl = refreshControl
    }
}
