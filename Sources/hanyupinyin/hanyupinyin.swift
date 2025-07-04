import Foundation

/// 汉字Unicode范围
internal struct HanziCodePoint {
    static let start: UInt32 = 0x4E00
    static let end: UInt32 = 0x9FFF
    static let extendedStart: UInt32 = 0x3400  // 扩展A区
    static let extendedEnd: UInt32 = 0x4DBF
}

/// 汉语拼音转换器
public class hanyupinyin {
    
    /// 单例实例
    public static let shared = hanyupinyin()
    
    /// 拼音字典缓存
    private var unicodeToPinyinTable: [String: String] = [:]
    
    /// 常用字频率表（用于多音字处理）
    private var characterFrequencyTable: [String: Int] = [:]
    
    /// 多音字优先级表
    private var polyphonePriorityTable: [String: [String]] = [:]
    
    /// 初始化
    private init() {
        loadResources()
    }
    
    /// 加载资源文件
    private func loadResources() {
        // 加载拼音字典
        loadPinyinDictionary()
        
        // 加载多音字优先级表
        loadPolyphonePriorityTable()
        
        // 加载字频表
        loadCharacterFrequencyTable()
    }
    
    /// 加载拼音字典
    private func loadPinyinDictionary() {
        guard let resourcePath = Bundle.module.path(forResource: "unicode_to_hanyu_pinyin", ofType: "txt") else {
            print("警告：无法找到拼音字典文件")
            return
        }
        
        do {
            let content = try String(contentsOfFile: resourcePath, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            
            for line in lines {
                let components = line.components(separatedBy: .whitespaces)
                if components.count >= 2 {
                    let unicode = components[0]
                    let pinyin = components[1]
                    unicodeToPinyinTable[unicode] = pinyin
                }
            }
        } catch {
            print("加载拼音字典失败：\(error)")
        }
    }
    
    /// 加载多音字优先级表
    private func loadPolyphonePriorityTable() {
        // 这里可以加载一个包含多音字常用读音优先级的文件
        // 现在先硬编码一些常见的多音字
        polyphonePriorityTable = [
            "中": ["zhong1", "zhong4"],
            "了": ["le5", "liao3"],
            "的": ["de5", "di4", "di2"],
            "行": ["xing2", "hang2"],
            "数": ["shu4", "shu3"],
            "长": ["chang2", "zhang3"],
            "重": ["zhong4", "chong2"],
            "发": ["fa1", "fa4"],
            "干": ["gan1", "gan4"],
            "角": ["jiao3", "jue2"],
            "结": ["jie2", "jie1"],
            "空": ["kong1", "kong4"],
            "累": ["lei4", "lei2", "lei3"],
            "论": ["lun4", "lun2"],
            "没": ["mei2", "mo4"],
            "强": ["qiang2", "jiang4"],
            "少": ["shao3", "shao4"],
            "省": ["sheng3", "xing3"],
            "为": ["wei2", "wei4"],
            "要": ["yao4", "yao1"],
            "应": ["ying1", "ying4"],
            "着": ["zhe5", "zhao2", "zhuo2"],
            "只": ["zhi3", "zhi1"],
            "种": ["zhong3", "zhong4"]
        ]
    }
    
    /// 加载字频表
    private func loadCharacterFrequencyTable() {
        // 这里可以加载一个包含汉字使用频率的文件
        // 现在先硬编码一些高频字
        characterFrequencyTable = [
            "的": 1000000,
            "一": 900000,
            "是": 800000,
            "在": 700000,
            "不": 600000,
            "了": 500000,
            "有": 400000,
            "和": 300000,
            "人": 250000,
            "这": 200000
        ]
    }
    
    /// 获取汉字的拼音数组
    /// - Parameters:
    ///   - charCodePoint: 字符的Unicode码点
    ///   - outputFormat: 输出格式
    /// - Returns: 拼音数组
    public func pinyinArray(withCharCodePoint charCodePoint: UInt32, outputFormat: PinyinOutputFormat = .default) -> [String] {
        let codePointHex = String(format: "%X", charCodePoint)
        
        guard let pinyinString = unicodeToPinyinTable[codePointHex] else {
            return []
        }
        
        // 解析拼音字符串
        let pinyinArray = parsePinyinString(pinyinString)
        
        // 根据多音字策略处理
        let processedArray = processPolyphone(pinyinArray, character: String(UnicodeScalar(charCodePoint) ?? UnicodeScalar(0x4E00)!), strategy: outputFormat.polyphoneStrategy)
        
        // 格式化拼音
        return PinyinFormatter.format(processedArray, withOutputFormat: outputFormat)
    }
    
    /// 解析拼音字符串
    /// - Parameter pinyinString: 原始拼音字符串，如"(zhong1,zhong4)"
    /// - Returns: 拼音数组
    private func parsePinyinString(_ pinyinString: String) -> [String] {
        // 移除括号
        let cleaned = pinyinString.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        
        // 处理特殊情况
        if cleaned == "none0" {
            return []
        }
        
        // 分割多个拼音
        return cleaned.components(separatedBy: ",")
    }
    
    /// 处理多音字
    /// - Parameters:
    ///   - pinyinArray: 拼音数组
    ///   - character: 汉字字符
    ///   - strategy: 多音字处理策略
    /// - Returns: 处理后的拼音数组
    private func processPolyphone(_ pinyinArray: [String], character: String, strategy: PolyphoneStrategy) -> [String] {
        switch strategy {
        case .first:
            return pinyinArray.isEmpty ? [] : [pinyinArray.first!]
        case .all:
            return pinyinArray
        case .most_common:
            // 根据优先级表或字频表选择最常用的读音
            if let priorityArray = polyphonePriorityTable[character] {
                for priority in priorityArray {
                    if pinyinArray.contains(priority) {
                        return [priority]
                    }
                }
            }
            return pinyinArray.isEmpty ? [] : [pinyinArray.first!]
        }
    }
    
    /// 判断是否为汉字
    /// - Parameter charCodePoint: 字符的Unicode码点
    /// - Returns: 是否为汉字
    public func isHanzi(ofCharCodePoint charCodePoint: UInt32) -> Bool {
        return (charCodePoint >= HanziCodePoint.start && charCodePoint <= HanziCodePoint.end) ||
               (charCodePoint >= HanziCodePoint.extendedStart && charCodePoint <= HanziCodePoint.extendedEnd)
    }
    
    /// 获取带颜色的拼音结果
    /// - Parameters:
    ///   - charCodePoint: 字符的Unicode码点
    ///   - outputFormat: 输出格式
    /// - Returns: 带颜色的拼音结果数组
    public func coloredPinyinArray(withCharCodePoint charCodePoint: UInt32, outputFormat: PinyinOutputFormat = .default) -> [ColoredPinyinResult] {
        let codePointHex = String(format: "%X", charCodePoint)
        
        guard let pinyinString = unicodeToPinyinTable[codePointHex] else {
            return []
        }
        
        let pinyinArray = parsePinyinString(pinyinString)
        let processedArray = processPolyphone(pinyinArray, character: String(UnicodeScalar(charCodePoint) ?? UnicodeScalar(0x4E00)!), strategy: outputFormat.polyphoneStrategy)
        
        var results: [ColoredPinyinResult] = []
        
        for pinyin in processedArray {
            let toneNumber = PinyinFormatter.extractToneNumber(from: pinyin)
            let result = PinyinFormatter.createColoredResult(pinyin, toneNumber: toneNumber, withFormat: outputFormat)
            results.append(result)
        }
        
        return results
    }
}

// MARK: - 私有扩展
private extension PinyinFormatter {
    static func extractToneNumber(from pinyin: String) -> Int? {
        let regex = try! NSRegularExpression(pattern: "[1-5]", options: [])
        let matches = regex.matches(in: pinyin, options: [], range: NSRange(location: 0, length: pinyin.count))
        
        if let match = matches.first {
            let toneString = String(pinyin[Range(match.range, in: pinyin)!])
            return Int(toneString)
        }
        
        return nil
    }
} 