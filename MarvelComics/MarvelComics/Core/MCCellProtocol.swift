//
//  MCCellProtocol.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 06/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

protocol MCCellProtocol: class {
    static var identifier: String { get }
}

extension MCCellProtocol where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension MCCellProtocol where Self: UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension MCCellProtocol where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

protocol MCSetupCellProtocol: MCCellProtocol {
    associatedtype ModelType

    func setup(with model: ModelType?)
}

protocol MCViewModelSetupCellProtocol: MCCellProtocol {
    associatedtype ViewModelType: MCViewModel

    func setup(withViewModel viewModel: ViewModelType?)
}
