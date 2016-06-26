//
//  BranchViewController.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 6/18/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import UIKit

class BranchViewController: UIViewController {
	
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var addressLabel: UILabel!
	
	var branch: Branch!
	
	init(branch: Branch) {
		super.init(nibName: "BranchView", bundle: nil)
		
		self.branch = branch
		
	}

	
	override func viewDidLoad() {
		
		self.nameLabel.text = branch.name
		self.addressLabel.text = branch.address
		
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
