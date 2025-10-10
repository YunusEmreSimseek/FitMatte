//
//  BaseViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 10.10.2025.
//
import Combine

protocol BaseViewModelProtocol: AnyObject {
    var state: ViewModelState { get }
}

class BaseViewModel: BaseViewModelProtocol {
    @Published private(set) var state: ViewModelState = .idle

    func setState(_ newState: ViewModelState) {
        state = newState
    }
}

enum ViewModelState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
