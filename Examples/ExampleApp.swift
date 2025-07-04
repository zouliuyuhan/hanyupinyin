import Foundation
import hanyupinyin

/// hanyupinyin 示例应用
class ExampleApp {
    
    static func main() {
        print("=== hanyupinyin 示例应用 ===\n")
        
        // 基本用法示例
        basicUsageExample()
        
        // 音调格式示例
        toneFormatExample()
        
        // 多音字处理示例
        polyphoneExample()
        
        // 颜色拼音示例
        coloredPinyinExample()
        
        // 智能功能示例
        smartFeaturesExample()
        
        // 性能测试示例
        performanceExample()
    }
    
    /// 基本用法示例
    static func basicUsageExample() {
        print("📝 基本用法示例")
        print("=" * 30)
        
        let text = "我爱中文编程"
        
        // 基本拼音转换
        let pinyin = text.toPinyin()
        print("原文: \(text)")
        print("拼音: \(pinyin)")
        
        // 拼音首字母
        let acronym = text.toPinyinAcronym()
        print("首字母: \(acronym)")
        
        // 检查是否包含汉字
        print("包含汉字: \(text.hasChineseCharacter)")
        print("汉字数量: \(text.chineseCharacterCount)")
        
        print()
    }
    
    /// 音调格式示例
    static func toneFormatExample() {
        print("🎵 音调格式示例")
        print("=" * 30)
        
        let text = "中国"
        
        // 无音调
        let noTone = text.toPinyin(withFormat: .default)
        print("无音调: \(noTone)")
        
        // 数字音调
        let numberTone = text.toPinyin(withFormat: .withToneNumber)
        print("数字音调: \(numberTone)")
        
        // 音调符号
        let symbolTone = text.toPinyin(withFormat: .withToneSymbol)
        print("音调符号: \(symbolTone)")
        
        print()
    }
    
    /// 多音字处理示例
    static func polyphoneExample() {
        print("🔤 多音字处理示例")
        print("=" * 30)
        
        let text = "中国银行"
        
        // 只取第一个读音
        let firstOnly = text.toPinyin(withFormat: PinyinOutputFormat(
            toneType: .toneSymbol,
            vCharType: .uUnicode,
            caseType: .lowercased,
            polyphoneStrategy: .first
        ))
        print("第一个读音: \(firstOnly)")
        
        // 显示所有读音
        let allReadings = text.toPinyin(withFormat: .polyphone)
        print("所有读音: \(allReadings)")
        
        // 智能选择最常用读音
        let smartReading = text.toSmartPinyin()
        print("智能读音: \(smartReading)")
        
        // 获取多音字信息
        let polyphoneInfo = text.getPolyphoneInfo()
        print("多音字信息: \(polyphoneInfo)")
        
        print()
    }
    
    /// 颜色拼音示例
    static func coloredPinyinExample() {
        print("🌈 颜色拼音示例")
        print("=" * 30)
        
        let text = "我爱中文"
        let coloredResults = text.toColoredPinyin()
        
        for result in coloredResults {
            let toneInfo = result.tone != nil ? "音调\(result.tone!.rawValue)声" : "非汉字"
            let colorInfo = result.color ?? "无颜色"
            print("\(result.text) - \(toneInfo) - \(colorInfo)")
        }
        
        print()
    }
    
    /// 智能功能示例
    static func smartFeaturesExample() {
        print("🧠 智能功能示例")
        print("=" * 30)
        
        let text = "学习中文"
        
        // 生成学习卡片
        let cards = text.generateLearningCards()
        print("学习卡片:")
        for card in cards {
            print("  汉字: \(card.character)")
            print("  拼音: \(card.pinyin.joined(separator: ", "))")
            print("  多音字: \(card.isPolyphone ? "是" : "否")")
            print("  ---")
        }
        
        print()
    }
    
    /// 性能测试示例
    static func performanceExample() {
        print("⚡ 性能测试示例")
        print("=" * 30)
        
        let longText = String(repeating: "我爱中文编程，Swift是一门很棒的编程语言。", count: 100)
        print("测试文本长度: \(longText.count) 个字符")
        print("汉字数量: \(longText.chineseCharacterCount)")
        
        let startTime = CFAbsoluteTimeGetCurrent()
        let pinyin = longText.toPinyin()
        let endTime = CFAbsoluteTimeGetCurrent()
        
        print("转换耗时: \(String(format: "%.3f", endTime - startTime)) 秒")
        print("转换结果长度: \(pinyin.count) 个字符")
        
        print()
    }
}

// 扩展字符串重复功能
extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}

// 运行示例
// ExampleApp.main() 