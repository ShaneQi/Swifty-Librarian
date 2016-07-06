//
//  BorrowerCreateHandler.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 7/4/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import PerfectLib
import MySQL

class BorrowerCreateHandler: RequestHandler {

	static let instance = BorrowerCreateHandler()
	
	var id = 1000
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		let requestDictionary = (try! request.postBodyString.jsonDecode()) as! [String: Any]
		
		id += 1
		let cardId = "ID00" + String(id)
		let ssn = requestDictionary["ssn"] as! String
		let firstName = requestDictionary["first_name"] as! String
		let lastName = requestDictionary["last_name"] as! String
		let email = requestDictionary["email"] as! String
		let address = requestDictionary["address"] as! String
		let city = requestDictionary["city"] as! String
		let state = requestDictionary["state"] as! String
		let phone = requestDictionary["phone"] as! String
		
		let mysql = MySQL()
		
		guard mysql.connect("127.0.0.1", user: "root", password: databasePassword, db: "swifty_librarian") else {
			let responseString = PerfectHelper.instance.JSONString(withFailureReason: mysql.errorMessage())
			response.appendBodyString(responseString)
			response.requestCompletedCallback()
			return
		}
		
		defer { mysql.close() }
		
		let insertBorrower = mysql.query("INSERT INTO borrower VALUES ('\(cardId)', '\(ssn)', '\(firstName)', '\(lastName)', '\(email)', '\(address)', '\(city)', '\(state)', '\(phone)');")
		
		var responseDictionary = [String: Any]()
		
		if insertBorrower {
			responseDictionary["status"] = true
			responseDictionary["id"] = cardId
		} else {
			responseDictionary["status"] = false
			responseDictionary["reason"] = mysql.errorMessage()
		}
		
		let responseString = try! responseDictionary.jsonEncodedString()
		response.appendBodyString(responseString)
		response.requestCompletedCallback()
		
	}

}
