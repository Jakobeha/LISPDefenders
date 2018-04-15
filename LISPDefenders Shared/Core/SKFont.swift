//
//  SKFont.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

#if os(macOS)
import AppKit

typealias SKFont = NSFont
#else
import UIKit

typealias SKFont = UIFont
#endif
