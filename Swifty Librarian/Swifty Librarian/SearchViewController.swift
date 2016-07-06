//
//  SearchViewController.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 6/18/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

	let viewModel = SearchViewModel.instance
	
	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		theTabBarController = self.parentViewController as! UITabBarController
		
		viewModel.performFetchSearchingResult("", completion: {
			self.collectionView.reloadData()
		})
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		searchBar.delegate = self
		
	}

}


extension SearchViewController: UICollectionViewDataSource {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.books.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SearchCell", forIndexPath: indexPath) as! SearchCell
		let book = viewModel.books[indexPath.row]
		cell.titleLabel.text = "TITLE: " + book.title
		cell.isbnLabel.text = "ISBN: " + book.isbn
		cell.authorLabel.text = "AUTHOR(s): " + book.authors
		cell.publisherLabel.text = "PUBLISHER: " + book.publisher
		cell.isbn = book.isbn
		cell.checkButton.setTitle("Check Availability", forState: .Normal)
		DLImageLoader.sharedInstance.imageFromUrl(book.coverUrl, imageView: cell.coverImageView)
		
		return cell
	}
	
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width - 20, height: 200)
	}
	
}

extension SearchViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		self.view.endEditing(true)
		viewModel.performFetchSearchingResult(searchBar.text!, completion: {
			self.collectionView.reloadData()
		})
	}
	
}