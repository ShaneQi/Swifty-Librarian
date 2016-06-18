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

let createBookAuthorsTable = mysql.query("CREATE TABLE IF NOT EXISTS book_authors (author_id INT(10), isbn varchar(255), PRIMARY KEY (author_id, isbn));")

if !createBookAuthorsTable {

	print(mysql.errorMessage())

}

let createAuthorTable = mysql.query("CREATE TABLE IF NOT EXISTS author (author_id INT(10) AUTO_INCREMENT PRIMARY KEY, name varchar(255));")

if !createAuthorTable {

	print(mysql.errorMessage())

}

let createLibraryBranchTable = mysql.query("CREATE TABLE IF NOT EXISTS library_branch (branch_id INT(10) AUTO_INCREMENT PRIMARY KEY, branch_name varchar(255), address varchar(255));")

if !createLibraryBranchTable {
	
	print(mysql.errorMessage())
	
}

let createBookCopiesTable = mysql.query("CREATE TABLE IF NOT EXISTS book_copies (book_id INT(10) AUTO_INCREMENT PRIMARY KEY, isbn varchar(255), branch_id INT(10));")

if !createBookCopiesTable {
	
	print(mysql.errorMessage())
	
}

let createBorrowerTable = mysql.query("CREATE TABLE IF NOT EXISTS borrower (card_id varchar(255) PRIMARY KEY, ssn varchar(255), first_name varchar(255), last_name varchar(255), email varchar(255), address varchar(255), city varchar(255), state varchar(255), phone varchar(255));")

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

/* books!!! */
let booksCSVPath = "/Users/Shadow/Developer/Proj/Swifty-Librarian/Document/books.csv"

if fileManager.fileExistsAtPath(booksCSVPath) {
	
	print("Normalizing books.")
	
	var booksString = ""
	
	do {
	
		booksString = try String(contentsOfFile: booksCSVPath, encoding: NSUTF8StringEncoding)
		
	} catch let e { print("Error: \(e)") }
	
	var booksStringArray = booksString.characters.split("\r\n").map( String.init )
	
	booksStringArray.removeFirst()
	
	for bookString in booksStringArray {
		
		var bookArray: [String?] = bookString.characters.split("\t").map( String.init )
		
		if bookArray.count == 7 {
			
		} else if bookArray.count == 6 {
			
			if bookArray[3]!.substringToIndex(bookArray[3]!.startIndex.advancedBy(4)) == "http" {
				
				/* No author. */
				bookArray.insert(nil, atIndex: 3)
				
			} else {
				
				/* No publisher. */
				bookArray.insert(nil, atIndex: 5)
				
			}
			
		} else if bookArray.count == 5 {
			
			/* No author, no publisher. */
			bookArray.insert(nil, atIndex: 3)
			bookArray.insert(nil, atIndex: 5)
			
		}
		
		let isbn = quote(bookArray[0])
		let title = quote(bookArray[2])
		let cover = quote(bookArray[4])
		let publisher = quote(bookArray[5])
		let pages = quote(bookArray[6])
		
		let insertBookStatement = "INSERT INTO book (isbn, title, cover, publisher, pages) VALUES (\(isbn), \(title), \(cover), \(publisher), \(pages));"
		let insertBook = mysql.query(insertBookStatement)
		if !insertBook { print(insertBookStatement) }
		
		var splitedAuthorsArray = bookArray[3]?.characters.split(",").map(String.init)
		var authorsArray = [String]()
		if let splitedAuthorsArray = splitedAuthorsArray {
			
			for splitedAuthorString in splitedAuthorsArray {
				authorsArray.appendContentsOf(splitedAuthorString.characters.split(",").map(String.init))
			}
			for author in authorsArray {
				let authorString = quote(author)
				let insertAuthorStatement = "INSERT INTO author (name) VALUES (\(authorString));"
				let insertAuthor = mysql.query(insertAuthorStatement)
				if !insertAuthor { print(insertAuthorStatement) }
				
				var authorIdString = ""
				mysql.query("SELECT MAX(author_id) FROM author;")
				mysql.storeResults()?.forEachRow({ row in
					authorIdString = quote((row as [String])[0])
				})
				if authorIdString == "" { print("SELECT MAX(author_id) FROM author;") }
				
				let insertBookAuthorsStatement = "INSERT INTO book_authors VALUES (\(authorIdString), \(isbn));"
				let insertBookAuthors = mysql.query(insertBookAuthorsStatement)
				if !insertBookAuthors { print(insertBookAuthorsStatement) }
			}
		
		}
		
		
	}
	
}

