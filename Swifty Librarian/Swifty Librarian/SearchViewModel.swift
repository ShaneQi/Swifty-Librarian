//
//  SearchViewModel.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 7/5/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import Alamofire
import SwiftyJSON

class SearchViewModel {

	static let instance = SearchViewModel()
	
	var books = [Book]()
	
	func performFetchSearchingResult(keywords: String, completion: (() -> Void)) {
		Alamofire.request(bookSearchMETHOD, bookSearchURL, parameters: ["page": 1, "search": keywords], encoding: .URLEncodedInURL).validate().responseJSON(completionHandler: {
			response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					self.books.removeAll()
					let booksJSON = json.arrayValue
					for bookJSON in booksJSON {
						self.books.append(Book(title: bookJSON["title"].stringValue, isbn: bookJSON["isbn"].stringValue, publisher: bookJSON["publisher"].stringValue, authors: bookJSON["author"].stringValue, coverUrl: bookJSON["cover"].stringValue, pages: bookJSON["pages"].stringValue))
					}
					completion ()
				}
			case .Failure(let e):
				fatalError("\(e)")
			}

		})
	
	}

}