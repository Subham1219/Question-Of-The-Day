import SwiftUI

enum Completion: Codable {
    case attempting(Int)
    case done(Bool)
}

class Answer: Codable {
    let day: String
    var completion: Completion
    
    enum JSON: String, CodingKey {
        case day
        case completion
    }
    
    init(date: Date, completion: Completion = .attempting(0)) {
        self.day = DayFormatter.string(from: date)
        self.completion = completion
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSON.self)
        self.day = try values.decode(String.self, forKey: .day)
        self.completion = try values.decode(Completion.self, forKey: .completion)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JSON.self)
        try container.encode(self.day, forKey: .day)
        try container.encode(self.completion, forKey: .completion)
    }
    
    func correct() -> Bool? {
        return .some(true)
    }
}
