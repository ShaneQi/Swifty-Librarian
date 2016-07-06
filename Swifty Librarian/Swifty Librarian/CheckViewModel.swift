//
//  CheckViewModel.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 7/5/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class CheckViewModel {

	static let instance = CheckViewModel()

	var disposeBag = DisposeBag()
	
	var checkinDateString = Variable("")
	var checkinBookId = Variable("")
	var checkinCardId = Variable("")
	var checkinKeyword = Variable("")
	var checkinLoanId = Variable("")
	
	var checkoutDateString = Variable("")
	var checkoutBookId = Variable("")
	var checkoutCardId = Variable("")
	
	func performCheckin(completion: ((fineDays: String?) -> Void)) {
		Alamofire.request(loanCheckinMETHOD, loanCheckinURL, parameters: ["loan": checkinLoanId.value, "date": checkinDateString.value], encoding: .URLEncodedInURL).validate().responseJSON(completionHandler: {
			response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					if json["fine"].boolValue == true {
						completion (fineDays: json["days"].stringValue)
					} else {
						completion (fineDays: nil)
					}
					
				}
			case .Failure(let e):
				fatalError("\(e)")
			}
		})
	}
	
	func performCheckout(completion: ((statue: Bool, note: String) -> Void)) {
		Alamofire.request(loanCheckoutMETHOD, loanCheckoutURL, parameters: ["book": checkoutBookId.value, "borrower": checkoutCardId.value, "date": checkoutDateString.value], encoding: .URLEncodedInURL).validate().responseJSON(completionHandler: {
			response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					if json["status"].boolValue == true {
						completion (statue: true, note: "")
					} else {
						completion (statue: false, note: json["reason"].stringValue)
					}
					
				}
			case .Failure(let e):
				fatalError("\(e)")
			}
		})
	}
	
	func performFetchLoans(completion: ( (loans: [(loanId: String, cardId: String, bookId: String)]) -> Void )) {
		Alamofire.request(loanListMETHOD, loanListURL, parameters: ["keyword": checkinKeyword.value], encoding: .URLEncodedInURL).validate().responseJSON(completionHandler: {
			response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					var loans = [(loanId: String, cardId: String, bookId: String)]()
					for loanJSON in json.arrayValue {
						loans.append((loanId: loanJSON["loan_id"].stringValue, cardId: loanJSON["card_id"].stringValue, bookId: loanJSON["book_id"].stringValue))
					}
					completion(loans: loans)
				}
			case .Failure(let e):
				fatalError("\(e)")
			}
		})
	}
	
	func clearOut() {
		checkoutBookId.value = ""
	}
	
}
