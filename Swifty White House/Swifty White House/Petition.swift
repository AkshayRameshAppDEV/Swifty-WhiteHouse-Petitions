//
//  Petition.swift
//  Swifty White House
//
//  Created by Akshay Ramesh on 12/30/20.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
