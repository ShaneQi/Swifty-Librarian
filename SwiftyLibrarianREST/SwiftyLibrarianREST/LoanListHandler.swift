//
//  LoanListHandler.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 7/6/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import PerfectLib
import MySQL

class LoanListHandler: RequestHandler {

	static let instance = LoanListHandler()
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		guard let paramKeyword = request.param("keyword") else {
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
		
		mysql.query("SELECT * FROM book_loans WHERE (card_id = '\(paramKeyword)' OR book_id = '\(paramKeyword)') AND date_in is NULL;")
		
		var responseArray = [Any]()
		
		mysql.storeResults()?.forEachRow({
			row in
			var loan = [String: Any]()
			loan["loan_id"] = row[0]
			loan["book_id"] = row[1]
			loan["card_id"] = row[2]
			responseArray.append(loan)
		})
		
		let responseString = try! responseArray.jsonEncodedString()
		response.appendBodyString(responseString)
		response.requestCompletedCallback()
		
	}

}
