//
//  Page1View.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 7/11/23.
//

import Foundation
import SwiftUI

struct Page: Identifiable {
    let id = UUID()
    let name: String
    
    static let home = Page(name: "Home")
}
