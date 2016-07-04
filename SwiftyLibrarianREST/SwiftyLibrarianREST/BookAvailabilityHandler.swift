//
//  BookAvailabilityHandler.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 7/4/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import PerfectLib
import MySQL

class BookAvailabilityHandler: RequestHandler {

	static let instance = BookAvailabilityHandler()
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		
		guard let paramIsbn = request.param("isbn"), paramBranch = request.param("branch") else {
			let responseString = PerfectHelper.instance.JSONString(withFailureReason: "Bad parameters.")
			response.appendBodyString(responseString)
			response.requestCompletedCallback()
			return
		}
		
		let mysql = MySQL()
		
		guard mysql.connect("127.0.0.1", user: "root", password: databasePassword, db: "swifty_librarian") else {
			let responseString = PerfectHelper.instance.JSONString(withFailureReason: mysql.errorMessage())
			response.appendBodyString(responseString)
			response.requestCompletedCallback()
			return
		}
		
		defer { mysql.close() }
		
		mysql.query("SELECT * FROM book_copies B WHERE '\(paramIsbn)' = B.isbn AND B.branch_id = \(paramBranch) AND B.availability = 1;")
		
		var count = 0
		var responseDictionary = [String: Any]()
		var booksArray = [Any]()
		
		mysql.storeResults()?.forEachRow({ row in
			count += 1
		
			var bookDictionary = [String: Any]()
			bookDictionary["book_id"] = row[0]
			bookDictionary["isbn"] = row[1]
			bookDictionary["branch_id"] = row[2]
			booksArray.append(bookDictionary)
			
		})
		
		responseDictionary["count"] = count
		responseDictionary["books"] = booksArray
		
		let responseString = try! responseDictionary.jsonEncodedString()
		response.appendBodyString(responseString)
		response.requestCompletedCallback()
		
	}
	
}