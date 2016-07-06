//
//  BorrowerViewModel.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 7/6/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//
import RxCocoa
import RxSwift

class BorrowerViewModel {
	
	static let instance = BorrowerViewModel()
	
	var disposeBag = DisposeBag()
	
	var paidFines = Variable([(amount: String, id: String)]())
	var unpaidFines = Variable([(amount: String, id: String)]())
	
	func performFetchFine(cardId: String) {
		paidFines.value.removeAll()
		unpaidFines.value.removeAll()
		
		
	}
	
	func performPayment(index: Int) {
		let fineId = unpaidFines.value[index]
	
	}
	
}
