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
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.isLoadingIndexPath(indexPath) else { return }
        viewModel.fetchNextPage()

        // Do any additional setup after loading the view.
    }
}
