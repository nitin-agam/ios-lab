//
//  Pluralized.swift
//  Taska
//
//  Copyright © 2026 Swiftable. All rights reserved.
//

import Foundation

// scattered wherever a count needs to be shown as text.
func pluralized(_ count: Int, singular: String, plural: String? = nil) -> String {
    "\(count) \(count == 1 ? singular : (plural ?? singular + "s"))"
}
