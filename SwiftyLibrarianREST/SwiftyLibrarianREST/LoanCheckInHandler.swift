//
//  LoanCheckInHandler.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 7/4/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import PerfectLib
import MySQL

class LoanCheckInHandler: RequestHandler {

	static let instance = LoanCheckInHandler()
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		
		guard let paramLoanId = request.param("loan"), paramDate = request.param("date") else {
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
		
		let now = paramDate.toDate()
		var due = NSDate()
		var bookId = 0
		
		mysql.query("SELECT * FROM book_loans WHERE loan_id = \(paramLoanId);")
		mysql.storeResults()?.forEachRow({ row in
			due = row[4].toDate()
			bookId = Int(row[1])!
		})
		
		var responseDictionary = [String: Any]()
		responseDictionary["fine"] = false
		let overDue = now.timeIntervalSinceDate(due)/60/60/24
		if overDue > 0 {
			
			let fine = Double(Int(overDue)) * 0.25
			responseDictionary["fine"] = true
			responseDictionary["days"] = overDue
			
			mysql.query("INSERT INTO fine (loan_id, fine_amount, paid) VALUES (\(paramLoanId), \(fine), 0);")
		}
		
		mysql.query("UPDATE book_loans SET date_in = '\(now.toString())' WHERE book_id = \(bookId);")
		mysql.query("UPDATE book_copies SET availability=1 WHERE book_id = \(bookId);")
		
		let responseString = try! responseDictionary.jsonEncodedString()
		response.appendBodyString(responseString)
		response.requestCompletedCallback()
		
	}

}
