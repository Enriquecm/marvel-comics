//
//  MCCharactersViewModel.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 05/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

final class MCCharactersViewModel: MCViewModel {

    private var shouldLoadNextPage = false

    private var characters: [MCModelCharacter] = [] {
        didSet {
            var viewModels = [MCCharacterDetailViewModel]()
            characters.forEach({ viewModels.append(MCCharacterDetailViewModel(character: $0, service: service)) })
            dataSource = viewModels
        }
    }

    private(set) var dataSource: [MCCharacterDetailViewModel] = [] {
        didSet {
            onDataSourceChanged?()
        }
    }

    private(set) var nameToSearch: String?
    private var currentOffset = 1
    let title = "Marvel Characterss"

    // MARK: Reactors
    var onDataSourceChanged: (() -> Void)?
    var onDataSourceFailed: ((String?) -> Void)?
    var onCharacterSelected: ((MCCharacterDetailViewModel) -> Void)?

    internal let service: DeadPoolProtocol

    init(service: DeadPoolProtocol = MarvelApplication.instance.service) {
        self.service = service
    }

    func loadFeed(forceRefresh: Bool = false) {
        let filter = MCFilterParameters(offset: currentOffset, limit: 20, nameStartsWith: nameToSearch)
        service.marvelCharacters(filterParameters: filter) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                self?.onDataSourceFailed?(error?.message)
                return
            }
            // Parse Characters
            let parser = MCParser<MCModelCharacterDataWrapper>()
            let result = try? parser.parse(from: data, with: parser.dateDecodingStrategy())
            let characters = result?.data?.results ?? []
            if forceRefresh {
                self?.characters = characters
            } else {
                self?.characters.append(contentsOf: characters)
            }
            if let offSet = result?.data?.offset, let count = result?.data?.count, let total = result?.data?.total {
                self?.shouldLoadNextPage = (offSet + count) <= total
            } else {
                self?.shouldLoadNextPage = false
            }
        }
    }

    func refreshCharacters() {
        currentOffset = 0
        loadFeed(forceRefresh: true)
    }

    func fetchNextPage() {
        currentOffset += 20
        loadFeed()
    }

    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldLoadNextPage else { return false }
        return indexPath.row == dataSource.count
    }

    // MARK: Search methods
    func searchCharacter(withName name: String?) {
        guard let name = name, name != "" else { return }
        nameToSearch = name
        loadFeed(forceRefresh: true)
    }

    func setupForNoSearching() {
        nameToSearch = nil
        loadFeed(forceRefresh: true)
    }

    // MARK: Data source methods
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItemsInSection(for section: Int) -> Int {
        let items = dataSource.count
        return shouldLoadNextPage ? items + 1 : items
    }

    func identifier(for indexPath: IndexPath) -> String {
        if isLoadingIndexPath(indexPath) {
            return MCLoadingTableViewCell.identifier
        } else {
            return MCCharacterTableViewCell.identifier
        }
    }

    func data(for indexPath: IndexPath) -> MCCharacterDetailViewModel? {
        guard !isLoadingIndexPath(indexPath) else { return nil }

        let row = indexPath.row
        guard row < dataSource.count else { return nil }
        return dataSource[row]
    }

    func didSelectItem(at indexPath: IndexPath) {
        guard !isLoadingIndexPath(indexPath) else { return }

        guard let character = data(for: indexPath) else { return }
        onCharacterSelected?(character)
    }
}
