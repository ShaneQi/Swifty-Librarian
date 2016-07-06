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
	
	var checkoutDateString = Variable("")
	var checkoutBookId = Variable("")
	var checkoutCardId = Variable("")
	
	func performCheckin(completion: ((statue: Bool) -> Void)) {
		Alamofire.request(loanCheckinMETHOD, loanCheckinURL, parameters: ["book": checkinBookId], encoding: .URLEncodedInURL).response(completionHandler: {
			_ in
			completion (statue: true)
		})
	}
	
	func performCheckout(completion: ((statue: Bool) -> Void)) {
		Alamofire.request(loanCheckoutMETHOD, loanCheckoutURL, parameters: ["book": checkoutBookId, "borrower": checkoutCardId], encoding: .URLEncodedInURL).validate().responseJSON(completionHandler: {
			response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					if json["status"].boolValue == true {
						completion (statue: true)
					} else {
						completion (statue: false)
					}
					
				}
			case .Failure(let e):
				fatalError("\(e)")
			}
		})
	}
	
	func clear() {
		checkinDateString.value = ""
		checkinBookId.value = ""
		checkinCardId.value = ""
		
		checkoutDateString.value = ""
		checkoutBookId.value = ""
		checkoutCardId.value = ""
	}
	
}
