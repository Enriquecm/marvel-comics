//
//  MCCharactersViewController.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

class MCCharactersViewController: MCViewController {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet var searchBarCharacters: UISearchBar! {
        didSet {
            searchBarCharacters.searchBarStyle = .minimal
            searchBarCharacters.showsCancelButton = true
        }
    }

    // MARK: Properties
    fileprivate lazy var viewModel: MCCharactersViewModel = {
        return baseViewModel as? MCCharactersViewModel ?? MCCharactersViewModel()
    }()

    private let refreshControl = MCRefreshControl()
    private let transitionDelegate = MCTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupTableView()
        setupUI()
        setupViewModel()
    }

    // MARK: Methods
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
    }

    private func setupTableView() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupUI() {
        title = viewModel.title
        navigationController?.transitioningDelegate = transitionDelegate
        registerForPreviewing(with: self, sourceView: view)
    }

    private func setupViewModel() {
        viewModel.onDataSourceChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.stopLoading()
                self?.hideSearchBar()
            }
        }

        viewModel.onDataSourceFailed = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let action = UIAlertAction(title: "Try again", style: .default) { _ in
                    self?.refreshFeed()
                }
                self?.showAlert(with: "Failed to load characters.", message: errorMessage, action: action)
                self?.stopLoading()
                self?.hideSearchBar()
            }
        }

        viewModel.onCharacterSelected = { [weak self] characterViewModel in
            self?.showCharacterDetail(characterViewModel)
        }

        startLoading()
        viewModel.loadFeed()
    }

    @objc
    private func refreshFeed() {
        viewModel.loadFeed()
    }

    private func showCharacterDetail(_ characterViewModel: MCCharacterDetailViewModel) {
        let viewController = MCCharacterDetailViewController.initializeViewController(viewModel: characterViewModel)
        viewController.transitioningDelegate = transitionDelegate
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true, completion: nil)
    }

    private func startLoading() {
        tableView.tableHeaderView = nil
        refreshControl.beginRefreshing()
    }

    private func stopLoading() {
        tableView.tableHeaderView = searchBarCharacters
        refreshControl.endRefreshing()
    }

    private func hideSearchBar() {
        let point = CGPoint(x: 0, y: searchBarCharacters.frame.height)
        tableView.setContentOffset(point, animated: true)
    }
}

extension MCCharactersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(for: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = viewModel.identifier(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let characterCell = cell as? MCCharacterTableViewCell {
            let characterViewModel = viewModel.data(for: indexPath)
            characterCell.setup(withViewModel: characterViewModel)
        }
        return  cell
    }
}

extension MCCharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectItem(at: indexPath)

        guard let cell = tableView.cellForRow(at: indexPath) as? MCCharacterTableViewCell else { return }
        let frame = tableView.rectForRow(at: indexPath)
        let rect = CGRect(x: cell.imageViewCharacter.frame.minX, y: frame.minY, width: cell.imageViewCharacter.frame.width, height: cell.imageViewCharacter.frame.height)

        let openingFrame = tableView.convert(rect, to: tableView.superview)
        transitionDelegate.openingFrame = openingFrame
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.isLoadingIndexPath(indexPath) else { return }
        viewModel.fetchNextPage()
    }
}

extension MCCharactersViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        // Obtain the index path and the cell that was pressed.
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? MCCharacterTableViewCell else { return nil }

        // Set frame to open
        let frame = tableView.rectForRow(at: indexPath)
        let rect = CGRect(x: cell.imageViewCharacter.frame.minX, y: frame.minY, width: cell.imageViewCharacter.frame.width, height: cell.imageViewCharacter.frame.height)

        let openingFrame = tableView.convert(rect, to: tableView.superview)
        transitionDelegate.openingFrame = openingFrame

        let characterViewModel = viewModel.dataSource[indexPath.row]

        let viewController = MCCharacterDetailViewController.initializeViewController(viewModel: characterViewModel)
        viewController.transitioningDelegate = transitionDelegate
        viewController.modalPresentationStyle = .custom
        return viewController
    }
}
