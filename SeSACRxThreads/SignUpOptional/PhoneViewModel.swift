//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 선상혁 on 2023/11/06.
//

import UIKit
import RxSwift

class PhoneViewModel {
    let buttonEnabled = BehaviorSubject(value: false)
    let buttonColor = BehaviorSubject(value: UIColor.red)
    let phoneNumber = BehaviorSubject(value: "010")
    let disposeBag = DisposeBag()
    
    init() {
        phoneNumber
            .map{ $0.count > 10 }
            .subscribe(with: self) { owner, value in
                let color: UIColor = value ? .blue : .red
                owner.buttonColor.onNext(color)
                owner.buttonEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
}
