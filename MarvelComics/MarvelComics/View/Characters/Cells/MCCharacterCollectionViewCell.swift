//
//  MCCharacterCollectionViewCell.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 06/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

class MCCharacterTableViewCell: UITableViewCell, MCCellProtocol {

    // MARK: Outlets
    @IBOutlet weak var viewBackground: UIView! {
        didSet {
            setupBackgroundShadow()
        }
    }
    @IBOutlet weak var imageViewCharacter: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelComics: UILabel!
    @IBOutlet weak var labelSeries: UILabel!
    @IBOutlet weak var labelStories: UILabel!
    @IBOutlet weak var labelEvents: UILabel!

    // MARK: Properties
    private var viewModel: MCCharacterDetailViewModel? {
        didSet {
            setupUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        clearInformation()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearInformation()
    }

    func setup(withViewModel viewModel: MCCharacterDetailViewModel?) {
        self.viewModel = viewModel
    }

    private func setupUI() {
        labelName.text = viewModel?.name
        labelComics.text = String(viewModel?.comicsAvailable ?? 0)
        labelSeries.text = String(viewModel?.seriesAvailable ?? 0)
        labelStories.text = String(viewModel?.storiesAvailable ?? 0)
        labelEvents.text = String(viewModel?.eventsAvailable ?? 0)
        imageViewCharacter.loadImage(withFilePath: viewModel?.imagePath)
    }

    private func clearInformation() {
        labelName.text = ""
        labelComics.text = "--"
        labelSeries.text = "--"
        labelStories.text = "--"
        labelEvents.text = "--"
        imageViewCharacter.image = nil
    }

    private func setupBackgroundShadow() {
        viewBackground.layer.shadowColor = UIColor.black.cgColor
        viewBackground.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewBackground.layer.shadowRadius = viewBackground.cornerRadius
        viewBackground.layer.shadowOpacity = 0.12
        viewBackground.layer.masksToBounds = false
        viewBackground.clipsToBounds = false
    }
}
