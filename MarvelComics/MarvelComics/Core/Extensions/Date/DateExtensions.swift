//
//  DateExtensions.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 05/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

extension Date {
    func shortDateFormat() -> String {
        let dateFormatter = DateHelper.shared.shortDateFormatter
        return dateFormatter.string(from: self)
    }
}

