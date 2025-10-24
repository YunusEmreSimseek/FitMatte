//
//  BaseViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 10.10.2025.
//
import Combine
import UIKit

class BaseViewController<VM: BaseViewModel>: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var tableView = UITableView(frame: .zero, style: .grouped)
    let viewModel: VM
    private var sections: [BaseSection] = []
    private var registeredReuseIds = Set<String>()
    var cancellables = Set<AnyCancellable>()
    private lazy var loadingView: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .large)
        v.hidesWhenStopped = true
        return v
    }()

    private let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addAction(UIAction { _ in
            print("Refresh triggered")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                rc.endRefreshing()
            }
        }, for: .valueChanged)
        return rc
    }()

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        setupBindings()
        registerDynamicBackgroundColor()
        setBackgroundColor()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.indices.contains(section) else { return 0 }
        return sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sections.indices.contains(section) else { return nil }
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sections[section].header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        sections[section].footer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        return row.dequeueAndConfigure(from: tableView, at: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].rows[indexPath.row].didSelect()
    }
}

// MARK: - Usable but not overridable Methods
extension BaseViewController {
    func setupUI(animated: Bool = false) {
        guard !sections.isEmpty else { return }

        sections.flatMap { $0.rows }.forEach { row in
            if registeredReuseIds.insert(row.reuseId).inserted {
                row.register(on: tableView)
            }
        }

        if animated {
            tableView.performBatchUpdates({
                tableView.reloadSections(IndexSet(integersIn: 0 ..< max(1, sections.count)), with: .automatic)
            }, completion: nil)
        } else {
            tableView.reloadData()
        }
    }

    func addSection(_ rows: [BaseSectionRowProtocol], title: String? = nil, header: UIView? = nil, footer: UIView? = nil) {
        let section = BaseSection(rows, title: title, header: header, footer: footer)
        sections.append(section)
        setupUI()
    }

    func scrollToBottom(_ animated: Bool = false) {
        let sectionCount = tableView.numberOfSections
        guard sectionCount > 0 else { return }
        let lastSection = sectionCount - 1
        let rowCount = tableView.numberOfRows(inSection: lastSection)
        guard rowCount > 0 else { return }
        let lastRow = rowCount - 1
        let indexPath = IndexPath(row: lastRow, section: lastSection)
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }

    func changeTableStyle(_ style: UITableView.Style) {
        tableView.removeFromSuperview()
        tableView = UITableView(frame: .zero, style: style)
        setupTableView()
    }

    func changeTableSeparatorStyle(_ style: UITableViewCell.SeparatorStyle) {
        tableView.separatorStyle = style
    }

    func addFooterView(_ footerView: UIView) {
        view.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12).isActive = true
        footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -(12 + footerView.frame.height)).isActive = true
    }

    func cleanTable() {
        sections.removeAll()
        registeredReuseIds.removeAll()
        tableView.reloadData()
    }

    func setTableHeight(_ height: CGFloat) {
        tableView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setRefreshAction(_ action: UIAction) {
        refreshControl.addAction(action, for: .valueChanged)
    }

    func addAllPadding(_ padding: CGFloat = 16) {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ])
    }
}

// MARK: - Private Methods
extension BaseViewController {
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.cornerConfiguration = .corners(radius: 0)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func registerDynamicBackgroundColor() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.setBackgroundColor()
        }
    }

    private func setBackgroundColor() {
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .secondarySystemBackground
        } else {
            view.backgroundColor = .systemBackground
        }
    }

    private func showLoading() {
        if loadingView.superview == nil {
            view.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            loadingView.startAnimating()
            tableView.isUserInteractionEnabled = false
        }
        else {
            loadingView.startAnimating()
            tableView.isUserInteractionEnabled = false
        }
    }

    private func hideLoading() {
        loadingView.stopAnimating()
        tableView.isUserInteractionEnabled = true
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    private func setupBindings() {
        viewModel.$state
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self else { return }
                self.handleState(state)
            }
            .store(in: &cancellables)
    }

    private func handleState(_ state: ViewModelState) {
        switch state {
        case .loading:
            showLoading()
        case .error(let msg):
            showError(msg)
        default:
            hideLoading()
        }
    }
}

// extension UITableViewCell {
//    func of<T: UITableViewCell>(_ type: T.Type) -> T? { self as? T }
// }
