//
//  Prefs.swift
//  Emotion-Detector
//
//  Created by Nate Thompson on 9/15/18.
//  Copyright © 2018 Nate Thompson. All rights reserved.
//

import Foundation

enum ExpressionType {
    case anger
    case contempt
    case disgust
    case fear
    case happiness
    case neutral
    case sadness
    case surprise
}

class Website: NSObject {
    init(expression: [ExpressionType: Float]) {
        self.expression = expression
        numberOfMeasurements = 1
    }
    
    func addExpression(_ newExpression: [ExpressionType: Float]) {
        if expression.count != newExpression.count {
            assertionFailure("Dictionaries are not the same size")
        }
        
        newExpression.forEach { (expressionType, newValue) in
            guard let oldVal = expression[expressionType] else { return }
            expression[expressionType] = oldVal * Float(numberOfMeasurements) + newValue / Float(numberOfMeasurements + 1)
        }
        
        numberOfMeasurements += 1
    }
    
    var numberOfMeasurements: Int
    var expression: [ExpressionType: Float] = [:]
}


enum DataManager {
    static func initialize() {
        PrefManager.shared.userDefaults.dictionary(forKey: Keys.websiteExpressions)
    }
    
    static var websites: [String: Website] = [:] {
        didSet {
            PrefManager.shared.userDefaults.set(websites, forKey: Keys.websiteExpressions)
        }
    }
}

struct Keys {
    static let websiteExpressions = "websiteExpressions"
}

class PrefManager {
    static let shared = PrefManager()
    
    let userDefaults = UserDefaults.standard
}
