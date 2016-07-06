//
//  Book.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 6/26/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

struct Book {
	
	var title: String
	var isbn: String
	var publisher: String
	var authors: String
	var coverUrl: String
	var pages: String
	
	init(title: String, isbn: String, publisher: String, authors: String, coverUrl: String, pages: String) {
		self.title = title
		self.isbn = isbn
		self.publisher = publisher
		self.authors = authors
		self.coverUrl = coverUrl
		self.pages = pages
	}
	
}
