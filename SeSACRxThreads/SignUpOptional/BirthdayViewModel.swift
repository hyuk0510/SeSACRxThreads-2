//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 선상혁 on 2023/11/03.
//

import Foundation
import RxSwift

class BirthdayViewModel {
    let birthday = BehaviorSubject(value: Date.now)
    let year = BehaviorSubject(value: 1997)
    let month = BehaviorSubject(value: 5)
    let day = BehaviorSubject(value: 10)
    
    let disposeBag = DisposeBag()

   init() {
       
        birthday
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                owner.year.onNext(component.year!)
                owner.month.onNext(component.month!)
                owner.day.onNext(component.day!)
            }
            .disposed(by: disposeBag)
    }
}
