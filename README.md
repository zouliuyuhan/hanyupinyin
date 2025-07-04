# hanyupinyin

[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%20|%20macOS%20|%20watchOS%20|%20tvOS-blue.svg)](https://developer.apple.com)
[![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

一个强大、快速、功能丰富的Swift汉字拼音转换库，专为现代iOS开发设计。相比传统的HanziPinyin库，hanyupinyin提供了更多高级功能，包括完整的多音字支持、音调颜色显示、智能读音选择等。

## ✨ 特性

### 🚀 核心功能
- **完整的拼音转换** - 支持简体和繁体中文
- **多音字智能处理** - 提供多种多音字处理策略
- **三种音调格式** - 无音调、数字音调、拼音音调符号
- **音调颜色支持** - 为每个音调提供独特的颜色标识（开发者可选）
- **Swift Package Manager** - 完全支持SPM，易于集成

### 🎯 高级功能
- **智能读音选择** - 基于使用频率的智能多音字处理
- **异步转换** - 支持异步拼音转换，不阻塞主线程
- **学习卡片生成** - 为语言学习应用生成结构化数据
- **性能优化** - 针对大文本处理进行了优化
- **扩展字符支持** - 支持扩展汉字字符集

### 📱 适用场景
- 歌词显示应用
- 中文学习应用
- 输入法开发
- 文本处理工具
- 语音识别应用

## 📦 安装

### Swift Package Manager

在Xcode中，选择 `File` → `Add Package Dependencies`，然后添加：

```
https://github.com/yourusername/hanyupinyin.git
```

或者在 `Package.swift` 文件中添加：

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/hanyupinyin.git", from: "1.0.0")
]
```

## 🚀 快速开始

### 基本用法

```swift
import hanyupinyin

let text = "我爱中文编程"

// 基本拼音转换
let pinyin = text.toPinyin()
print(pinyin) // "wo ai zhong wen bian cheng"

// 拼音首字母
let acronym = text.toPinyinAcronym()
print(acronym) // "wazwbc"

// 检查是否包含汉字
print(text.hasChineseCharacter) // true
print(text.chineseCharacterCount) // 6
```

### 音调格式

```swift
let text = "中国"

// 无音调（默认）
let noTone = text.toPinyin()
print(noTone) // "zhong guo"

// 数字音调
let numberTone = text.toPinyin(withFormat: .withToneNumber)
print(numberTone) // "zhong1 guo2"

// 音调符号
let symbolTone = text.toPinyin(withFormat: .withToneSymbol)
print(symbolTone) // "zhōng guó"
```

### 多音字处理

```swift
let text = "中国银行"

// 只显示第一个读音
let firstOnly = text.toPinyin(withFormat: PinyinOutputFormat(
    toneType: .toneSymbol,
    vCharType: .uUnicode,
    caseType: .lowercased,
    polyphoneStrategy: .first
))
print(firstOnly) // "zhōng guó yín xíng"

// 显示所有读音
let allReadings = text.toPinyin(withFormat: .polyphone)
print(allReadings) // "zhōng guó yín (xíng,háng)"

// 智能选择最常用读音
let smartReading = text.toSmartPinyin()
print(smartReading) // "zhōng guó yín xíng"

// 获取多音字信息
let polyphoneInfo = text.getPolyphoneInfo()
print(polyphoneInfo) // ["行": ["xing2", "hang2"]]
```

### 颜色拼音

```swift
let text = "我爱中文"

// 使用默认颜色配置
let defaultColorResults = text.toColoredPinyin(withFormat: .withDefaultColors)
for result in defaultColorResults {
    print("文字: \(result.text)")
    print("颜色: \(result.color ?? "无")")
    print("音调: \(result.tone?.rawValue ?? 0)")
}

// 自定义颜色配置
let customColors = PinyinColorConfig(
    firstTone: "#FF6B6B",   // 浅红色
    secondTone: "#4ECDC4",  // 青色
    thirdTone: "#45B7D1",   // 浅蓝色
    fourthTone: "#F9CA24",  // 黄色
    lightTone: "#95A5A6"    // 浅灰色
)
let customFormat = PinyinOutputFormat.withToneSymbol.withColors(customColors)
let customColorResults = text.toColoredPinyin(withFormat: customFormat)

// 禁用颜色
let noColorFormat = PinyinOutputFormat.withToneSymbol.withoutColors()
let noColorResults = text.toColoredPinyin(withFormat: noColorFormat)
```

### 异步转换

```swift
let longText = "很长的中文文本..."

// 异步拼音转换
longText.toPinyin { pinyin in
    print("异步转换完成: \(pinyin)")
}

// 异步首字母转换
longText.toPinyinAcronym { acronym in
    print("异步首字母转换完成: \(acronym)")
}

// 异步颜色拼音转换
longText.toColoredPinyin { coloredResults in
    print("异步颜色拼音转换完成，共\(coloredResults.count)个结果")
}
```

## 🎨 高级功能

### 学习卡片生成

为语言学习应用生成结构化的学习数据：

```swift
let text = "学习中文"
let cards = text.generateLearningCards()

for card in cards {
    print("汉字: \(card.character)")
    print("拼音: \(card.pinyin.joined(separator: ", "))")
    print("是否多音字: \(card.isPolyphone)")
    print("颜色信息: \(card.coloredResults)")
    print("---")
}
```

### 音调颜色系统

```swift
// 获取所有音调信息
let tones = PinyinTone.allCases
for tone in tones {
    print("音调\(tone.rawValue): \(tone.symbol) - \(tone.defaultHexColor)")
}

// 创建带音调的拼音
let tonedPinyin = TonedPinyin(pinyin: "zhong", tone: .first)
print("带符号: \(tonedPinyin.withToneSymbol)") // "zhōng"
print("带数字: \(tonedPinyin.withToneNumber)") // "zhong1"
print("无音调: \(tonedPinyin.withoutTone)") // "zhong"
```

### 自定义输出格式

```swift
// 创建自定义格式
let customFormat = PinyinOutputFormat(
    toneType: .toneSymbol,      // 使用音调符号
    vCharType: .uUnicode,       // 使用ü字符
    caseType: .capitalized,     // 首字母大写
    polyphoneStrategy: .all,    // 显示所有读音
    colorConfig: .default       // 使用默认颜色配置
)

let result = "女孩".toPinyin(withFormat: customFormat)
print(result) // "Nǚ Hái"
```

## 🎵 在歌词应用中的使用

hanyupinyin特别适合歌词显示应用：

```swift
class LyricsViewController: UIViewController {
    
    func displayLyrics(_ lyrics: String) {
        // 获取带颜色的拼音
        let coloredResults = lyrics.toColoredPinyin(withFormat: .withDefaultColors)
        
        // 创建富文本
        let attributedString = NSMutableAttributedString()
        
        for result in coloredResults {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(hex: result.color ?? "#000000") ?? .black,
                .font: UIFont.systemFont(ofSize: 16)
            ]
            
            let attributedText = NSAttributedString(string: result.text + " ", attributes: attributes)
            attributedString.append(attributedText)
        }
        
        lyricsLabel.attributedText = attributedString
    }
    
    func displayLyricsWithPinyin(_ lyrics: String) {
        // 显示汉字和拼音对照
        let pinyin = lyrics.toPinyin(withFormat: .withToneSymbol)
        
        originalLyricsLabel.text = lyrics
        pinyinLyricsLabel.text = pinyin
    }
}

// UIColor扩展用于十六进制颜色
extension UIColor {
    convenience init?(hex: String) {
        let r, g, b: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        
        return nil
    }
}
```

## 📊 性能对比

| 功能 | hanyupinyin | HanziPinyin | 提升 |
|------|-------------|-------------|------|
| 基本转换 | ✅ | ✅ | - |
| 多音字支持 | ✅ 完整支持 | ❌ 仅第一个 | 🚀 |
| 音调符号 | ✅ | ❌ | 🚀 |
| 颜色支持 | ✅ 开发者可选 | ❌ | 🚀 |
| 异步转换 | ✅ | ✅ | - |
| SPM支持 | ✅ | ❌ | 🚀 |
| 智能选择 | ✅ | ❌ | 🚀 |
| 学习功能 | ✅ | ❌ | 🚀 |

## 🔧 配置选项

### PinyinOutputFormat 详解

```swift
public struct PinyinOutputFormat {
    public var toneType: PinyinToneType          // 音调类型
    public var vCharType: PinyinVCharType        // v字符处理
    public var caseType: PinyinCaseType          // 大小写
    public var polyphoneStrategy: PolyphoneStrategy  // 多音字策略
    public var colorConfig: PinyinColorConfig?  // 颜色配置（可选）
}
```

#### 音调类型 (PinyinToneType)
- `.none` - 无音调
- `.toneNumber` - 数字音调 (pin1)
- `.toneSymbol` - 音调符号 (pīn)

#### 多音字策略 (PolyphoneStrategy)
- `.first` - 只返回第一个读音
- `.all` - 返回所有读音
- `.most_common` - 返回最常用的读音

#### 预设格式
- `.default` - 默认格式（无音调，无颜色）
- `.withToneSymbol` - 带音调符号（无颜色）
- `.withToneNumber` - 带数字音调（无颜色）
- `.withDefaultColors` - 带默认颜色配置
- `.polyphone` - 多音字格式（无颜色）
- `.polyphoneWithColors` - 带颜色的多音字格式

#### 颜色配置
- `PinyinColorConfig.default` - 默认颜色配置
- `PinyinColorConfig.none` - 无颜色配置
- `PinyinColorConfig.singleColor(_)` - 单色配置
- 自定义颜色配置

## 🧪 测试

运行测试：

```bash
swift test
```

运行演示：

```bash
swift Demo.swift
```

## 📚 文档

- [使用指南](USAGE.md) - 详细的使用说明
- [功能特性](FEATURES.md) - 完整的功能列表
- [颜色配置指南](COLOR_CONFIG_GUIDE.md) - 颜色配置详细说明

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 🙏 致谢

感谢所有为中文拼音处理做出贡献的开发者们。

---

**hanyupinyin** - 让中文拼音转换更强大！ 🚀 