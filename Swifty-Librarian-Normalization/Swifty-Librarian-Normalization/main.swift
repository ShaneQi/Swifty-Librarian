//
//  main.swift
//  Swifty-Librarian-Normalization
//
//  Created by Shane Qi on 6/11/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import Foundation

var fileManager = NSFileManager.defaultManager()

let libraryBranchCSVPath = "/Users/Shadow/Developer/Proj/Swifty-Librarian/Document/library_branch.csv"
var libraryBranches = [(branchId: Int, branchName: String, address: String)]()

if fileManager.fileExistsAtPath(libraryBranchCSVPath) {
	
	var libraryBranchString = ""
	
	do {
		
		/* Get all content of file as String. */
		libraryBranchString = try String(contentsOfFile: libraryBranchCSVPath, encoding: NSUTF8StringEncoding)
		
	} catch let e { print("Error: \(e)") }
	
	/* Split String by \n. */
	var branchStringArrar = libraryBranchString.characters.split("\n").map( String.init )

	/* Remove the table title line. */
	branchStringArrar.removeFirst()

	/* Normalize every line. */
	for branchString in branchStringArrar {

		/* Split by \t. */
		let branchArray = branchString.characters.split("\t").map( String.init )
		libraryBranches.append((branchId: Int(branchArray[0])!, branchName: branchArray[1], address: branchArray[2]))

	}

}