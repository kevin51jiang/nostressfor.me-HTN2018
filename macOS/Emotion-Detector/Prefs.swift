//
//  Prefs.swift
//  Emotion-Detector
//
//  Created by Nate Thompson on 9/15/18.
//  Copyright © 2018 Nate Thompson. All rights reserved.
//

import Foundation

enum ExpressionType: String, CodingKey {
    case anger = "anger"
    case contempt = "contempt"
    case disgust = "disgust"
    case fear = "fear"
    case happiness = "happiness"
    case neutral = "neutral"
    case sadness = "sadness"
    case surprise = "surprise"
}

class Website: Codable {
    
    init(expression: Expression, domain: String) {
        self.expression = expression
        self.domain = domain
        numMeasurements = 1
    }
    
    private enum CodingKeys: String, CodingKey {
        case numMeasurements = "numMeasurements"
        case expression = "expression"
        case domain = "domain"
    }
    
    func addExpression(_ newExpression: Expression) {
        expression.anger = addToAverage(newVal: newExpression.anger, oldVal: expression.anger, measurements: numMeasurements)
        expression.contempt = addToAverage(newVal: newExpression.contempt, oldVal: expression.contempt, measurements: numMeasurements)
        expression.disgust = addToAverage(newVal: newExpression.disgust, oldVal: expression.disgust, measurements: numMeasurements)
        expression.fear = addToAverage(newVal: newExpression.fear, oldVal: expression.fear, measurements: numMeasurements)
        expression.neutral = addToAverage(newVal: newExpression.neutral, oldVal: expression.neutral, measurements: numMeasurements)
        expression.sadness = addToAverage(newVal: newExpression.sadness, oldVal: expression.sadness, measurements: numMeasurements)
        expression.surprise = addToAverage(newVal: newExpression.surprise, oldVal: expression.surprise, measurements: numMeasurements)
        
        numMeasurements += 1
    }
    
    func addToAverage(newVal: Float, oldVal: Float, measurements: Int) -> Float {
        return oldVal * Float(numMeasurements) + newVal / Float(numMeasurements + 1)
    }
    
    var numMeasurements: Int
    var expression: Expression
    var domain: String
}

struct Expression: Codable {
    var anger: Float
    var contempt: Float
    var disgust: Float
    var fear: Float
    var neutral: Float
    var sadness: Float
    var surprise: Float
    
    init(anger: Float, contempt: Float, disgust: Float, fear: Float, neutral: Float, sadness: Float, surprise: Float) {
        self.anger = anger
        self.contempt = contempt
        self.disgust = disgust
        self.fear = fear
        self.neutral = neutral
        self.sadness = sadness
        self.surprise = surprise
    }
    
    private enum CodingKeys: String, CodingKey {
        case anger = "anger"
        case contempt = "contempt"
        case disgust = "disgust"
        case fear = "fear"
        case neutral = "neutral"
        case sadness = "sadness"
        case surprise = "surprise"
    }
}


enum DataManager {
    static func initialize() {
        guard let data = PrefManager.shared.userDefaults.value(forKey: Keys.websiteExpressions) as? Data else { return }
        
        do {
            websites = try PropertyListDecoder().decode([Website].self, from: data)
        } catch let error {
            NSLog("Error: \(error.localizedDescription)")
        }
    }
    
    static var websites: [Website] = [Website]() {
        didSet {
            PrefManager.shared.userDefaults.set(try? PropertyListEncoder().encode(websites), forKey: Keys.websiteExpressions)
        }
    }
    
    static func generateJSON(path: URL) {
        let jsonData = try! JSONEncoder().encode(websites)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString)
    }
}

struct Keys {
    static let websiteExpressions = "websiteExpressions"
    static let numMeasurements = "numMeasurements"
    static let expression = "expression"
    static let domain = "domain"
}

class PrefManager {
    static let shared = PrefManager()
    
    let userDefaults = UserDefaults.standard
}
