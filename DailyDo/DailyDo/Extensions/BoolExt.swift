//
//  IntExt.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/23/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import Foundation


extension Bool {
    init(number: Int) {
        self = number == 1 ? true : false
    }
}
