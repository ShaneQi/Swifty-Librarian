//
//  main.swift
//  Swifty-Librarian-Normalization
//
//  Created by Shane Qi on 6/11/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import Foundation
import MySQL

print("=======================")
print("=========BEGIN=========")
print("=======================")

let mysql = MySQL()
let connected = mysql.connect("127.0.0.1", user: "root", password: "Qq654877")

if !connected {
	
	print(mysql.errorMessage())
	
}

defer {
	
	mysql.close()
	
}

if !mysql.selectDatabase("swifty_librarian") {
	
	print("Database doesn't exist. Creating!")
	mysql.query("CREATE DATABASE swifty_librarian;")
	mysql.selectDatabase("swifty_librarian")
	
}

let createBookTable = mysql.query("CREATE TABLE IF NOT EXISTS book (isbn varchar(255) PRIMARY KEY, title varchar(255), cover varchar(255), publisher varchar(255), pages INT(10));")

if !createBookTable {
	
	print(mysql.errorMessage())
	
}

let createBookAuthorsTable = mysql.query("CREATE TABLE IF NOT EXISTS book_authors (author_id INT(10), isbn INT(10), PRIMARY KEY (author_id, isbn));")

if !createBookAuthorsTable {

	print(mysql.errorMessage())

}

let createAuthorTable = mysql.query("CREATE TABLE IF NOT EXISTS author (author_id INT(10) AUTO_INCREMENT PRIMARY KEY, name INT(10));")

if !createAuthorTable {

	print(mysql.errorMessage())

}

let createLibraryBranchTable = mysql.query("CREATE TABLE IF NOT EXISTS library_branch (branch_id INT(10) AUTO_INCREMENT PRIMARY KEY, branch_name varchar(255), address varchar(255));")

if !createLibraryBranchTable {
	
	print(mysql.errorMessage())
	
}

let createBookCopiesTable = mysql.query("CREATE TABLE IF NOT EXISTS book_copies (book_id INT(10) AUTO_INCREMENT PRIMARY KEY, isbn INT(10), branch_id INT(10));")

if !createBookCopiesTable {
	
	print(mysql.errorMessage())
	
}

let createBorrowerTable = mysql.query("CREATE TABLE IF NOT EXISTS borrower (card_id INT(10) PRIMARY KEY, ssn INT(10), first_name varchar(255), last_name varchar(255), email varchar(255), address varchar(255), city varchar(255), state varchar(255), phone varchar(255));")

if !createBorrowerTable {
	
	print(mysql.errorMessage())
	
}

let createBookLoansTable = mysql.query("CREATE TABLE IF NOT EXISTS book_loans (loan_id INT(10) PRIMARY KEY, book_id INT(10), card_id INT(10), date_out DATE, date_due DATE, date_in DATE);")

if !createBookLoansTable {
	
	print(mysql.errorMessage())
	
}

let createFineTable = mysql.query("CREATE TABLE IF NOT EXISTS fine (loan_id INT(10) PRIMARY KEY, fine_amount FLOAT(10, 2), paid BOOL);")

if !createFineTable {
	
	print(mysql.errorMessage())
	
}

var fileManager = NSFileManager.defaultManager()
//
//
///* library_branch!!! */
//
//let libraryBranchCSVPath = "/Users/Shadow/Developer/Proj/Swifty-Librarian/Document/library_branch.csv"
//
//if fileManager.fileExistsAtPath(libraryBranchCSVPath) {
//	
//	var libraryBranchString = ""
//	
//	do {
//		
//		/* Get all content of file as String. */
//		libraryBranchString = try String(contentsOfFile: libraryBranchCSVPath, encoding: NSUTF8StringEncoding)
//		
//	} catch let e { print("Error: \(e)") }
//	
//	/* Split String by \n. */
//	var branchStringArray = libraryBranchString.characters.split("\n").map( String.init )
//
//	/* Remove the table title line. */
//	branchStringArray.removeFirst()
//	
//	/* Normalize every line. */
//	for branchString in branchStringArray {
//
//		/* Split by \t. */
//		let branchArray = branchString.characters.split("\t").map( String.init )
//		mysql.query("INSERT INTO library_branch VALUES(\(Int(branchArray[0])!), '\(branchArray[1])', '\(branchArray[2])');")
//
//	}
//
//}

/* books!!! */
//let booksCSVPath = "/Users/Shadow/Developer/Proj/Swifty-Librarian/Document/books.csv"
//
//if fileManager.fileExistsAtPath(booksCSVPath) {
//	
//	var booksString = ""
//	
//	do {
//	
//		booksString = try String(contentsOfFile: booksCSVPath, encoding: NSUTF8StringEncoding)
//		
//	} catch let e { print("Error: \(e)") }
//	
//	var booksStringArray = booksString.characters.split("\r\n").map( String.init )
//	
//	booksStringArray.removeFirst()
//	
//	for bookString in booksStringArray {
//		
//		var bookArray: [String?] = bookString.characters.split("\t").map( String.init )
//		
//		if bookArray.count == 7 {
//			
//		} else if bookArray.count == 6 {
//			
//			if bookArray[3]!.substringToIndex(bookArray[3]!.startIndex.advancedBy(4)) == "http" {
//				
//				/* No author. */
//				bookArray.insert(nil, atIndex: 3)
//				
//			} else {
//				
//				/* No publisher. */
//				bookArray.insert(nil, atIndex: 5)
//				
//			}
//			
//		} else if bookArray.count == 5 {
//			
//			/* No author, no publisher. */
//			bookArray.insert(nil, atIndex: 3)
//			bookArray.insert(nil, atIndex: 5)
//			
//		}
//		
//		
//		
//	}
//	
//}