/* library_branch!!! */

let libraryBranchCSVPath = "/Users/Shadow/Developer/Proj/Swifty-Librarian/Document/library_branch.csv"

if fileManager.fileExistsAtPath(libraryBranchCSVPath) {
	
	print("Normalizing library branches.")
	
	var libraryBranchString = ""
	
	do {
		
		/* Get all content of file as String. */
		libraryBranchString = try String(contentsOfFile: libraryBranchCSVPath, encoding: NSUTF8StringEncoding)
		
	} catch let e { print("Error: \(e)") }
	
	/* Split String by \n. */
	var branchStringArray = libraryBranchString.characters.split("\n").map( String.init )
	
	/* Remove the table title line. */
	branchStringArray.removeFirst()
	
	/* Normalize every line. */
	for branchString in branchStringArray {
		
		/* Split by \t. */
		let branchArray = branchString.characters.split("\t").map( String.init )
		mysql.query("INSERT INTO library_branch VALUES(\(Int(branchArray[0])!), '\(branchArray[1])', '\(branchArray[2])');")
		
	}
	
}

/* borrowers!!! */

let borrowersCSVPath = "/Users/Shadow/Developer/Proj/Swifty-Librarian/Document/borrowers.csv"

if fileManager.fileExistsAtPath(borrowersCSVPath) {

	print("Normalizing borrowers.")
	
	var borrowersString = ""
	
	do {
		
		/* Get all content of file as String. */
		borrowersString = try String(contentsOfFile: borrowersCSVPath, encoding: NSUTF8StringEncoding)
		
	} catch let e { print("Error: \(e)") }
	
	/* Split String by \n. */
	var borrowersStringArray = borrowersString.characters.split("\r\n").map( String.init )
	
	/* Remove the table title line. */
	borrowersStringArray.removeFirst()
	
	/* Normalize every line. */
	for borrowerString in borrowersStringArray {
		
		
		/* Split by \t. */
		let borrowerArray = borrowerString.characters.split(",").map( String.init )
		
		let cardId = quote(borrowerArray[0])
		let ssn = quote(borrowerArray[1])
		let firstName = quote(borrowerArray[2])
		let lastName = quote(borrowerArray[3])
		let email = quote(borrowerArray[4])
		let address = quote(borrowerArray[5])
		let city = quote(borrowerArray[6])
		let state = quote(borrowerArray[7])
		let phone = quote(borrowerArray[8])

		let insertBorrowerStatement = "INSERT INTO borrower VALUES (\(cardId), \(ssn),\(firstName),\(lastName),\(email),\(address),\(city),\(state),\(phone));"
		let insertBorrower = mysql.query(insertBorrowerStatement)
		if !insertBorrower { print(insertBorrowerStatement) }

	}
	
}

/* book_copies!!! */

let bookCopiesCSVPath = "/Users/Shadow/Developer/Proj/Swifty-Librarian/Document/book_copies.csv"

if fileManager.fileExistsAtPath(bookCopiesCSVPath) {
	
	print("Normalizing book copies.")
	
	var bookCopiesString = ""
	
	do {
		
		/* Get all content of file as String. */
		bookCopiesString = try String(contentsOfFile: bookCopiesCSVPath, encoding: NSUTF8StringEncoding)
		
	} catch let e { print("Error: \(e)") }
	
	/* Split String by \n. */
	var bookCopiesStringArray = bookCopiesString.characters.split("\r\n").map( String.init )
	
	/* Remove the table title line. */
	bookCopiesStringArray.removeFirst()
	
	/* Normalize every line. */
	for bookCopyString in bookCopiesStringArray {
		
		
		/* Split by \t. */
		let bookCopyArray = bookCopyString.characters.split("\t").map( String.init )
		
		let isbn = quote(bookCopyArray[0])
		let branchId = quote(bookCopyArray[1])
		var amount = (Int(bookCopyArray[2]))!
		
		while amount != 0 {
			let insertBookCopyStatement = "INSERT INTO book_copies (isbn, branch_id) VALUES (\(isbn), \(branchId));"
			let insertBookCopy = mysql.query(insertBookCopyStatement)
			if !insertBookCopy { print(insertBookCopyStatement) }
			amount -= 1
		}
		
	}
	
}