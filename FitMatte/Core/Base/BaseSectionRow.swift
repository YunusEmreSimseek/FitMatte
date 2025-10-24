//
//  BaseSectionRow.swift
//  FitMatte
//
//  Created by Emre Simsek on 15.10.2025.
//
import UIKit

protocol BaseSectionRowProtocol {
    var reuseId: String { get }
    func register(on tableView: UITableView)
    func dequeueAndConfigure(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func didSelect()
}

protocol ConfigurableCell {
    associatedtype ConfigurationView
    associatedtype ConfigurationCell
    func configureView(_ configuration: @escaping (ConfigurationView) -> Void)
    func configureCell(_ configuration: @escaping (ConfigurationCell) -> Void)
}

struct DataSectionRow<Cell: UITableViewCell>: BaseSectionRowProtocol where Cell: ConfigurableCell {
    let reuseId: String = .init(UUID().uuidString)
    private var configurationView: ((Cell.ConfigurationView) -> Void)?
    private var configurationCell: ((Cell.ConfigurationCell) -> Void)?
    private var configurationDidSelect: (() -> Void)?

    mutating func configureView(_ configuration: @escaping (Cell.ConfigurationView) -> Void) {
        configurationView = configuration
    }

    mutating func configureCell(_ configuration: @escaping (Cell.ConfigurationCell) -> Void) {
        configurationCell = configuration
    }

    mutating func configureDidSelect(_ configuration: @escaping () -> Void) {
        configurationDidSelect = configuration
    }

    func register(on tableView: UITableView) {
        tableView.register(Cell.self, forCellReuseIdentifier: reuseId)
    }
    
    mutating func clear() {
        configurationView = nil
        configurationCell = nil
        configurationDidSelect = nil
    }

    func dequeueAndConfigure(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? Cell else {
            assertionFailure("Failed to dequeue \(reuseId)")
            return UITableViewCell()
        }
        if let configurationView = configurationView {
            cell.configureView(configurationView)
        }
        if let configurationCell = configurationCell {
            cell.configureCell(configurationCell)
        }
        return cell
    }

    func didSelect() {
        configurationDidSelect?()
    }
}
