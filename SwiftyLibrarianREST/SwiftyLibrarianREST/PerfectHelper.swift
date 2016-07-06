//
//  PerfectHelper.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 6/26/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import Foundation

class PerfectHelper {

	static let instance = PerfectHelper()
	
	func JSONString(withFailureReason reason: String) -> String {
	
		var JSONDictionary = [String: Any]()
		JSONDictionary["status"] = false
		JSONDictionary["reason"] = reason
		let JSONString = try! JSONDictionary.jsonEncodedString()
		return JSONString
		
	}

}

extension NSDate {

	func toString() -> String {
		let formater = NSDateFormatter()
		formater.dateFormat = "yyyy-MM-dd"
		return formater.stringFromDate(self)
	}

}

extension String {

	func toDate() -> NSDate {
		let formater = NSDateFormatter()
		formater.dateFormat = "yyyy-MM-dd"
		return formater.dateFromString(self)!
	}

}