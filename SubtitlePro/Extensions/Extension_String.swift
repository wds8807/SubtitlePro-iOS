//
//  Extension_String.swift
//  SubtitlePro
//
//  Created by Dongshuo Wu on 12/25/17.
//  Copyright © 2017 Dongshuo Wu. All rights reserved.
//

import UIKit

extension String {
	
	func lengthAtLeast6() -> Bool {
		return self.count >= 6
	}
	
	func lengthAtLeast8() -> Bool {
		return self.count >= 8
	}
	
	func oneUppserCase() -> Bool {
		let predicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
		//print("One uppercase:", predicate.evaluate(with: self))
		return predicate.evaluate(with: self)
	}
	
	func oneLowerCase() -> Bool {
		let predicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
		//print("One lowercase:", predicate.evaluate(with: self))
		return predicate.evaluate(with: self)
	}
	
	func oneDigit() -> Bool {
		let predicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
		//print("One digit:", predicate.evaluate(with: self))
		return predicate.evaluate(with: self)
	}

	func isValidPassword(testStr: String?) -> Bool {
		guard testStr != nil else { return false }
		
		// at least one uppercase,
		// at least one digit
		// at least one lowercase
		// 8 characters total
		let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
		return passwordTest.evaluate(with: testStr)
	}
	
	func isValidEmail() -> Bool {
		
		
		let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		
		let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
		return pred.evaluate(with: self)
	}

}

