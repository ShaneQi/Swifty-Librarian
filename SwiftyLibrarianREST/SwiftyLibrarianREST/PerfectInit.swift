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
	
	// register a route for gettings posts
	Routing.Routes["GET", "/books/search"] = { _ in return BookSearchHandler.instance }
	Routing.Routes["GET", "/books/availability"] = { _ in return BookAvailabilityHandler.instance }
	
	Routing.Routes["GET", "/loan/checkout"] = { _ in return LoanCheckOutHandler.instance }
	Routing.Routes["GET", "/loan/checkin"] = { _ in return LoanCheckInHandler.instance }
	Routing.Routes["GET", "/loan/payment"] = { _ in return LoanPaymentHandler.instance }
	
	
}
