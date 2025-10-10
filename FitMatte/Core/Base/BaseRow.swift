//
//  BaseRow.swift
//  FitMatte
//
//  Created by Emre Simsek on 10.10.2025.
//
import UIKit

protocol AnyRow {
    var reuseId: String { get }
    func register(on tableView: UITableView)
    func dequeueAndConfigure(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func didSelect()
}

struct BaseRow<Cell: UITableViewCell>: AnyRow {
    let reuseId: String = .init(describing: Cell.self)
    var configure: ((Cell) -> Void)?
    var onSelect: (() -> Void)?

    func register(on tableView: UITableView) {
        tableView.register(Cell.self, forCellReuseIdentifier: reuseId)
    }

    func dequeueAndConfigure(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? Cell else {
            assertionFailure("Failed to dequeue \(reuseId)")
            return UITableViewCell()
        }
        configure?(cell)
        return cell
    }

    func didSelect() { onSelect?() }
}

struct BaseSection {
    var rows: [AnyRow]
    var title: String?

    init(_ rows: [AnyRow], title: String? = nil) {
        self.rows = rows
        self.title = title
    }
}
