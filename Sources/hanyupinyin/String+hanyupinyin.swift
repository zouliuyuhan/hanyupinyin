import Foundation

// MARK: - String扩展
public extension String {
    
    /// 转换为拼音
    /// - Parameters:
    ///   - format: 输出格式
    ///   - separator: 分隔符
    /// - Returns: 拼音字符串
    func toPinyin(withFormat format: PinyinOutputFormat = .default, separator: String = " ") -> String {
        var pinyinStrings: [String] = []
        
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            let pinyinArray = hanyupinyin.shared.pinyinArray(withCharCodePoint: charCodePoint, outputFormat: format)
            
            if !pinyinArray.isEmpty {
                if format.polyphoneStrategy == .all && pinyinArray.count > 1 {
                    // 多音字用括号包围，用逗号分隔
                    let polyphoneString = "(" + pinyinArray.joined(separator: ",") + ")"
                    pinyinStrings.append(polyphoneString)
                } else {
                    pinyinStrings.append(pinyinArray.first!)
                }
            } else {
                pinyinStrings.append(String(unicodeScalar))
            }
        }
        
        return pinyinStrings.joined(separator: separator)
    }
    
    /// 异步转换为拼音
    /// - Parameters:
    ///   - format: 输出格式
    ///   - separator: 分隔符
    ///   - completion: 完成回调
    func toPinyin(withFormat format: PinyinOutputFormat = .default, separator: String = " ", completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pinyin = self.toPinyin(withFormat: format, separator: separator)
            DispatchQueue.main.async {
                completion(pinyin)
            }
        }
    }
    
    /// 转换为拼音首字母
    /// - Parameters:
    ///   - format: 输出格式
    ///   - separator: 分隔符
    /// - Returns: 拼音首字母字符串
    func toPinyinAcronym(withFormat format: PinyinOutputFormat = .default, separator: String = "") -> String {
        var acronymStrings: [String] = []
        
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            let pinyinArray = hanyupinyin.shared.pinyinArray(withCharCodePoint: charCodePoint, outputFormat: format)
            
            if !pinyinArray.isEmpty {
                if format.polyphoneStrategy == .all && pinyinArray.count > 1 {
                    // 多音字的首字母用括号包围
                    let acronyms = pinyinArray.compactMap { $0.first }.map { String($0) }
                    let polyphoneAcronym = "(" + acronyms.joined(separator: ",") + ")"
                    acronymStrings.append(polyphoneAcronym)
                } else if let firstPinyin = pinyinArray.first, let firstChar = firstPinyin.first {
                    acronymStrings.append(String(firstChar))
                }
            } else {
                acronymStrings.append(String(unicodeScalar))
            }
        }
        
        return acronymStrings.joined(separator: separator)
    }
    
    /// 异步转换为拼音首字母
    /// - Parameters:
    ///   - format: 输出格式
    ///   - separator: 分隔符
    ///   - completion: 完成回调
    func toPinyinAcronym(withFormat format: PinyinOutputFormat = .default, separator: String = "", completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let acronym = self.toPinyinAcronym(withFormat: format, separator: separator)
            DispatchQueue.main.async {
                completion(acronym)
            }
        }
    }
    
    /// 转换为带颜色的拼音结果
    /// - Parameters:
    ///   - format: 输出格式
    /// - Returns: 带颜色的拼音结果数组
    func toColoredPinyin(withFormat format: PinyinOutputFormat = .withDefaultColors) -> [ColoredPinyinResult] {
        var results: [ColoredPinyinResult] = []
        
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            let coloredResults = hanyupinyin.shared.coloredPinyinArray(withCharCodePoint: charCodePoint, outputFormat: format)
            
            if !coloredResults.isEmpty {
                results.append(contentsOf: coloredResults)
            } else {
                results.append(ColoredPinyinResult(text: String(unicodeScalar)))
            }
        }
        
        return results
    }
    
    /// 异步转换为带颜色的拼音结果
    /// - Parameters:
    ///   - format: 输出格式
    ///   - completion: 完成回调
    func toColoredPinyin(withFormat format: PinyinOutputFormat = .withDefaultColors, completion: @escaping ([ColoredPinyinResult]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let results = self.toColoredPinyin(withFormat: format)
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    /// 检查是否包含汉字
    var hasChineseCharacter: Bool {
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            if hanyupinyin.shared.isHanzi(ofCharCodePoint: charCodePoint) {
                return true
            }
        }
        return false
    }
    
    /// 获取汉字数量
    var chineseCharacterCount: Int {
        var count = 0
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            if hanyupinyin.shared.isHanzi(ofCharCodePoint: charCodePoint) {
                count += 1
            }
        }
        return count
    }
    
    /// 获取多音字信息
    /// - Returns: 多音字字典，键为汉字，值为拼音数组
    func getPolyphoneInfo() -> [String: [String]] {
        var polyphoneInfo: [String: [String]] = [:]
        
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            let character = String(unicodeScalar)
            
            if hanyupinyin.shared.isHanzi(ofCharCodePoint: charCodePoint) {
                let pinyinArray = hanyupinyin.shared.pinyinArray(
                    withCharCodePoint: charCodePoint,
                    outputFormat: PinyinOutputFormat(
                        toneType: .toneNumber,
                        vCharType: .vCharacter,
                        caseType: .lowercased,
                        polyphoneStrategy: .all
                    )
                )
                
                if pinyinArray.count > 1 {
                    polyphoneInfo[character] = pinyinArray
                }
            }
        }
        
        return polyphoneInfo
    }
    
    /// 智能拼音转换（根据上下文选择最合适的读音）
    /// - Parameters:
    ///   - format: 输出格式
    ///   - separator: 分隔符
    /// - Returns: 智能拼音字符串
    func toSmartPinyin(withFormat format: PinyinOutputFormat = .default, separator: String = " ") -> String {
        var smartFormat = format
        smartFormat.polyphoneStrategy = .most_common
        return toPinyin(withFormat: smartFormat, separator: separator)
    }
    
    /// 生成拼音学习卡片数据
    /// - Returns: 学习卡片数据数组
    func generateLearningCards() -> [PinyinLearningCard] {
        var cards: [PinyinLearningCard] = []
        
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            let character = String(unicodeScalar)
            
            if hanyupinyin.shared.isHanzi(ofCharCodePoint: charCodePoint) {
                let pinyinArray = hanyupinyin.shared.pinyinArray(
                    withCharCodePoint: charCodePoint,
                    outputFormat: .withToneSymbol
                )
                
                let coloredResults = hanyupinyin.shared.coloredPinyinArray(
                    withCharCodePoint: charCodePoint,
                    outputFormat: .withDefaultColors
                )
                
                if !pinyinArray.isEmpty && !coloredResults.isEmpty {
                    let card = PinyinLearningCard(
                        character: character,
                        pinyin: pinyinArray,
                        coloredResults: coloredResults,
                        isPolyphone: pinyinArray.count > 1
                    )
                    cards.append(card)
                }
            }
        }
        
        return cards
    }
}

/// 拼音学习卡片
public struct PinyinLearningCard {
    public let character: String
    public let pinyin: [String]
    public let coloredResults: [ColoredPinyinResult]
    public let isPolyphone: Bool
    
    public init(character: String, pinyin: [String], coloredResults: [ColoredPinyinResult], isPolyphone: Bool) {
        self.character = character
        self.pinyin = pinyin
        self.coloredResults = coloredResults
        self.isPolyphone = isPolyphone
    }
} 