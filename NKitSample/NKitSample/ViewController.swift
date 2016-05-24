//
//  ViewController.swift
//  NKitSample
//
//  Created by Nghia Nguyen on 2/13/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit
import NKit
import TZStackView

//MARK: - Contants
private extension ViewController {
    struct Constant {
        static var NumOfRow: Int {return 5}
        static var CellIdentifier: String {return "NghiaCell"}
    }
}

//MARK: - Properties
class ViewController: UIViewController {
    private lazy var tableView: NKTableView = {
        let tableView = NKTableView()
        tableView.isHeightToFit = true
        tableView.dataSource = self
        tableView.registerClass(FilmCell.self, forCellReuseIdentifier: Constant.CellIdentifier)
        return tableView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(self.tableView)
        return scrollView
    }()
}

//MARK: - life cycle
extension ViewController {
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.setupView()
    }
}

private extension ViewController {
    func setupView() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(64)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.tableView.superview!)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.CellIdentifier, forIndexPath: indexPath)
        
        if let cell = cell as? FilmCell {
            var n = "123123123123 123123 123 123"
            for _ in 0...indexPath.row {
                n += n
            }
            
            cell.titleLable.text = n
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.NumOfRow
    }
}

class FilmCell: NKTableViewCell {
    private lazy var titleLable: UILabel = {
        let label = UILabel(text: "",
            font: UIFont.systemFontOfSize(14),
            color: UIColor.blackColor(),
            isSizeToFit: true,
            alignment: .Left)
        
        label.numberOfLines = 0
        return label
    }()
    
    override func setupView() {
        self.addSubview(self.titleLable)
        self.titleLable.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
        }
    }
}