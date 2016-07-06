//
//  GlobalHelper.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 7/5/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import Foundation

var selectedBranchId = 0

var dateFormatter: NSDateFormatter {
	let formatter = NSDateFormatter()
	formatter.dateFormat = "yyyy-MM-dd"
	return formatter
}
