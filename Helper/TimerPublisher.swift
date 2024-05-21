//
//  TimerPublisher.swift
//  Toe
//
//  Created by apple on 2023/8/7.
//

import Foundation
import SwiftUI
import Combine
 

class TimerOperation<T>: ObservableObject {
    var timer: Timer?
    var cancellables = Set<AnyCancellable>()
    var filterNil = false
    
    public func setNewTimer(input: AnyPublisher<T, Never>, operation: @escaping (T) -> (), threshold: Float){
        input
            .sink(receiveValue: { [weak self] value in
                self?.resetAndStartTimer(operation: operation, threshold: threshold, receivedValue: value)
            })
            .store(in: &cancellables)
    }
    
    public func cancel() {
        timer?.invalidate()
    }
    
    private func resetAndStartTimer(operation: @escaping (T) -> (), threshold: Float, receivedValue: T) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(threshold), repeats: false, block: {_ in
            operation(receivedValue)
        })
    }
}

