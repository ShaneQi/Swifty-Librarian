//
//  MasterViewController.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 6/18/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	
	let menu = [
		[
			"Books",
			"Checking In/Out",
			"Borrower Fine",
			"Signup"
			],
		[
			"Back"
		]
	]
	
	override func viewDidLoad() {
//		self.navigationItem.titleView = xxx
		
		tableView.dataSource = self
		tableView.delegate = self
		
	}
	
}

extension MasterViewController: UITableViewDataSource {

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return menu.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menu[section].count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("MasterCell")!
		cell.textLabel?.text = menu[indexPath.section][indexPath.row]
		return cell
	}
	
}

extension MasterViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.cellForRowAtIndexPath(indexPath)?.selected = false
	
		let tabBarController = theTabBarController
		
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			tabBarController.selectedIndex = 0
		case (0, 1):
			tabBarController.selectedIndex = 1
		case (0, 2):
			tabBarController.selectedIndex = 2
		case (0, 3):
			break
		default:
			break
		}
	}
	
}