//
//  AppDelegate.swift
//  BeReal Clone
//
//  Created by Ruth Bilaro 3/18/23.

import Foundation

extension DateFormatter {
    static var postFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
