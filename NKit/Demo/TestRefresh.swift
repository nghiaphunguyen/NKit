//
//  TestRefresh.swift
//  NKit
//
//  Created by Apple on 4/3/17.
//  Copyright © 2017 Nghia Nguyen. All rights reserved.
//

import UIKit



class TestRefreshViewController: NKBasePullingViewController {
    open override func getListView() -> NKListView {
        let tableView = NKTableView()
        return tableView
    }
    
    open override func getFooterLoadingView() -> NKListSupplementaryViewConfigurable.Type { fatalError() }
    
    open override func getLoadingView() -> NKViewShowAndHidable { fatalError() }
    
    open override func getErrorView() -> NKPullingRetryView { fatalError()}
    
    
    open override func getPopupErrorView() -> NKPullingRetryView { fatalError() }
    
    open override func getEmptyView() -> NKPullingRetryView { fatalError() }
    
    open override func getRefreshControl() -> UIRefreshControl { fatalError() }
}

class TestRefreshViewModel: NKBasePullingViewModel {
    
    
}
