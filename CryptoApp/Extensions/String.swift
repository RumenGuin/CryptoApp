//
//  String.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 20/01/22.
//

import Foundation

extension String {
    var removingHTMLOccurences: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "",options: .regularExpression, range: nil)
    }
}
