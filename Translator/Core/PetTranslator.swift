import Foundation

final class PetTranslator {

    private let catDictionary: [String: String] = [
        "hello": "meow",
        "how are you": "meow meow?",
        "i am hungry": "meow meow meow!",
        "stop": "hiss!",
        "i love you": "purr purr",
        "play with me": "nyaa~",
        "good morning": "meowww~",
        "go away": "hiss hiss"
    ]

    private let dogDictionary: [String: String] = [
        "hello": "woof!",
        "how are you": "woof woof?",
        "i am hungry": "bark bark!",
        "stop": "grrr...",
        "i love you": "arf arf",
        "play with me": "woof woof woof!",
        "good morning": "wooooooo",
        "go away": "growl!"
    ]

    func translate(humanText: String, petType: PetType) -> String {
        let cleanedInput = humanText
            .lowercased()
            .components(separatedBy: CharacterSet.punctuationCharacters)
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let dictionary: [String: String] = petType == .cat ? catDictionary : dogDictionary

        if let exactMatch = dictionary[cleanedInput] {
            return exactMatch
        } else {
            let fallbackSound = petType == .cat ? "meow" : "woof"
            let wordCount = cleanedInput.components(separatedBy: .whitespaces).count
            return Array(repeating: fallbackSound, count: wordCount).joined(separator: " ")
        }
    }
}
