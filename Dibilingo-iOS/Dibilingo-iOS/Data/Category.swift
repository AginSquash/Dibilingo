//
//  Categories.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 05.12.2020.
//

import Foundation
import SwiftUI

struct Category: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let locale_name: String
    let gradient: [String]
}
