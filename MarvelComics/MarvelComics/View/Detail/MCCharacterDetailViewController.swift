//
//  MCCharacterDetailViewController.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 07/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

class MCCharacterDetailViewController: MCViewController {

    // MARK: Outlets
    @IBOutlet weak var gradientView: MCGradientView!
    @IBOutlet weak var viewBackground: UIView! {
        didSet {
            setupBackgroundShadow()
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var imageViewDetail: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties
    fileprivate lazy var viewModel: MCCharacterDetailViewModel? = {
        return baseViewModel as? MCCharacterDetailViewModel
    }()
    private var childScrollingDownDueToParent = false
    private var childScrollView: UIScrollView {
        return tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupTableView()
        setupUI()
        setupViewModel()
    }

    private func setupScrollView() {
        scrollView.delegate = self
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupUI() {
        gradientView.colors = [UIColor(red: 255, green: 255, blue: 255, alpha: 0.3), .white]
        imageViewBackground.loadImage(withFilePath: viewModel?.imagePath)
        imageViewDetail.loadImage(withFilePath: viewModel?.imagePath)
        labelName.text = viewModel?.name
    }

    private func setupViewModel() {
        viewModel?.onDataSourceChanged = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func setupBackgroundShadow() {
        viewBackground.layer.shadowColor = UIColor.black.cgColor
        viewBackground.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewBackground.layer.shadowRadius = viewBackground.cornerRadius
        viewBackground.layer.shadowOpacity = 0.4
        viewBackground.layer.masksToBounds = false
        viewBackground.clipsToBounds = false
    }

    // MARK: Actions
    @IBAction func segmentedControlDidChanged(_ sender: UISegmentedControl) {
        viewModel?.changeDataSource(forIndex: sender.selectedSegmentIndex)
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension MCCharacterDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.contentDataSource.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        let data = viewModel?.contentDataSource[indexPath.row]
        cell.textLabel?.text = data?.summaryName
        return cell
    }
}

extension MCCharacterDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: Go to information detail
    }
}

extension MCCharacterDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ _scrollView: UIScrollView) {
        let parentViewMaxContentYOffset = scrollView.contentSize.height - scrollView.frame.height
        if _scrollView.panGestureRecognizer.translation(in: _scrollView).y < 0 {
            // Going up
            if _scrollView == childScrollView {
                if scrollView.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {

                    scrollView.contentOffset.y = min(scrollView.contentOffset.y + childScrollView.contentOffset.y, parentViewMaxContentYOffset)
                    childScrollView.contentOffset.y = 0
                }
            }
        } else {
            if _scrollView == childScrollView {
                if childScrollView.contentOffset.y < 0 && scrollView.contentOffset.y > 0 {
                    scrollView.contentOffset.y = max(scrollView.contentOffset.y - abs(childScrollView.contentOffset.y), 0)
                }
            }
            if _scrollView == scrollView {
                if childScrollView.contentOffset.y > 0 && scrollView.contentOffset.y < parentViewMaxContentYOffset {

                    childScrollingDownDueToParent = true
                    childScrollView.contentOffset.y = max(childScrollView.contentOffset.y - (parentViewMaxContentYOffset - scrollView.contentOffset.y), 0)
                    scrollView.contentOffset.y = parentViewMaxContentYOffset
                    childScrollingDownDueToParent = false
                }
            }
        }
    }
}
