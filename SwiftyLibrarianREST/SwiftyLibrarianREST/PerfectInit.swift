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
	Routing.Routes["GET", "/books/search"] = { _ in return SearchingBooksHandler.instance }

}
