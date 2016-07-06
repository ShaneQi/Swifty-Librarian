//
//  SearchCell.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 6/26/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchCell: UICollectionViewCell {
	
	@IBOutlet var coverImageView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var isbnLabel: UILabel!
	@IBOutlet var authorLabel: UILabel!
	@IBOutlet var publisherLabel: UILabel!
	@IBOutlet var checkButton: UIButton!
	
	var isbn = ""
	var copies = [Int]()
	
	@IBAction func checkAvailability(sender: UIButton) {
		if !(sender.titleLabel?.text?.containsString("Check"))! {
			if !(sender.titleLabel?.text?.containsString("not"))! {
				
			}
			return
		}
		
		Alamofire.request(bookAvailabilityMETHOD, bookAvailabilityURL, parameters: ["isbn": isbn, "branch": selectedBranchId], encoding: .URLEncodedInURL).validate().responseJSON(completionHandler: {
			response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					for bookCopyJSON in json["books"].arrayValue {
						self.copies.append(bookCopyJSON["book_id"].intValue)
					}
					let count = self.copies.count
					if count > 0 {
						self.checkButton.setTitle("\(count) copies available", forState: .Normal)
					} else {
						self.checkButton.setTitle("not available", forState: .Normal)
					}
				}
			case .Failure(let e):
				fatalError("\(e)")
			}
		})
	}
	
	func checkOut() {
	
	}
	
}
