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

//if !mysql.selectDatabase("swifty_librarian") {
//	
//	print("Database doesn't exist. Creating!")
//	mysql.query("CREATE DATABASE swifty_librarian;")
//	mysql.selectDatabase("swifty_librarian")
//	
//}
//
//let createLibraryBranchTable = mysql.query("CREATE TABLE IF NOT EXISTS library_branch (branch_id INT(11) AUTO_INCREMENT PRIMARY KEY, branch_name varchar(255), address varchar(255));")
//
//if !createLibraryBranchTable {
//	
//	print(mysql.errorMessage())
//	
//}
//
//let createBookTable = mysql.query("CREATE TABLE IF NOT EXISTS book (isbn varchar(255) PRIMARY KEY, title varchar(255), cover varchar(255), publisher INT(10), pages INT(10));")
//
//if !createBookTable {
//	
//	print(mysql.errorMessage())
//	
//}
//
//let createPublisherTable = mysql.query("CREATE TABLE IF NOT EXISTS publisher (publisher_id INT(10), publisher_name varchar(255));")
//
//if !createPublisherTable {
//	
//	print(mysql.errorMessage())
//	
//}
//
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
let booksCSVPath = "/Users/Shadow/Developer/Proj/Swifty-Librarian/Document/books.csv"

if fileManager.fileExistsAtPath(booksCSVPath) {
	
	var booksString = ""
	
	do {
	
		booksString = try String(contentsOfFile: booksCSVPath, encoding: NSUTF8StringEncoding)
		
	} catch let e { print("Error: \(e)") }
	
	var booksStringArray = booksString.characters.split("\r\n").map( String.init )
	
	booksStringArray.removeFirst()
	
	for bookString in booksStringArray {
		
		let bookArray = bookString.characters.split("\t").map( String.init )
		
		if bookArray.count != 7 {
			print(bookArray.count)
			if bookArray.count != 6 {
				print(bookString)
			}
//			if bookArray[3].substringToIndex(bookArray[3].startIndex.advancedBy(4)) == "http" {
//			
//				
//				
//			} else {
//			
//				
//			
//			}
		
		}
//		mysql.query("INSERT INTO book VALUES (\(bookArray[0]), \(bookArray[2]), \(bookArray[4]), \(bookArray[5]), \(Int(bookArray[6])!))")
		
	}
	
}
