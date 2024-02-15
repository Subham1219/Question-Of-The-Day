import SwiftUI

let TimeFormatter = { () -> DateFormatter in
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
    return formatter
}()

