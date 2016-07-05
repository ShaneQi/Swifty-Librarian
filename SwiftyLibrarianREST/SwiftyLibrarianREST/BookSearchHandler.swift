//
//  BookSearchHandler.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 6/26/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import PerfectLib
import MySQL

class BookSearchHandler: RequestHandler{

	static let instance = BookSearchHandler()
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		
		guard let paramPage = request.param("page"), page = Int(paramPage) else {
			let responseString = PerfectHelper.instance.JSONString(withFailureReason: "Bad parameter 'page'.")
			response.appendBodyString(responseString)
			response.requestCompletedCallback()
			return
		}
		
		var searchKeywords = ""
		if let paramSearchKeywords = request.param("search") { searchKeywords = paramSearchKeywords }
		
		let mysql = MySQL()
		
		guard mysql.connect("127.0.0.1", user: "root", password: databasePassword, db: "swifty_librarian") else {
			let responseString = PerfectHelper.instance.JSONString(withFailureReason: mysql.errorMessage())
			response.appendBodyString(responseString)
			response.requestCompletedCallback()
			return
		}
		
		defer { mysql.close() }
		
		mysql.query("SELECT * FROM ( SELECT * FROM ( SELECT A.*, GROUP_CONCAT(C.name SEPARATOR ', ') AS author FROM book A, book_authors B, author C WHERE A.isbn = B.isbn AND B.author_id = C.author_id GROUP BY A.isbn ) AS T WHERE author LIKE '%\(searchKeywords)%' OR title LIKE '%\(searchKeywords)%' ) AS TT LIMIT 10 OFFSET \(10*page)");
		
		var responseArray = [Any]()
		
		mysql.storeResults()?.forEachRow({ row in
		
			var bookDictionary = [String: Any]()
			bookDictionary["isbn"] = row[0]
			bookDictionary["title"] = row[1]
			bookDictionary["cover"] = row[2]
			bookDictionary["publisher"] = row[3]
			bookDictionary["pages"] = row[4]
			bookDictionary["author"] = row[5]
			responseArray.append(bookDictionary)
			
		})
		
		let responseString = try! responseArray.jsonEncodedString()
		response.appendBodyString(responseString)
		response.requestCompletedCallback()
		
	}
	
}
