//
//  IndexViewModel.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 6/18/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

class IndexViewModel {
	
	static let instance = IndexViewModel()
	
	var branches = [Branch]()
	let colors = [redPrimary, greenPrimary, orangePrimary, indigoPrimary]
	
	init() {
	
		branches = [Branch(id: 1, name: "1", address: "3325 NOVA TRL"),
					Branch(id: 2, name: "2", address: "17817 COIT RD"),
					Branch(id: 3, name: "3", address: "2650 VELLEY VIEW"),
					Branch(id: 4, name: "4", address: "3535 BELI RD")]
		
	}
	
}
