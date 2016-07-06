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
		if tableView == outTableView { return 2 }
		else { return 3 }
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == outTableView {
			if section == 0 { return 4 }
			else { return 1 }
		}
		else {
			if section == 0 { return 2 }
			else if section == 1 { return 4 }
			else { return 1 }
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if tableView == outTableView {
			switch (indexPath.section, indexPath.row) {
			case (0, 0):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "Borrower Card ID"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.checkoutCardId.value = nextString
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (0, 1):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "Book ID"
				self.viewModel.checkoutBookId.asObservable().subscribeNext({
					nextString in
					cell.textField.text = nextString
				}).addDisposableTo(viewModel.disposeBag)
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.checkoutBookId.value = nextString
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (0, 2):
				let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell") as! LabelCell
				self.viewModel.checkoutDateString.asObservable().subscribeNext({
					nextString in
					cell.label.text = "Check-out Date: " + nextString
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (0, 3):
				let cell = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerCell
				cell.datePicker.rx_date.subscribeNext({
					nextDate in
					self.viewModel.checkoutDateString.value = dateFormatter.stringFromDate(nextDate)
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (1, 0):
				let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
				cell.button.setTitle("Check-out", forState: .Normal)
				cell.button.rx_tap.subscribeNext({
					_ in
					self.viewModel.performCheckout({
						status in
						if status {
							let alert = UIAlertController(title: "SUCCESS", message: "", preferredStyle: .Alert)
							alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
							self.presentViewController(alert, animated: true, completion: nil)
							self.viewModel.clearOut()
						} else {
							let alert = UIAlertController(title: "FAILURE", message: "You already got 3 active loans.", preferredStyle: .Alert)
							alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
							self.presentViewController(alert, animated: true, completion: nil)
						}
					})
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			default:
				fatalError("\(indexPath) cell is not configured.")
			}
		}
		
		else {
			switch (indexPath.section, indexPath.row) {
			case (0, 0):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "Borrower Card ID or Book ID"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.checkinKeyword.value = nextString
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (0, 1):
				let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
				cell.button.setTitle("SEARCH", forState: .Normal)
				cell.button.rx_tap.subscribeNext({
					self.viewModel.performFetchLoans({
						loans in
						if loans.count > 0 {
							let alert = UIAlertController(title: "LOANS", message: "", preferredStyle: .ActionSheet)
							for loan in loans {
								alert.addAction(UIAlertAction(title: "\(loan.cardId) - \(loan.bookId)", style: .Default, handler: {
									_ in
									self.viewModel.checkinBookId.value = loan.bookId
									self.viewModel.checkinCardId.value = loan.cardId
									self.viewModel.checkinLoanId.value = loan.loanId
								}))
							}
							alert.popoverPresentationController?.sourceView = self.view
							alert.popoverPresentationController?.sourceRect = self.view.bounds
							self.presentViewController(alert, animated: true, completion: nil)
						} else {
							let alert = UIAlertController(title: "ERROR", message: "No available loan for this borrower or book.", preferredStyle: .Alert)
							alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
							self.presentViewController(alert, animated: true, completion: nil)
						}

					})
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (1, 0):
				let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell") as! LabelCell
				self.viewModel.checkinCardId.asObservable().subscribeNext({
					nextString in
					cell.label.text = "Borrower Card ID: " + nextString
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (1, 1):
				let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell") as! LabelCell
				self.viewModel.checkinBookId.asObservable().subscribeNext({
					nextString in
					cell.label.text = "Book ID: " + nextString
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (1, 2):
				let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell") as! LabelCell
				self.viewModel.checkinDateString.asObservable().subscribeNext({
					nextString in
					cell.label.text = "Check-in Date: " + nextString
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (1, 3):
				let cell = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerCell
				cell.datePicker.rx_date.subscribeNext({
					nextDate in
					self.viewModel.checkinDateString.value = dateFormatter.stringFromDate(nextDate)
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (2, 0):
				let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
				cell.button.rx_tap.subscribeNext({
					self.viewModel.performCheckin({
						fineDays in
						if fineDays != nil {
							let alert = UIAlertController(title: "SUCCESS", message: "Overdue \(fineDays!) Days!", preferredStyle: .Alert)
							alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
							self.presentViewController(alert, animated: true, completion: nil)
							self.viewModel.clearOut()
						} else {
							let alert = UIAlertController(title: "SUCCESS", message: "No Overdue.", preferredStyle: .Alert)
							alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
							self.presentViewController(alert, animated: true, completion: nil)
							self.viewModel.clearOut()
						}
					})
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			default:
				fatalError("\(indexPath) cell is not configured.")
			}
		}
	}
	
}

extension CheckViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if tableView == outTableView {
			if indexPath == NSIndexPath(forRow: 3, inSection: 0) { return 200 }
			else { return 44 }
		}
		else {
			if indexPath == NSIndexPath(forRow: 3, inSection: 1) { return 200 }
			else { return 44 }
		}
		
	}
	
}