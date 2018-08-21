//
//  DateHelper.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 05/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import Foundation

class DateHelper {

    static let shared = DateHelper()

    lazy var calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = Locale.current
        cal.timeZone = TimeZone.current
        return cal
    }()

    lazy var serviceDateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.calendar = DateHelper.shared.calendar
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return format
    }()
}
