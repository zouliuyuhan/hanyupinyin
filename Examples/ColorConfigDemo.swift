import Foundation
import hanyupinyin

/// 颜色配置演示
/// 展示hanyupinyin库的灵活颜色配置功能
class ColorConfigDemo {
    
    /// 运行颜色配置演示
    static func run() {
        print("=== hanyupinyin 颜色配置演示 ===\n")
        
        let demoText = "我爱学习中文"
        print("演示文本：\(demoText)\n")
        
        // 1. 无颜色配置
        demonstrateNoColor(demoText)
        
        // 2. 默认颜色配置
        demonstrateDefaultColors(demoText)
        
        // 3. 自定义颜色配置
        demonstrateCustomColors(demoText)
        
        // 4. 单色配置
        demonstrateSingleColor(demoText)
        
        // 5. 便捷方法演示
        demonstrateConvenienceMethods(demoText)
        
        // 6. 多音字颜色配置
        demonstratePolyphoneColors("中国银行")
        
        print("=== 演示完成 ===")
    }
    
    /// 演示无颜色配置
    private static func demonstrateNoColor(_ text: String) {
        print("📝 无颜色配置：")
        
        let format = PinyinOutputFormat.withToneSymbol.withoutColors()
        let results = text.toColoredPinyin(withFormat: format)
        
        for result in results {
            print("  \(result.text) - 颜色: \(result.color ?? "无")")
        }
        print()
    }
    
    /// 演示默认颜色配置
    private static func demonstrateDefaultColors(_ text: String) {
        print("🎨 默认颜色配置：")
        
        let results = text.toColoredPinyin(withFormat: .withDefaultColors)
        
        for result in results {
            let toneInfo = result.tone != nil ? "(\(result.tone!.rawValue)声)" : ""
            print("  \(result.text) - 颜色: \(result.color ?? "无") \(toneInfo)")
        }
        print()
    }
    
    /// 演示自定义颜色配置
    private static func demonstrateCustomColors(_ text: String) {
        print("🌈 自定义颜色配置：")
        
        // 创建温暖色调的颜色配置
        let warmColors = PinyinColorConfig(
            firstTone: "#FF6B6B",   // 温暖的红色
            secondTone: "#FF8E53",  // 橙色
            thirdTone: "#FF6B9D",   // 粉色
            fourthTone: "#C44569",  // 深红色
            lightTone: "#95A5A6"    // 灰色
        )
        
        let format = PinyinOutputFormat.withToneSymbol.withColors(warmColors)
        let results = text.toColoredPinyin(withFormat: format)
        
        for result in results {
            let toneInfo = result.tone != nil ? "(\(result.tone!.rawValue)声)" : ""
            print("  \(result.text) - 颜色: \(result.color ?? "无") \(toneInfo)")
        }
        print()
    }
    
    /// 演示单色配置
    private static func demonstrateSingleColor(_ text: String) {
        print("🔵 单色配置：")
        
        let singleColor = PinyinColorConfig.singleColor("#3498DB")
        let format = PinyinOutputFormat.withToneSymbol.withColors(singleColor)
        let results = text.toColoredPinyin(withFormat: format)
        
        for result in results {
            let toneInfo = result.tone != nil ? "(\(result.tone!.rawValue)声)" : ""
            print("  \(result.text) - 颜色: \(result.color ?? "无") \(toneInfo)")
        }
        print()
    }
    
    /// 演示便捷方法
    private static func demonstrateConvenienceMethods(_ text: String) {
        print("⚡ 便捷方法演示：")
        
        // 从默认格式开始，添加默认颜色
        let format1 = PinyinOutputFormat.default.withDefaultColors()
        let results1 = text.toColoredPinyin(withFormat: format1)
        print("  默认格式 + 默认颜色:")
        for result in results1 {
            print("    \(result.text) - 颜色: \(result.color ?? "无")")
        }
        
        // 从带音调格式开始，禁用颜色
        let format2 = PinyinOutputFormat.withDefaultColors.withoutColors()
        let results2 = text.toColoredPinyin(withFormat: format2)
        print("  带颜色格式 - 禁用颜色:")
        for result in results2 {
            print("    \(result.text) - 颜色: \(result.color ?? "无")")
        }
        print()
    }
    
    /// 演示多音字颜色配置
    private static func demonstratePolyphoneColors(_ text: String) {
        print("🎭 多音字颜色配置：")
        
        // 显示所有多音字读音并带颜色
        let format = PinyinOutputFormat.polyphoneWithColors
        let results = text.toColoredPinyin(withFormat: format)
        
        for result in results {
            let toneInfo = result.tone != nil ? "(\(result.tone!.rawValue)声)" : ""
            print("  \(result.text) - 颜色: \(result.color ?? "无") \(toneInfo)")
        }
        print()
    }
    
