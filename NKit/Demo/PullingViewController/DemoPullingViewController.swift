//
//  DemoPullingViewController.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/19/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit
import RxSwift

class FooterLoadingView: NKTableHeaderFooterView, NKListSupplementaryViewConfigurable {
    override func setupView() {
        self.contentView.nk_config {
            $0.backgroundColor = UIColor.green
            $0.clipsToBounds = true
            }.nk_addSubview(UILabel()) {
                $0.text = "Loading..."
                $0.sizeToFit()
                $0.textAlignment = .center
                $0.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
        }
    }
    
    func tableView(_ tableView: NKTableView, configWithModel model: Any, at section: Int) {
        print("Footer Model: \(model)")
        if let model = model as? Bool, model == true, tableView.contentSize.height >= tableView.nk_height {
            self.contentView.isHidden = false
        } else {
            self.contentView.isHidden = true
        }
    }
    
    static func height(withTableView tableView: NKTableView, section: NKTableSection, model: Any?) -> CFloat {
        return 50
    }
}

class LoadingView: NKBaseView, NKViewShowAndHidable {
    override func setupView() {
        self.nk_addSubview(UILabel()) {
            $0.textAlignment = .center
            $0.sizeToFit()
            $0.text = "Loading..."
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
    }
}

class EmptyView: NKBaseView, NKPullingRetryView {
    var tappedRetryButtonObservable: Observable<Void>? {
        return nil
    }
}


class PopupView: NKBaseView, NKPullingRetryView {
    var tappedRetryButtonObservable: Observable<Void>? {
        return nil
    }
    
    override func setupView() {
        self.nk_addSubview(UIView()) {
            $0.backgroundColor = UIColor.red
            $0.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(100)
            })
        }
    }
}

class DemoPullingViewController: NKBasePullingViewController {
    override func getFooterLoadingView() -> NKListSupplementaryViewConfigurable.Type {
        return FooterLoadingView.self
    }
    
    override func getLoadingView() -> NKViewShowAndHidable {
        return LoadingView()
    }
    
    override func getEmptyView() -> NKPullingRetryView {
        return EmptyView()
    }
    
    override func getRefreshControl() -> UIRefreshControl {
        return UIRefreshControl()
    }
    
    override func getErrorView() -> NKPullingRetryView {
        return EmptyView()
    }
    
    override func getPopupErrorView() -> NKPullingRetryView {
        return PopupView()
    }
}
