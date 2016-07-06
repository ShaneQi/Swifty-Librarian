//
//  SearchViewController.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 6/18/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
	}

}


extension SearchViewController: UICollectionViewDataSource {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SearchCell", forIndexPath: indexPath) as! SearchCell
		return cell
	}
	
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width - 20, height: 200)
	}
	
}