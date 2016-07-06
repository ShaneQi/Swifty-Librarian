//
//  BorrowerViewController.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 7/6/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BorrowerViewController: UIViewController {
	
	let viewModel = BorrowerViewModel.instance
	
	@IBOutlet var fineTableView: UITableView!
	@IBOutlet var signupTableView: UITableView!
	
	override func viewDidLoad() {
		for tableView in [fineTableView, signupTableView] {
			tableView.registerNib(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
			tableView.registerNib(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell")
			tableView.registerNib(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "DatePickerCell")
			tableView.registerNib(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
		}
	}
	
}

extension BorrowerViewController: UITableViewDataSource {

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if tableView == fineTableView {
			return 2
		}
		
		else {
			return 2
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == fineTableView {
			if section == 0 { return 2 }
			else { return self.viewModel.fines.value.count }
		}
			
		else {
			if section == 0 { return 8 }
			else { return 1 }
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if tableView == fineTableView {
			switch (indexPath.section, indexPath.row) {
			case (0, 0):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "Borrower Card ID"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.fineCardId.value = nextString
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			case (0, 1):
				let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
				cell.button.setTitle("CHECK FINE", forState: .Normal)
				cell.button.rx_tap.subscribeNext({
					self.viewModel.performFetchFine({
						self.viewModel.disposeBag = DisposeBag()
						self.fineTableView.reloadData()
					})
				}).addDisposableTo(viewModel.disposeBag)
				return cell
			default:
				let cell = tableView.dequeueReusableCellWithIdentifier("BorrowerCell")!
				cell.textLabel?.text = "$\(self.viewModel.fines.value[indexPath.row].amount)"
				if self.viewModel.fines.value[indexPath.row].paid == "1" {
					cell.detailTextLabel?.text = "PAID"
				} else {
					cell.detailTextLabel?.text = "UNPAID"
				}
				return cell
			}
		}
			
		else {
			switch (indexPath.section, indexPath.row) {
			case (0, 0):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "SSN"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.newBorrower.value.ssn = nextString
				}).addDisposableTo(viewModel.neverTake)
				return cell
			case (0, 1):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "First Name"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.newBorrower.value.firstName = nextString
				}).addDisposableTo(viewModel.neverTake)
				return cell
			case (0, 2):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "Last Name"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.newBorrower.value.lastName = nextString
				}).addDisposableTo(viewModel.neverTake)
				return cell
			case (0, 3):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "Email"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.newBorrower.value.email = nextString
				}).addDisposableTo(viewModel.neverTake)
				return cell
			case (0, 4):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "Address"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.newBorrower.value.address = nextString
				}).addDisposableTo(viewModel.neverTake)
				return cell
			case (0, 5):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "City"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.newBorrower.value.city = nextString
				}).addDisposableTo(viewModel.neverTake)
				return cell
			case (0, 6):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "State"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.newBorrower.value.state = nextString
				}).addDisposableTo(viewModel.neverTake)
				return cell
			case (0, 7):
				let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldCell
				cell.textField.placeholder = "Phone"
				cell.textField.rx_text.subscribeNext({
					nextString in
					self.viewModel.newBorrower.value.phone = nextString
				}).addDisposableTo(viewModel.neverTake)
				return cell
			case (1, 0):
				let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
				cell.button.setTitle("SIGNUP", forState: .Normal)
				cell.button.rx_tap.subscribeNext({
					self.viewModel.performSignup({
						status, note in
						var title = ""
						var message = ""
						if status {
							title = "SUCCESS"
							message = "Card ID: " + note
						} else {
							title = "FAILURE"
							message = note
						}
						let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
						alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
						self.presentViewController(alert, animated: true, completion: nil)
					})
				}).addDisposableTo(viewModel.neverTake)
				return cell
			default:
				fatalError("\(indexPath) cell is not configured.")
			}
		}
	}
	
}

extension BorrowerViewController: UITableViewDelegate {

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.cellForRowAtIndexPath(indexPath)?.selected = false
		guard tableView == fineTableView else { return }
		guard indexPath.section == 1 else { return }
		guard self.viewModel.fines.value[indexPath.row].paid == "0" else { return }
		let alert = UIAlertController(title: "PAYMENT", message: "Make a payment to this fine?", preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "YES", style: .Default, handler: {
			_ in
			self.viewModel.performPayment(indexPath.row, completion: {
				self.viewModel.performFetchFine({
					self.viewModel.disposeBag = DisposeBag()
					self.fineTableView.reloadData()
				})
			})
		}))
		alert.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
	}

}