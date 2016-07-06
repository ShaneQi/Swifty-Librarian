//
//  BorowerFineHandler.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 7/4/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import PerfectLib
import MySQL

class BorowerFineHandler: RequestHandler {

	static let instance = BorowerFineHandler()
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		guard let paramBorrowerId = request.param("id") else {
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

		var fines = [Any]()
		
		mysql.query("SELECT A.fine_id, A.fine_amount, A.paid FROM fine A, book_loans B WHERE A.loan_id = B.loan_id AND B.card_id = '\(paramBorrowerId)';")
		
		mysql.storeResults()?.forEachRow({ row in
			var fine = [String: Any]()
			fine["id"] = row[0]
			fine["amount"] = row[1]
			fine["paid"] = row[2]
			fines.append(fine)
		})
		
		let responseString = try! fines.jsonEncodedString()
		response.appendBodyString(responseString)
		response.requestCompletedCallback()
		
	}

}