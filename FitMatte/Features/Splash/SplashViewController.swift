//
//  SplashViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import UIKit

final class SplashViewController: BaseViewController<SplashViewModel> {
    init() { super.init(viewModel: SplashViewModel()) }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await self.viewModel.checkUserAuthAndLoadData()
        }
    }
}

#Preview {
    SplashViewController()
}
