//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by 선상혁 on 2023/11/09.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class SearchViewController: UIViewController {
    
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    private let searchBar = UISearchBar()

    private var data: [AppInfo] = []
    
    lazy var items = BehaviorSubject(value: data)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        bind()
    }
    
    private func bind() {
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.appNameLabel.text = element.trackName
                let url = URL(string: element.artworkUrl512)
                cell.appIconImageView.kf.setImage(with: url)
                
                cell.downloadButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        let vc = SampleViewController()
                        vc.title = element.trackName
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        let request = BasicAPIManager
            .fetchData()
            .asDriver(onErrorJustReturn: SearchAppModel(resultCount: 0, results: []))
        
        request
            .drive(with: self) { owner, value in
                owner.items.onNext(value.results)
            }
            .disposed(by: disposeBag)
        
        request
            .map { "\($0.resultCount)개의 검색 결과" }
            .drive(with: self) { owner, value in
                owner.navigationItem.title = value
            }
            .disposed(by: disposeBag)
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
