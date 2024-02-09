import SwiftUI

enum Completion: Codable {
    case attempting(Int)
    case done(Bool)
}

class Answer: Codable {
    let time: String
    var completion: Completion
    
    enum JSON: String, CodingKey {
        case time
        case completion
    }
    
    init(time: Date, completion: Completion = .attempting(0)) {
        self.time = TimeFormatter.string(from: time)
        self.completion = completion
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSON.self)
        self.time = try values.decode(String.self, forKey: .time)
        self.completion = try values.decode(Completion.self, forKey: .completion)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JSON.self)
        try container.encode(self.time, forKey: .time)
        try container.encode(self.completion, forKey: .completion)
    }
}
