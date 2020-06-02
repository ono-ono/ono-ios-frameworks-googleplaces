//
//  Bundle-AppLocale.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

/*
	Credits:
	https://www.factorialcomplexity.com/blog/2015/01/28/how-to-change-localization-internally-in-your-ios-application.html
*/


///	Custom subclass to enable on-the-fly Bundle language change
final class LocalizedBundle: Bundle {
	///	Overrides system method and enforces usage of particular .lproj translation bundle
	override public func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
		if let bundle = Bundle.current.localizedBundle {
			return bundle.localizedString(forKey: key, value: value, table: tableName)
		}
		return super.localizedString(forKey: key, value: value, table: tableName)
	}
}


extension Bundle {
	private struct AssociatedKeys {
		static var b = "LocalizedMainBundle"
	}

	fileprivate var localizedBundle: Bundle? {
		get {
			//	warning: Make sure this object you are fetching really exists
			return objc_getAssociatedObject(self, &AssociatedKeys.b) as? Bundle
		}
	}

	static var current: Bundle {
		let b = Bundle(for: PlacesService.self)
		return b
	}

	/// Loads the translations for the given language code.
	///
	/// - Parameter code: two-letter ISO 639-1 language code
	static func enforceLanguage(_ code: String, scriptCode: String? = nil) {
		var path: String?

		if let scriptCode = scriptCode {
			let name = "\(code)_\(scriptCode)"
			if let p = Bundle.current.path(forResource: name, ofType: "lproj") {
				path = p
			}
		}

		if path == nil, let p = Bundle.current.path(forResource: code, ofType: "lproj") {
			path = p
		} else {
			//	we did not find proper Bundle().path for desired language
			return
		}

		//	now load proper language bundle
		guard
			let finalPath = path,
			let bundle = Bundle(path: finalPath)
		else { return }

		//	prepare translated bundle for chosen language and
		//	save it as property of the current Bundle
		objc_setAssociatedObject(Bundle.current, &AssociatedKeys.b, bundle, .OBJC_ASSOCIATION_RETAIN)

		//	now override class of the main bundle (only once during the app lifetime)
		//	this way, `localizedString(forKey:value:table)` method in our subclass above will actually be called
		DispatchQueue.once(token: AssociatedKeys.b)  {
			object_setClass(Bundle.current, LocalizedBundle.self)
		}
	}


	///	Removes the custom bundle
	static func clearInAppOverrides() {
		objc_setAssociatedObject(Bundle.current, &AssociatedKeys.b, nil, .OBJC_ASSOCIATION_RETAIN)
	}
}
