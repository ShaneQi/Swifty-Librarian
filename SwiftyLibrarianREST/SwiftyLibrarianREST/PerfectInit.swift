//
//  PerfectInit.swift
//  SwiftyLibrarianREST
//
//  Created by Shane Qi on 6/26/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import PerfectLib

public func PerfectServerModuleInit() {
	
	Routing.Handler.registerGlobally()
	
	Routing.Routes["GET", "/branch/list"] = { _ in return BranchListHandler.instance }
	
	Routing.Routes["GET", "/book/search"] = { _ in return BookSearchHandler.instance }
	Routing.Routes["GET", "/book/availability"] = { _ in return BookAvailabilityHandler.instance }
	
	Routing.Routes["GET", "/loan/checkout"] = { _ in return LoanCheckOutHandler.instance }
	Routing.Routes["GET", "/loan/checkin"] = { _ in return LoanCheckInHandler.instance }
	Routing.Routes["GET", "/loan/list"] = { _ in return LoanListHandler.instance }
	Routing.Routes["GET", "/loan/payment"] = { _ in return LoanPaymentHandler.instance }
	
	Routing.Routes["POST", "/borrower/create"] = { _ in return BorrowerCreateHandler.instance }
	Routing.Routes["GET", "/borrower/fine"] = { _ in return BorowerFineHandler.instance }
}
