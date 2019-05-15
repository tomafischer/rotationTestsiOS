//
//  TimeTools.swift
//  rotationTestsiOS
//
//  Created by tom on 5/15/19.
//  Copyright © 2019 aft3000. All rights reserved.
//

import Foundation

class TimeTools{
    static func diff( start: DispatchTime, end: DispatchTime) -> Double{
        return Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
    }
}
