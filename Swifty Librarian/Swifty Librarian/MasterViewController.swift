//
//  MasterViewController.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 6/18/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

	override func viewDidLoad() {
		let xx = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
		xx.text = "title"
		self.navigationItem.titleView = xx
	}
	
}
