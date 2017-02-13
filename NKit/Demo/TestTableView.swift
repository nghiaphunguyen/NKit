//
//  TestTableView.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/9/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import NKit

class TestTableViewController: UIViewController {
    
    lazy var tableView = NKTableView(frame: .zero, style: .grouped)
    
    override func loadView() {
        super.loadView()
        
        self.view.nk_config {
            $0.backgroundColor = UIColor.white
            }.nk_addSubview(self.tableView) {
                $0.register(cellType: TestCell.self)
                $0.addSection(NKBaseTableSection.init(options: []))
                $0.backgroundColor = UIColor.white
                $0.estimatedRowHeight = 2
                $0.estimatedSectionHeaderHeight = 2
                $0.sectionFooterHeight = 0
                $0.rowHeight = 50
                $0.paging = true
                $0.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.updateFirstSection(withModels: [UIColor.green, UIColor.blue, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow, UIColor.yellow])
    }
}

extension UIColor: NKDiffable {
    public var diffIdentifier: String {
        return "\(self)"
    }
}

class TestCell: NKBaseTableViewCell {
    
    lazy var v: UIView = {
        return UIView()
    }()
    
    override func setupView() {
//        self.contentView.nk_addSubview(UILabel()) {
//            $0.text = "Nghiasdflajsdlfkjalsdkfjlaskdjflkasjdflkjasdlkf, Nghiasdflajsdlfkjalsdkfjlaskdjflkasjdflkjasdlkf, Nghiasdflajsdlfkjalsdkfjlaskdjflkasjdflkjasdlkf"
//            $0.sizeToFit()
//            $0.numberOfLines = 0
//            $0.snp.makeConstraints({ (make) in
//                make.edges.equalToSuperview()
//            })
//        }
        
        self.contentView.nk_addSubview(self.v) {
            $0.backgroundColor = UIColor.green
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(50)
            })
        }
    }
}

extension TestCell: NKListViewCellConfigurable {
    typealias ViewCellModel = UIColor
    
    func tableView(_ tableView: NKTableView, configWithModel model: UIColor, atIndexPath indexPath: IndexPath) {
        self.v.backgroundColor = model
    }
    
    static func height(withTableView tableView: NKTableView, section: NKTableSection, model: UIColor) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

class HeaderCell: NKTableHeaderFooterView, NKIdentifier {
    override func setupView() {
        
//        self.contentView
//            .nk_config {
//                $0.backgroundColor = UIColor.blue
//            }.nk_addSubview(UILabel()) {
//            $0.text = "HeaderHeaderHeaderHeaderHeaderHeaderHeaderHeader"
//            $0.sizeToFit()
//            $0.numberOfLines = 0
//            $0.snp.makeConstraints({ (make) in
//                make.edges.equalToSuperview()
//            })
//        }
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.nk_addSubview(UIView()) {
            $0.backgroundColor = UIColor.blue
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(100)
                make.width.equalTo(NKScreenSize.Current.width)
            })
        }

    }
}

//extension TestTableViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 20
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: TestCell.identifier, for: indexPath)
//        return cell
//    }
//}
//
//extension TestTableViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        if indexPath.row == 0 {
////            return 20
////        }
//        let height = UITableViewAutomaticDimension
//        
//        print("height=\(height) forTableViewCell at indexPath=\(indexPath)")
//        return height
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let height = UITableViewAutomaticDimension
//        print("height=\(height) forheader ofSection=\(section)")
//        return height
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let height: CGFloat = UITableViewAutomaticDimension
//        print("height=\(height) forFooter ofSection=\(section)")
//        return height
//    }
//    
////    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
////        let height: CGFloat = 10
////        print("estimatedHeight=\(height) forFooter ofSection=\(section)")
////        return height
////    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderCell.identifier)
//        switch section {
//        case 0:
//            view?.contentView.subviews.first?.backgroundColor = UIColor.blue
//        case 1:
//            view?.contentView.subviews.first?.backgroundColor = UIColor.yellow
//        default:
//            view?.contentView.subviews.first?.backgroundColor = UIColor.purple
//        }
//        print("header=\(view) for section=\(section)")
//        return view
//    }
//}
