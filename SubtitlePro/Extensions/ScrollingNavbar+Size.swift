//
//  ScrollingNavbar+Size.swift
//  CustomNavControllerDemo
//
//  Created by Dongshuo Wu on 12/29/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit
import WebKit

extension ScrollingNavigationController {
	
	var fullNavBarHeight: CGFloat {
		return navBarHeight + statusBarHeight
	}
	
	var navBarHeight: CGFloat {
		return navigationBar.frame.size.height
	}
	
	var statusBarHeight: CGFloat {
		var statusBarHeight = UIApplication.shared.statusBarFrame.size.height
		if #available(iOS 11.0, *) {
			statusBarHeight = max(UIApplication.shared.statusBarFrame.size.height, UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0)
		}
		return statusBarHeight - extendedStatusBarDifference
	}
	
	var extendedStatusBarDifference: CGFloat {
		return abs(view.bounds.height - (UIApplication.shared.delegate?.window??.frame.size.height ?? UIScreen.main.bounds.height))
	}
	
	var tabBarOffset: CGFloat {
		if let tabBarController = tabBarController {
			return tabBarController.tabBar.isTranslucent ? 0: tabBarController.tabBar.frame.height
		}
		return 0
	}
	
	
	func scrollView() -> UIScrollView? {
		if let webView = self.scrollableView as? WKWebView {
			return webView.scrollView
		} else if let wkWebView = self.scrollableView as? WKWebView {
			return wkWebView.scrollView
		} else {
			return scrollableView as? UIScrollView
		}
	}
	
	var contentOffset: CGPoint {
		return scrollView()?.contentOffset ?? CGPoint.zero
	}
	
	var contentSize: CGSize {
		guard let scrollView = scrollView() else {
			return CGSize.zero
		}
		
		let verticalInset = scrollView.contentInset.top + scrollView.contentInset.bottom
		return CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height + verticalInset)
	}
	
	var deltaLimit: CGFloat {
		return navBarHeight - statusBarHeight
	}

}









