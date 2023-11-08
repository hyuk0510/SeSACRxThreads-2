//
//  SimpleValidationViewController.swift
//  SeSACRxThreads
//
//  Created by 선상혁 on 2023/11/08.
//

import UIKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class SimpleValidationViewController: UIViewController {
    
    let userNameOutlet = {
        let view = SignTextField(placeholderText: "userName")
        return view
    }()
    
    let userNameValidOutlet = {
        let view = UILabel()
        view.text = "Username has to be at least \(minimalUsernameLength) characters"
        view.textColor = .red
        return view
    }()
    
    let passwordOutlet = {
        let view = SignTextField(placeholderText: "password")
        return view
    }()
    
    let passwordValidOutlet = {
        let view = UILabel()
        view.text = "Password has to be at least \(minimalPasswordLength) characters"
        view.textColor = .red
        return view
    }()
    
    let somethingButton = {
        let view = PointButton(title: "Something")
        view.backgroundColor = .green
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
        
        let userNameValid = userNameOutlet.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
        
        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
        
        let allValid = Observable.combineLatest(userNameValid, passwordValid) { $0 && $1 }
        
        userNameValid
            .bind(to: passwordOutlet.rx.isEnabled, userNameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        allValid
            .bind(to: somethingButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        somethingButton.rx.tap
            .subscribe(with: self) { owner, value in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func configure() {
        [userNameOutlet, userNameValidOutlet, passwordOutlet, passwordValidOutlet, somethingButton].forEach { subview in
            view.addSubview(subview)
        }
        
        userNameOutlet.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        userNameValidOutlet.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(userNameOutlet.snp.horizontalEdges)
            make.top.equalTo(userNameOutlet.snp.bottom).offset(20)
        }
        
        passwordOutlet.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(userNameOutlet.snp.horizontalEdges)
            make.top.equalTo(userNameValidOutlet.snp.bottom).offset(20)
        }
        
        passwordValidOutlet.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(userNameOutlet.snp.horizontalEdges)
            make.top.equalTo(passwordOutlet.snp.bottom).offset(20)
        }
        
        somethingButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(userNameOutlet.snp.horizontalEdges)
            make.top.equalTo(passwordValidOutlet.snp.bottom).offset(20)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
