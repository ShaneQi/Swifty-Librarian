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
		
		guard let paramBookId = request.param("book"), paramCardId = request.param("borrower"), paramOutDate = request.param("date") else {
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
		
		mysql.query("SELECT * FROM book_loans A WHERE A.card_id = '\(paramCardId)' AND date_in IS NULL;")
		guard mysql.storeResults()?.numRows() < 3 else {
			let responseDictionary: [String: Any] = ["status": false, "reason": "You already got 3 active loans."]
			let responseString = try! responseDictionary.jsonEncodedString()
			response.appendBodyString(responseString)
			response.requestCompletedCallback()
			return
		}
		
		mysql.query("SELECT A.fine_id, A.fine_amount, A.paid FROM fine A, book_loans B WHERE A.loan_id = B.loan_id AND B.card_id = '\(paramCardId)' AND A.paid = 0;")
		guard mysql.storeResults()?.numRows() == 0 else {
			let responseDictionary: [String: Any] = ["status": false, "reason": "You got unpaid fine."]
			let responseString = try! responseDictionary.jsonEncodedString()
			response.appendBodyString(responseString)
			response.requestCompletedCallback()
			return
		}
		
		let nowDate = NSDate().toString().toDate()
		mysql.query("SELECT * FROM book_loans WHERE card_id = '\(paramCardId)' AND date_in is NULL;")
		mysql.storeResults()?.forEachRow({
			row in
			let due = row[4]
			let dueDate = due.toDate()
			guard nowDate.timeIntervalSinceDate(dueDate) < 0 else {
				let responseDictionary: [String: Any] = ["status": false, "reason": "You got over-due loan."]
				let responseString = try! responseDictionary.jsonEncodedString()
				response.appendBodyString(responseString)
				response.requestCompletedCallback()
				return
			}
		})
		
		let now = paramOutDate.toDate()
		let due = now.dateByAddingTimeInterval(60*60*24*14)
		
		mysql.query("INSERT INTO book_loans (book_id, card_id, date_out, date_due) VALUES (\(paramBookId), '\(paramCardId)', '\(now.toString())', '\(due.toString())');")
		mysql.query("UPDATE book_copies SET availability=0 WHERE book_id = \(paramBookId);")
		
		let responseDictionary: [String: Any] = ["status": true]
		let responseString = try! responseDictionary.jsonEncodedString()
		response.appendBodyString(responseString)
		response.requestCompletedCallback()
		
	}

}
