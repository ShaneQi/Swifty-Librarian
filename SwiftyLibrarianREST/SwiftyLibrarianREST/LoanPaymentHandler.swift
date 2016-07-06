//
//  LoanPaymentHandler.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 7/4/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import PerfectLib
import MySQL

class LoanPaymentHandler: RequestHandler {
	
	static let instance = LoanPaymentHandler()

	func handleRequest(request: WebRequest, response: WebResponse) {
		guard let paramFineId = request.param("id") else {
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
		
		mysql.query("UPDATE fine SET paid = 1 WHERE fine_id = \(paramFineId);")
		
		response.requestCompletedCallback()
		
	}

}
