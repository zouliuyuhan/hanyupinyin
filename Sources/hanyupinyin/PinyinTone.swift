import Foundation

/// 拼音音调类型
public enum PinyinTone: Int, CaseIterable {
    case first = 1      // 第一声
    case second = 2     // 第二声
    case third = 3      // 第三声
    case fourth = 4     // 第四声
    case light = 5      // 轻声
    
    /// 获取音调符号
    public var symbol: String {
        switch self {
        case .first: return "ˉ"
        case .second: return "ˊ"
        case .third: return "ˇ"
        case .fourth: return "ˋ"
        case .light: return "˙"
        }
    }
    
    /// 获取音调数字
    public var number: String {
        return "\(rawValue)"
    }
    
    /// 获取默认音调颜色（RGB值）
    /// 开发者可以选择是否使用这些默认颜色
    public var defaultColor: (red: Double, green: Double, blue: Double) {
        switch self {
        case .first: return (1.0, 0.0, 0.0)        // 红色
        case .second: return (0.0, 1.0, 0.0)       // 绿色
        case .third: return (0.0, 0.0, 1.0)        // 蓝色
        case .fourth: return (1.0, 0.5, 0.0)       // 橙色
        case .light: return (0.5, 0.5, 0.5)        // 灰色
        }
    }
    
    /// 获取默认音调颜色的十六进制表示
    /// 开发者可以选择是否使用这些默认颜色
    public var defaultHexColor: String {
        let r = Int(defaultColor.red * 255)
        let g = Int(defaultColor.green * 255)
        let b = Int(defaultColor.blue * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    /// 根据自定义颜色配置获取颜色
    /// - Parameter colorConfig: 自定义颜色配置
    /// - Returns: 十六进制颜色字符串
    public func getColor(from colorConfig: PinyinColorConfig?) -> String? {
        guard let config = colorConfig else { return nil }
        
        switch self {
        case .first: return config.firstTone
        case .second: return config.secondTone
        case .third: return config.thirdTone
        case .fourth: return config.fourthTone
        case .light: return config.lightTone
        }
    }
}

/// 带音调的拼音
public struct TonedPinyin {
    public let pinyin: String
    public let tone: PinyinTone
    
    public init(pinyin: String, tone: PinyinTone) {
        self.pinyin = pinyin
        self.tone = tone
    }
    
    /// 获取带音调符号的拼音
    public var withToneSymbol: String {
        return addToneSymbol(to: pinyin, tone: tone)
    }
    
    /// 获取带数字音调的拼音
    public var withToneNumber: String {
        return pinyin + tone.number
    }
    
    /// 获取不带音调的拼音
    public var withoutTone: String {
        return pinyin
    }
    
    /// 为拼音添加音调符号
    private func addToneSymbol(to pinyin: String, tone: PinyinTone) -> String {
        let vowels = ["a", "o", "e", "i", "u", "ü", "v"]
        let toneMarks: [String: [String]] = [
            "a": ["a", "á", "ǎ", "à", "a"],
            "o": ["o", "ó", "ǒ", "ò", "o"],
            "e": ["e", "é", "ě", "è", "e"],
            "i": ["i", "í", "ǐ", "ì", "i"],
            "u": ["u", "ú", "ǔ", "ù", "u"],
            "ü": ["ü", "ǘ", "ǚ", "ǜ", "ü"],
            "v": ["v", "ǘ", "ǚ", "ǜ", "v"]
        ]
        
        var result = pinyin.lowercased()
        
        // 处理特殊情况
        if result.contains("iu") {
            result = result.replacingOccurrences(of: "iu", with: "i" + (toneMarks["u"]?[tone.rawValue - 1] ?? "u"))
        } else if result.contains("ui") {
            result = result.replacingOccurrences(of: "ui", with: (toneMarks["u"]?[tone.rawValue - 1] ?? "u") + "i")
        } else if result.contains("ou") {
            result = result.replacingOccurrences(of: "ou", with: (toneMarks["o"]?[tone.rawValue - 1] ?? "o") + "u")
        } else if result.contains("ao") {
            result = result.replacingOccurrences(of: "ao", with: (toneMarks["a"]?[tone.rawValue - 1] ?? "a") + "o")
        } else if result.contains("ai") {
            result = result.replacingOccurrences(of: "ai", with: (toneMarks["a"]?[tone.rawValue - 1] ?? "a") + "i")
        } else if result.contains("ei") {
            result = result.replacingOccurrences(of: "ei", with: (toneMarks["e"]?[tone.rawValue - 1] ?? "e") + "i")
        } else {
            // 按优先级查找元音
            for vowel in vowels {
                if result.contains(vowel) {
                    if let tonedVowel = toneMarks[vowel]?[tone.rawValue - 1] {
                        result = result.replacingOccurrences(of: vowel, with: tonedVowel)
                        break
                    }
                }
            }
        }
        
        return result
    }
} 