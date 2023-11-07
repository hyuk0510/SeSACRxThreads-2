//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by 선상혁 on 2023/11/07.
//

import UIKit
import RxSwift
import RxCocoa

class NicknameViewModel {
    let nicknameText = BehaviorSubject(value: "닉네임")
    let buttonEnabled = BehaviorSubject(value: false)
    let buttonColor = BehaviorSubject(value: UIColor.red)
    let disposeBag = DisposeBag()
    
    init() {
        nicknameText
            .map { $0.count > 3 }
            .subscribe(with: self) { owner, value in
                let color = value ? UIColor.blue : UIColor.red
                owner.buttonColor.onNext(color)
                owner.buttonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
}
