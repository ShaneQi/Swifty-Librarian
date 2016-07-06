//
//  LoanCheckOutHandler.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 7/4/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import PerfectLib
import MySQL

class LoanCheckOutHandler: RequestHandler {

	static let instance = LoanCheckOutHandler()
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		
		guard let paramBookId = request.param("book"), paramCardId = request.param("borrower") else {
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
		
		mysql.query("SELECT * FROM fine A, book_loans B	WHERE A.loan_id = B.loan_id AND A.paid = 0 AND B.card_id = '\(paramCardId)';")
		guard mysql.storeResults()?.numRows() < 3 {
			let responseDictionary: [String: Any] = ["status": false]
			let responseString = try! responseDictionary.jsonEncodedString()
			response.appendBodyString(responseString)
			response.requestCompletedCallback()
			return
		}
		
		let now = NSDate()
		let due = now.dateByAddingTimeInterval(60*60*24*14)
		
		mysql.query("INSERT INTO book_loans (book_id, card_id, date_out, date_due) VALUES (\(paramBookId), '\(paramCardId)', '\(now.toString())', '\(due.toString())');")
		mysql.query("UPDATE book_copies SET availability=0 WHERE book_id = \(paramBookId);")
		
		let responseDictionary: [String: Any] = ["status": true]
		let responseString = try! responseDictionary.jsonEncodedString()
		response.appendBodyString(responseString)
		response.requestCompletedCallback()
		
	}

}
