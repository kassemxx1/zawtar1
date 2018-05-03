//
//  PageViewController.swift
//  zawtar
//
//  Created by kassem on 5/2/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // The custom UIPageControl
    @IBOutlet weak var pageControl: UIPageControl!
    
    // The UIPageViewController
    var pageContainer: UIPageViewController!
    
    // The pages it contains
    var pages = [UIViewController]()
    
    // Track the current index
    var currentIndex: Int?
    private var pendingIndex: Int?
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the pages
        let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
        let page1: UIViewController! = storyboard.instantiateViewControllerWithIdentifier("page1")
        let page2: UIViewController! = storyboard.instantiateViewControllerWithIdentifier("page2")
        let page3: UIViewController! = storyboard.instantiateViewControllerWithIdentifier("page3")
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        // Create the page container
        pageContainer = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        pageContainer.setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        // Add it to the view
        view.addSubview(pageContainer.view)
        
        // Configure our custom pageControl
        view.bringSubviewToFront(pageControl)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }
    
    // MARK: - UIPageViewController delegates
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        if currentIndex == pages.count-1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.indexOf(pendingViewControllers.first!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
}
