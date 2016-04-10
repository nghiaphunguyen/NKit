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

class ViewController: UIViewController {

    var films = [Any]()
    
    lazy var stackView: NKStackView = {
        let stackView = NKStackView()
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .Fill
        stackView.dataSource = self
        stackView.registerView(FilmCell.self)
        stackView.registerView(Film2Cell.self)
        return stackView
    }()
    
    override func viewWillAppear(animated: Bool) {
        self.nk_setRightBarButton("Add new random film", selector: "tappedNewFilmButton").nk_setLeftBarButton("Remove a random film", selector: "tappedRemoveFilmButton")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tappedNewFilmButton() {
        let now = "\(NSDate().timeIntervalSince1970)"
        
        if rand() % 2 == 0 {
            self.films.append(Film(title: "nghia" + now, description: "hang " + now))
        } else {
            self.films.append(Film2(title: "nghia" + now, description: "hang " + now, actor: "hieu" + now))
        }
        
        self.stackView.reload(animate: true, duration: 0.5)
    }
    
    func tappedRemoveFilmButton() {
        guard self.films.count > 0 else {
            return
        }
        
        let index = Int(rand()) % self.films.count
        self.films.removeAtIndex(index)
        
        self.stackView.reload(animate: true, duration: 0.5)
    }
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        films.append(Film(title: "nghia", description: "hang 1"))
        films.append(Film(title: "nghia2", description: "hang 2 lajdfklajsdlkf jaklsdjflk"))
        films.append(Film(title: "nghia3", description: "hang 3 asdfljaslkdfjlaks"))
        films.append(Film2(title: "abc", description: "asdfsafdsasdfasdfasdfasdfadfasdfasdfasdf adfasdfasdfasdfasdfadf adfasdfadf", actor: "hieu"))
        films.append(Film(title: "nghia4", description: "hang 4 asdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaksasdfljaslkdfjlaks"))
        
        let scrollView = UIScrollView()
        scrollView.addSubview(self.stackView)
        
        self.view.addSubview(scrollView)
        
        scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.trailing.equalTo(0)
            make.leading.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        self.stackView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.trailing.equalTo(0)
            make.width.equalTo(self.stackView.superview!)
            make.leading.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        self.stackView.reload()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension ViewController: NKStackViewDataSource {
    func stackViewItems(stackView: NKStackView) -> [Any] {
        return self.films
    }
}

struct Film {
    var title = ""
    var description = ""
}

class FilmCell: NKBaseView, NKStackViewItemProtocol {
    typealias StackViewModel = Film
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "ajsdfklasdf", color: UIColor.blackColor(), isSizeToFit: true, alignment: .Left)
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel(text: "dafafsdf", color: UIColor.blackColor(), isSizeToFit: true, alignment: .Left)
        label.numberOfLines = 0
        return label
    }()
    
    override func setupView() {
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.descLabel)
        
        self.titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0).offset(5)
//            make.height.equalTo(50)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        
        self.descLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(5)
//            make.height.equalTo(50)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0).offset(-5)
        }
    }
    
    func stackView(stackView: NKStackView, configViewWithModel model: StackViewModel) {
        self.titleLabel.text = model.title
        self.descLabel.text = model.description
    }
}


struct Film2 {
    var title = ""
    var description = ""
    var actor = ""
}

class Film2Cell: NKBaseView, NKStackViewItemProtocol {
    typealias StackViewModel = Film2
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "ajsdfklasdf", color: UIColor.blackColor(), isSizeToFit: true, alignment: .Left)
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel(text: "dafafsdf", color: UIColor.blackColor(), isSizeToFit: true, alignment: .Left)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var actorLabel: UILabel = {
        let label = UILabel(text: "dafafsdf", color: UIColor.blackColor(), isSizeToFit: true, alignment: .Left)
        label.numberOfLines = 0
        return label
    }()
    
    override func setupView() {
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.descLabel)
        self.addSubview(self.actorLabel)
        
        self.titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0).offset(5)
            //            make.height.equalTo(50)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        
        self.descLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(5)
            //            make.height.equalTo(50)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        
        self.actorLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.descLabel.snp_bottom)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0).offset(-5)
        }
    }
    
    func stackView(stackView: NKStackView, configViewWithModel model: StackViewModel) {
        self.titleLabel.text = model.title
        self.descLabel.text = model.description
        self.actorLabel.text = model.actor
    }
}