//
//  SimplePickerViewExampleViewController.swift
//  SeSACRxThreads
//
//  Created by 선상혁 on 2023/11/08.
//

import UIKit
import RxSwift
import RxCocoa

class SimplePickerViewExampleViewController: UIViewController {
    
    let pickerView1 = {
        let view = UIPickerView()
        return view
    }()
    
    let pickerView2 = {
        let view = UIPickerView()
        return view
    }()
    
    let pickerView3 = {
        let view = UIPickerView()
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configure()
        bind()
    }
    
    func bind() {
        
        Observable.just([1, 2, 3])
            .bind(to: pickerView1.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        Observable.just([1, 2, 3])
            .bind(to: pickerView2.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item)",
                                          attributes: [
                                            NSAttributedString.Key.foregroundColor: UIColor.cyan,
                                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
                                        ])
            }
            .disposed(by: disposeBag)
        
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: pickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
    }
    
    func configure() {
        view.addSubview(pickerView1)
        view.addSubview(pickerView2)
        view.addSubview(pickerView3)
        
        pickerView1.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.snp.top)
            make.height.equalTo(200)
        }
        
        pickerView2.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(pickerView1.snp.bottom)
            make.height.equalTo(pickerView1.snp.height)
        }
        
        pickerView3.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(pickerView2.snp.bottom)
            make.height.equalTo(pickerView1.snp.height)
        }
    }
}
