//
//  NumbersViewController.swift
//  SeSACRxThreads
//
//  Created by 선상혁 on 2023/11/07.
//

import UIKit
import RxSwift
import RxCocoa

class NumbersViewController: UIViewController {
    
    let number1 = SignTextField(placeholderText: "")
    let number2 = SignTextField(placeholderText: "")
    let number3 = SignTextField(placeholderText: "")
    
    let result = UILabel()
    
    let viewModel = NumbersViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        bind()
        constraints()
    }
    
    
    func bind() {
        
        viewModel.num1
            .bind(to: number1.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.num2
            .bind(to: number2.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.num3
            .bind(to: number3.rx.text)
            .disposed(by: disposeBag)
        
        number1.rx.text.orEmpty
            .subscribe(with: viewModel) { owner, value in
                owner.num1.onNext(value)
            }
            .disposed(by: disposeBag)
        
        number2.rx.text.orEmpty
            .subscribe(with: viewModel) { owner, value in
                owner.num2.onNext(value)
            }
            .disposed(by: disposeBag)
        
        number3.rx.text.orEmpty
            .subscribe(with: viewModel) { owner, value in
                owner.num3.onNext(value)
            }
            .disposed(by: disposeBag)
        
        viewModel.result()
            .map { $0.description }
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
    
    func constraints() {
        view.addSubview(number1)
        view.addSubview(number2)
        view.addSubview(number3)
        view.addSubview(result)
    
        number1.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        number2.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(number1.snp.horizontalEdges)
            make.top.equalTo(number1.snp.bottom).offset(20)
        }
        
        number3.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(number1.snp.horizontalEdges)
            make.top.equalTo(number2.snp.bottom).offset(20)
        }
        
        result.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(number1.snp.horizontalEdges)
            make.top.equalTo(number3.snp.bottom).offset(40)
        }
    }
}
