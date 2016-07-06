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
	
	@IBOutlet var paidTableView: UITableView!
	@IBOutlet var unpaidTableView: UITableView!
	
	override func viewDidLoad() {
		viewModel.paidFines.asObservable().bindTo(paidTableView.rx_itemsWithCellIdentifier("BorrowerCell", cellType: UITableViewCell.self)) {
			row, element, cell in
			cell.textLabel?.text = "$ " + element.amount
			cell.detailTextLabel?.text = "PAID"
		}.addDisposableTo(viewModel.disposeBag)
		
		viewModel.unpaidFines.asObservable().bindTo(unpaidTableView.rx_itemsWithCellIdentifier("BorrowerCell", cellType: UITableViewCell.self)) {
			row, element, cell in
			cell.textLabel?.text = "$ " + element.amount
			cell.detailTextLabel?.text = "UNPAID"
		}.addDisposableTo(viewModel.disposeBag)
		
		unpaidTableView.rx_itemSelected.subscribeNext({
			nextIndexPath in
			self.viewModel.performPayment(nextIndexPath.row)
		}).addDisposableTo(viewModel.disposeBag)
		
	}
	
}
