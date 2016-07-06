//
//  IndexViewController.swift
//  Swifty Librarian
//
//  Created by Shane Qi on 6/17/16.
//  Copyright © 2016 com.github.shaneqi. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController {

	let viewModel = IndexViewModel.instance
	
	var pageViewControler: UIPageViewController!
	
	var branchViewControllers = [BranchViewController]()
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "EmbedingBranchViewControllerSegue" {
			
			viewModel.fetchBranches({
				self.pageViewControler = (segue.destinationViewController as! UIPageViewController)
				self.pageViewControler.dataSource = self
				for (index, branch) in self.viewModel.branches.enumerate() {
					self.branchViewControllers.append(BranchViewController(branch: branch))
					self.branchViewControllers.last?.view.backgroundColor = self.viewModel.colors[index]
				}
				self.pageViewControler.setViewControllers([self.branchViewControllers[0]], direction: .Forward, animated: true, completion: nil)
			})
			
		}
		
		else if segue.identifier == "ChoosingBranchSegue" {
			selectedBranchId = (pageViewControler.viewControllers?.last as! BranchViewController).branch.id
		}
	}
	
}

extension IndexViewController: UIPageViewControllerDataSource {
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		
		if let previousViewController = viewController as? BranchViewController, previousIndex = branchViewControllers.indexOf(previousViewController) {
			
			let nextIndex = previousIndex + 1
			if nextIndex >= branchViewControllers.count { return branchViewControllers[0] }
			return branchViewControllers[nextIndex]
			
		}
		
		return nil
		
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		
		if let previousViewController = viewController as? BranchViewController, previousIndex = branchViewControllers.indexOf(previousViewController) {
			
			let nextIndex = previousIndex - 1
			if nextIndex < 0 { return branchViewControllers.last }
			return branchViewControllers[nextIndex]
			
		}
		
		return nil
		
	}

}