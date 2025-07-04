import Foundation

/// 拼音格式化器
internal struct PinyinFormatter {
    
    /// 格式化拼音
    /// - Parameters:
    ///   - pinyinArray: 拼音数组（可能包含多音字）
    ///   - format: 输出格式
    /// - Returns: 格式化后的拼音数组
    internal static func format(_ pinyinArray: [String], withOutputFormat format: PinyinOutputFormat) -> [String] {
        var result: [String] = []
        
        for pinyin in pinyinArray {
            let formattedPinyin = formatSinglePinyin(pinyin, withOutputFormat: format)
            result.append(formattedPinyin)
        }
        
        // 根据多音字策略处理结果
        switch format.polyphoneStrategy {
        case .first:
            return result.isEmpty ? [] : [result.first!]
        case .all:
            return result
        case .most_common:
            return result.isEmpty ? [] : [result.first!] // 简化处理，实际应该根据使用频率
        }
    }
    
    /// 格式化单个拼音
    /// - Parameters:
    ///   - pinyin: 原始拼音字符串
    ///   - format: 输出格式
    /// - Returns: 格式化后的拼音
    private static func formatSinglePinyin(_ pinyin: String, withOutputFormat format: PinyinOutputFormat) -> String {
        var formattedPinyin = pinyin
        
        // 提取音调
        let toneNumber = extractToneNumber(from: formattedPinyin)
        let pinyinWithoutTone = removeToneNumber(from: formattedPinyin)
        
        // 处理v字符
        formattedPinyin = formatVCharacter(pinyinWithoutTone, withFormat: format)
        
        // 处理音调
        formattedPinyin = formatTone(formattedPinyin, toneNumber: toneNumber, withFormat: format)
        
        // 处理大小写
        formattedPinyin = formatCase(formattedPinyin, withFormat: format)
        
        return formattedPinyin
    }
    
    /// 提取音调数字
    /// - Parameter pinyin: 拼音字符串
    /// - Returns: 音调数字（1-5），如果没有则返回nil
    private static func extractToneNumber(from pinyin: String) -> Int? {
        let regex = try! NSRegularExpression(pattern: "[1-5]", options: [])
        let matches = regex.matches(in: pinyin, options: [], range: NSRange(location: 0, length: pinyin.count))
        
        if let match = matches.first {
            let toneString = String(pinyin[Range(match.range, in: pinyin)!])
            return Int(toneString)
        }
        
        return nil
    }
    
    /// 移除音调数字
    /// - Parameter pinyin: 拼音字符串
    /// - Returns: 不带音调数字的拼音
    private static func removeToneNumber(from pinyin: String) -> String {
        return pinyin.replacingOccurrences(of: "[1-5]", with: "", options: .regularExpression)
    }
    
    /// 格式化v字符
    /// - Parameters:
    ///   - pinyin: 拼音字符串
    ///   - format: 输出格式
    /// - Returns: 格式化后的拼音
    private static func formatVCharacter(_ pinyin: String, withFormat format: PinyinOutputFormat) -> String {
        var result = pinyin
        
        switch format.vCharType {
        case .vCharacter:
            result = result.replacingOccurrences(of: "u:", with: "v")
            result = result.replacingOccurrences(of: "ü", with: "v")
        case .uUnicode:
            result = result.replacingOccurrences(of: "u:", with: "ü")
            result = result.replacingOccurrences(of: "v", with: "ü")
        case .uAndColon:
            result = result.replacingOccurrences(of: "ü", with: "u:")
            result = result.replacingOccurrences(of: "v", with: "u:")
        }
        
        return result
    }
    
    /// 格式化音调
    /// - Parameters:
    ///   - pinyin: 拼音字符串
    ///   - toneNumber: 音调数字
    ///   - format: 输出格式
    /// - Returns: 格式化后的拼音
    private static func formatTone(_ pinyin: String, toneNumber: Int?, withFormat format: PinyinOutputFormat) -> String {
        guard let toneNumber = toneNumber, let tone = PinyinTone(rawValue: toneNumber) else {
            return pinyin
        }
        
        switch format.toneType {
        case .none:
            return pinyin
        case .toneNumber:
            return pinyin + tone.number
        case .toneSymbol:
            let tonedPinyin = TonedPinyin(pinyin: pinyin, tone: tone)
            return tonedPinyin.withToneSymbol
        }
    }
    
    /// 格式化大小写
    /// - Parameters:
    ///   - pinyin: 拼音字符串
    ///   - format: 输出格式
    /// - Returns: 格式化后的拼音
    private static func formatCase(_ pinyin: String, withFormat format: PinyinOutputFormat) -> String {
        switch format.caseType {
        case .lowercased:
            return pinyin.lowercased()
        case .uppercased:
            return pinyin.uppercased()
        case .capitalized:
            return pinyin.capitalized
        }
    }
    
    /// 创建带颜色的拼音结果
    /// - Parameters:
    ///   - pinyin: 拼音字符串
    ///   - toneNumber: 音调数字
    ///   - format: 输出格式
    /// - Returns: 带颜色的拼音结果
    internal static func createColoredResult(_ pinyin: String, toneNumber: Int?, withFormat format: PinyinOutputFormat) -> ColoredPinyinResult {
        let formattedPinyin = formatSinglePinyin(pinyin, withOutputFormat: format)
        
        if let colorConfig = format.colorConfig, let toneNumber = toneNumber, let tone = PinyinTone(rawValue: toneNumber) {
            let color = tone.getColor(from: colorConfig)
            return ColoredPinyinResult(text: formattedPinyin, color: color, tone: tone)
        } else {
            return ColoredPinyinResult(text: formattedPinyin)
        }
    }
} 