    /// 演示颜色配置的高级用法
    static func demonstrateAdvancedUsage() {
        print("=== 高级颜色配置演示 ===\n")
        
        // 1. 主题色配置
        demonstrateThemeColors()
        
        // 2. 可访问性配置
        demonstrateAccessibilityColors()
        
        // 3. 品牌色配置
        demonstrateBrandColors()
        
        print("=== 高级演示完成 ===")
    }
    
    /// 演示主题色配置
    private static func demonstrateThemeColors() {
        print("🌙 深色主题配置：")
        
        let darkTheme = PinyinColorConfig(
            firstTone: "#FF6B6B",   // 亮红色
            secondTone: "#4ECDC4",  // 青绿色
            thirdTone: "#45B7D1",   // 天蓝色
            fourthTone: "#F9CA24",  // 金黄色
            lightTone: "#BDC3C7"    // 浅灰色
        )
        
        let text = "夜晚学习"
        let format = PinyinOutputFormat.withToneSymbol.withColors(darkTheme)
        let results = text.toColoredPinyin(withFormat: format)
        
        for result in results {
            print("  \(result.text) - 颜色: \(result.color ?? "无")")
        }
        print()
    }
    
    /// 演示可访问性配置
    private static func demonstrateAccessibilityColors() {
        print("♿ 高对比度配置：")
        
        let highContrast = PinyinColorConfig(
            firstTone: "#000000",   // 黑色
            secondTone: "#FFFFFF",  // 白色
            thirdTone: "#FF0000",   // 纯红色
            fourthTone: "#0000FF",  // 纯蓝色
            lightTone: "#808080"    // 中灰色
        )
        
        let text = "清晰显示"
        let format = PinyinOutputFormat.withToneSymbol.withColors(highContrast)
        let results = text.toColoredPinyin(withFormat: format)
        
        for result in results {
            print("  \(result.text) - 颜色: \(result.color ?? "无")")
        }
        print()
    }
    
    /// 演示品牌色配置
    private static func demonstrateBrandColors() {
        print("🏢 品牌色配置：")
        
        let brandColors = PinyinColorConfig(
            firstTone: "#1ABC9C",   // 品牌绿
            secondTone: "#3498DB",  // 品牌蓝
            thirdTone: "#9B59B6",   // 品牌紫
            fourthTone: "#E74C3C",  // 品牌红
            lightTone: "#95A5A6"    // 品牌灰
        )
        
        let text = "品牌拼音"
        let format = PinyinOutputFormat.withToneSymbol.withColors(brandColors)
        let results = text.toColoredPinyin(withFormat: format)
        
        for result in results {
            print("  \(result.text) - 颜色: \(result.color ?? "无")")
        }
        print()
    }
}

// MARK: - 使用示例

/// 在实际应用中如何使用颜色配置
class PracticalUsageExample {
    
    /// 歌词应用示例
    static func lyricsAppExample() {
        print("🎵 歌词应用示例：")
        
        let lyrics = "月亮代表我的心"
        
        // 为不同用户偏好配置不同颜色
        let userPreferences = [
            "默认": PinyinColorConfig.default,
            "护眼": PinyinColorConfig(
                firstTone: "#2ECC71", secondTone: "#27AE60",
                thirdTone: "#16A085", fourthTone: "#1ABC9C", lightTone: "#95A5A6"
            ),
            "活力": PinyinColorConfig(
                firstTone: "#E74C3C", secondTone: "#F39C12",
                thirdTone: "#9B59B6", fourthTone: "#3498DB", lightTone: "#7F8C8D"
            )
        ]
        
        for (themeName, colorConfig) in userPreferences {
            print("  \(themeName)主题:")
            let format = PinyinOutputFormat.withToneSymbol.withColors(colorConfig)
            let results = lyrics.toColoredPinyin(withFormat: format)
            
            for result in results {
                print("    \(result.text) - \(result.color ?? "无")")
            }
            print()
        }
    }
    
    /// 教育应用示例
    static func educationAppExample() {
        print("📚 教育应用示例：")
        
        let lesson = "学习汉语拼音"
        
        // 为不同学习阶段配置不同颜色策略
        let learningStages = [
            "初学者": PinyinColorConfig.singleColor("#3498DB"), // 统一颜色，减少干扰
            "进阶者": PinyinColorConfig.default,                 // 标准颜色，区分音调
            "高级者": PinyinColorConfig.none                     // 无颜色，专注内容
        ]
        
        for (stage, colorConfig) in learningStages {
            print("  \(stage):")
            let format = PinyinOutputFormat(
                toneType: .toneSymbol,
                vCharType: .uUnicode,
                caseType: .lowercased,
                polyphoneStrategy: .first,
                colorConfig: colorConfig
            )
            let results = lesson.toColoredPinyin(withFormat: format)
            
            for result in results {
                print("    \(result.text) - \(result.color ?? "无颜色")")
            }
            print()
        }
    }
}

// MARK: - 运行演示

if CommandLine.arguments.contains("--demo") {
    ColorConfigDemo.run()
    ColorConfigDemo.demonstrateAdvancedUsage()
    PracticalUsageExample.lyricsAppExample()
    PracticalUsageExample.educationAppExample()
} 