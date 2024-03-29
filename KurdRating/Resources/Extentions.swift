//
//  Extentions.swift
//  KurdRating
//
//  Created by Siros Taib on 3/28/24.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
