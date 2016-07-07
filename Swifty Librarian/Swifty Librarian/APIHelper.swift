//
//  APIHelper.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 7/5/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import Alamofire

let baseURL = "http://localhost:8181"

let branchListURL = baseURL + "/branch/list"
let branchListMETHOD = Method.GET

let bookSearchURL = baseURL + "/book/search"
let bookSearchMETHOD = Method.GET

let bookAvailabilityURL = baseURL + "/book/availability"
let bookAvailabilityMETHOD = Method.GET

let loanCheckinURL = baseURL + "/loan/checkin"
let loanCheckinMETHOD = Method.GET

let loanCheckoutURL = baseURL + "/loan/checkout"
let loanCheckoutMETHOD = Method.GET

let loanListURL = baseURL + "/loan/list"
let loanListMETHOD = Method.GET

let borrowerFineURL = baseURL + "/borrower/fine"
let borrowerFineMETHOD = Method.GET

let loanPaymentURL = baseURL + "/loan/payment"
let loanPaymentMETHOD = Method.GET

let borrowerCreateURL = baseURL + "/borrower/create"
let borrowerCreateMETHOD = Method.POST