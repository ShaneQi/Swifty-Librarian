//
//  APIHelper.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 7/5/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import Alamofire

let branchListURL = "http://localhost:8181/branch/list"
let branchListMETHOD = Method.GET

let bookSearchURL = "http://localhost:8181/book/search"
let bookSearchMETHOD = Method.GET

let bookAvailabilityURL = "http://localhost:8181/book/availability"
let bookAvailabilityMETHOD = Method.GET