//
//  CheckViewController.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 7/5/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CheckViewController: UIViewController {

	let viewModel = CheckViewModel.instance
	
	@IBOutlet var outTableView: UITableView!
	@IBOutlet var inTableView: UITableView!
	
	override func viewDidLoad() {
		for tableView in [outTableView, inTableView] {
			tableView.registerNib(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
			tableView.registerNib(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell")
			tableView.registerNib(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "DatePickerCell")
			tableView.registerNib(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
		}
	}

}

extension CheckViewController: UITableViewDataSource {

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 { return 4 }
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
			return cell
		case (0, 1):
			let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
			return cell
		case (0, 2):
			let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell") as! LabelCell
			if tableView == inTableView {
				self.viewModel.checkinDateString.asObservable().subscribeNext({
					nextString in
					cell.label.text = nextString
				}).addDisposableTo(viewModel.disposeBag)
			} else {
				self.viewModel.checkoutDateString.asObservable().subscribeNext({
					nextString in
					cell.label.text = nextString
				}).addDisposableTo(viewModel.disposeBag)
			}
			
			return cell
		case (0, 3):
			let cell = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerCell
			if tableView == inTableView {
				cell.datePicker.rx_date.subscribeNext({
					nextDate in
					self.viewModel.checkinDateString.value = dateFormatter.stringFromDate(nextDate)
				}).addDisposableTo(viewModel.disposeBag)
			} else {
				cell.datePicker.rx_date.subscribeNext({
					nextDate in
					self.viewModel.checkoutDateString.value = dateFormatter.stringFromDate(nextDate)
				}).addDisposableTo(viewModel.disposeBag)
			}
			return cell
		case (1, 0):
			let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
			return cell
		default:
			let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell") as! LabelCell
			return cell
		}
	}
	
}

extension CheckViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == 3 { return 200 }
		return 44
	}
	
}