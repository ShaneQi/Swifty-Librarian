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

let loanCheckinURL = "http://localhost:8181/loan/checkin"
let loanCheckinMETHOD = Method.GET

let loanCheckoutURL = "http://localhost:8181/loan/checkout"
let loanCheckoutMETHOD = Method.GET

let loanListURL = "http://localhost:8181/loan/list"
let loanListMETHOD = Method.GET

let borrowerFineURL = "http://localhost:8181/borrower/fine"
let borrowerFineMETHOD = Method.GET

let loanPaymentURL = "http://localhost:8181/loan/payment"
let loanPaymentMETHOD = Method.GET

let borrowerCreateURL = "http://localhost:8181/borrower/create"
let borrowerCreateMETHOD = Method.POST