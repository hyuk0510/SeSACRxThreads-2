//
//  NumbersViewModel.swift
//  SeSACRxThreads
//
//  Created by 선상혁 on 2023/11/07.
//

import Foundation
import RxSwift
import RxCocoa

class NumbersViewModel {
    let num1 = BehaviorSubject(value: "0")
    let num2 = BehaviorSubject(value: "0")
    let num3 = BehaviorSubject(value: "0")
        
    func result() -> Observable<Int> {
        return Observable.combineLatest(num1, num2, num3) { value1, value2, value3 -> Int in
            return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
        }
    }
}
