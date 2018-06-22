//
//  imageViewController.swift
//  zawtar
//
//  Created by kassem on 6/18/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit

class imageViewController: UIViewController,UIScrollViewDelegate {
    var bigimagename :String?
    @IBOutlet weak var BigImage: UIImageView!
    
    @IBOutlet weak var scroll: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        BigImage.loadImageUsingCacheWithUrlString(urlString: bigimagename!)
        scroll.delegate = self
        self.scroll.maximumZoomScale = 1.0
        self.scroll.maximumZoomScale = 10.0
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }

    //dismiss picture
    var initialTouchPoint = CGPoint.zero
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        }
    }
    //zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return self.BigImage
    }

    }

