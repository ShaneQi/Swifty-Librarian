//
//  BranchListHandler.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 7/5/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import PerfectLib
import MySQL

class BranchListHandler: RequestHandler {

	static let instance = BranchListHandler()
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		let mysql = MySQL()
		
		guard mysql.connect("127.0.0.1", user: "root", password: databasePassword, db: "swifty_librarian") else {
			let responseString = PerfectHelper.instance.JSONString(withFailureReason: mysql.errorMessage())
			response.appendBodyString(responseString)
			response.requestCompletedCallback()
			return
		}
		
		defer { mysql.close() }

		mysql.query("SELECT * FROM library_branch;")
		
		var responseArray = [Any]()
		
		mysql.storeResults()?.forEachRow({ row in
			var branchDictionary = [String: Any]()
			branchDictionary["id"] = Int(row[0])
			branchDictionary["name"] = row[1]
			branchDictionary["address"] = row[2]
			responseArray.append(branchDictionary)
		})
		
		let responseString = try! responseArray.jsonEncodedString()
		response.appendBodyString(responseString)
		response.requestCompletedCallback()
		
	}

}
