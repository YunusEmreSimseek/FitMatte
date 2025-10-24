//
//  AppMode.swift
//  FitMatte
//
//  Created by Emre Simsek on 20.10.2025.
//
import Foundation

enum AppMode {
    static var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        true
        #else
        false
        #endif
    }

    static var isDebug: Bool {
        #if DEBUG
        true
        #else
        false
        #endif
    }
}
