//
//  BorrowerViewModel.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 7/6/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//
import RxCocoa
import RxSwift
import Alamofire
import SwiftyJSON

class BorrowerViewModel {
	
	static let instance = BorrowerViewModel()
	
	var disposeBag = DisposeBag()
	var neverTake = DisposeBag()
	
	var fineCardId = Variable("")
	var fines = Variable([(amount: String, id: String, paid: String)]())
	
	var newBorrower = Variable(Borrower(ssn: "", firstName: "", lastName: "", email: "", address: "", city: "", state: "", phone: ""))
	
	struct Borrower {
		var ssn: String
		var firstName: String
		var lastName: String
		var email: String
		var address: String
		var city: String
		var state: String
		var phone: String
		
		init(ssn: String,
			firstName: String,
			lastName: String,
			email: String,
			address: String,
			city: String,
			state: String,
			phone: String) {
			self.ssn = ssn
			self.firstName = firstName
			self.lastName = lastName
			self.email = email
			self.address = address
			self.city = city
			self.state = state
			self.phone = phone
		}
	}
	
	func performSignup(completion: (status: Bool, note: String) -> Void) {
	
		Alamofire.request(borrowerCreateMETHOD, borrowerCreateURL, parameters: [
			"ssn": newBorrower.value.ssn,
			"first_name": newBorrower.value.firstName,
			"last_name": newBorrower.value.lastName,
			"email": newBorrower.value.email,
			"address": newBorrower.value.address,
			"city": newBorrower.value.city,
			"state": newBorrower.value.state,
			"phone": newBorrower.value.phone], encoding: .JSON).validate().responseJSON(completionHandler: {
			response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					if json["status"].boolValue {
						let id = json["id"].stringValue
						completion(status: true, note: id)
					} else {
						let reason = json["reason"].stringValue
						completion(status: false, note: reason)
					}
				}
			case .Failure(let e):
				fatalError("\(e)")
			}
		})
		
	}
	
	func performFetchFine(completion: (()->Void)) {
		
		Alamofire.request(borrowerFineMETHOD, borrowerFineURL, parameters: ["id": fineCardId.value], encoding: .URLEncodedInURL).validate().responseJSON(completionHandler: {
			response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					self.fines.value.removeAll()
					for fineJSON in json.arrayValue {
						self.fines.value.append((amount: fineJSON["amount"].stringValue, id: fineJSON["id"].stringValue, paid: fineJSON["paid"].stringValue))
					}
					completion ()
				}
			case .Failure(let e):
				fatalError("\(e)")
			}
		})
		
		
	}
	
	func performPayment(index: Int, completion: (() -> Void)) {
		let id = fines.value[index].id
		Alamofire.request(loanPaymentMETHOD, loanPaymentURL, parameters: ["id": id], encoding: .URLEncodedInURL).response(completionHandler: {
			_ in
			completion ()
		})
	}
	
}
