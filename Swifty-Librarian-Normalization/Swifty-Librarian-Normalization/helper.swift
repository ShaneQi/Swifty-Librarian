//
//  helper.swift
//  Swifty-Librarian-Normalization
//
//  Created by Shane Qi on 6/15/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

func quote(content: String?) -> String {
	guard content != nil else {
		return "NULL"
	}
	return "\"\(content)\""
}
