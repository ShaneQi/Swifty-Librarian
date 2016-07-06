//
//  CheckViewModel.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 7/5/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//
import RxSwift
import RxCocoa

class CheckViewModel {

	static let instance = CheckViewModel()

	var disposeBag = DisposeBag()
	
	var checkinDateString = Variable("")
	var checkoutDateString = Variable("")
	
}
