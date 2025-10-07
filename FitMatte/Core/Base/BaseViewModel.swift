//
//  BaseViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Combine

@MainActor
protocol BaseViewModelProtocol: AnyObject {
    var state: ViewModelState { get set }
    func viewDidLoad()
}

@MainActor
class BaseViewModel: BaseViewModelProtocol {
    @Published var state: ViewModelState = .idle
    func viewDidLoad() {}
}

enum ViewModelState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
