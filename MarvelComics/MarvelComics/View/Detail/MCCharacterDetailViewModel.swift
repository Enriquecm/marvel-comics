//
//  MCCharacterDetailViewModel.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 06/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

protocol MCCharacterSummaryProtocol {
    var summaryName: String? { get }
}

final class MCCharacterDetailViewModel: MCViewModel {

    var name: String? {
        return character.name
    }

    var characterDescription: String? {
        return character.characterDescription
    }

    var imagePath: String? {
        return character.thumbnail?.completePath
    }

    var comicsAvailable: Int {
        return character.comics?.available ?? 0
    }

    var storiesAvailable: Int {
        return character.stories?.available ?? 0
    }

    var eventsAvailable: Int {
        return character.events?.available ?? 0
    }

    var seriesAvailable: Int {
        return character.series?.available ?? 0
    }

    var contentDataSource: [MCCharacterSummaryProtocol] {
        didSet {
            onDataSourceChanged?()
        }
    }

    // MARK: Reactors
    var onDataSourceChanged: (() -> Void)?

    private let character: MCModelCharacter
    private let service: DeadPoolProtocol

    init(character: MCModelCharacter, service: DeadPoolProtocol) {
        self.character = character
        self.service = service
        self.contentDataSource = character.comics?.items ?? []
    }

    func changeDataSource(forIndex index: Int) {
        switch index {
        case 0:
            contentDataSource = character.comics?.items ?? []
        case 1:
            contentDataSource = character.stories?.items ?? []
        case 2:
            contentDataSource = character.series?.items ?? []
        case 3:
            contentDataSource = character.events?.items ?? []
        default: break
        }
    }
}
