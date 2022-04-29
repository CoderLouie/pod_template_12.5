//
//  DebugViewController.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

fileprivate class TestCaseCell: BaseTableCell, Reusable {
}

fileprivate enum TestCase: String, CaseIterable {
    case kc_clear = "KeyChain 清除所有"
    
    case sub_style101 = "Subscribe 样式101"
    case sub_style102 = "Subscribe 样式102"
    
    case iap_getProducts = "IAP 获取所有商品"
    case iap_purchase = "IAP 购买商品"
    case iap_restore = "IAP 恢复购买"
    
    func perform(from vc: DebugViewController) {
        switch self {
        case .kc_clear:
            break
            
        case .sub_style101:
            break
        case .sub_style102:
            break
            
        case .iap_getProducts:
            break
        case .iap_purchase:
            break
        case .iap_restore:
            break
        }
    }
    
}

class DebugViewController: BaseViewController {
    
    override func setupViews() {
        super.setupViews()
        setupBody()
    }
    private unowned var tableView: UITableView!
    private lazy var items: [TestCase] = TestCase.allCases
}

// MARK: - Private
extension DebugViewController {
    private func test1() {
        
    }
    private func test2() {
        
    }
    private func test3() {
        
    }
}
// MARK: - Action
extension DebugViewController {
    @objc private func item1DidClick() {
        
    }
    @objc private func item2DidClick() {
        
    }
    @objc private func item3DidClick() {
        
    }
    
    override func backBarButtonItemClicked() {
        navigationController?.popToRootViewController(animated: true)
    }
}
// MARK: - Delegate
extension DebugViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TestCaseCell = tableView.dequeueReusableCell(for: indexPath)
        cell.textLabel?.text = String(format: "%02d. ", indexPath.row) + items[indexPath.row].rawValue
        return cell
    }
}
extension DebugViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].perform(from: self)
    }
}

// MARK: - Create Views
extension DebugViewController {
    
    private func setupBody() {
        navigationItem.title = "Debug"
        tableView = UITableView().then {
            $0.backgroundColor = .clear
            $0.tableFooterView = UIView()
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 45.fit
            $0.register(cellType: TestCaseCell.self)
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
