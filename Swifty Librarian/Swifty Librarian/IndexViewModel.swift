//
//  IndexViewModel.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 6/18/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//
import Alamofire
import SwiftyJSON

class IndexViewModel {
	
	static let instance = IndexViewModel()
	
	var branches = [Branch]()
	let colors = [redPrimary, greenPrimary, orangePrimary, indigoPrimary, purplePrimary]
	
	func fetchBranches(completion: (() -> Void)) {
		Alamofire.request(branchListMETHOD, branchListURL).validate().responseJSON{
			response in
			switch response.result {
			case .Success:
				if let value = response.result.value {
					let json = JSON(value)
					let branchesJSON = json.arrayValue
					for branchJSON in branchesJSON {
						let branch = Branch(id: branchJSON["id"].intValue, name: branchJSON["name"].stringValue, address: branchJSON["address"].stringValue)
						self.branches.append(branch)
					}
					completion()
				}
			case .Failure(let e):
				fatalError("\(e)")
			}
		}
	
	}
	
}
