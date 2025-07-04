#!/usr/bin/env swift

import Foundation

// 为了演示，我们需要手动包含必要的代码
// 在实际使用中，你只需要 import hanyupinyin

print("🚀 hanyupinyin 演示")
print("=" * 50)

// 演示文本
let demoTexts = [
    "我爱中文编程",
    "Swift是一门很棒的编程语言",
    "中国银行",
    "学习拼音很有趣",
    "音调颜色让学习更生动"
]

print("\n📝 基本拼音转换演示")
print("-" * 30)
for text in demoTexts {
    print("原文: \(text)")
    // 这里需要实际的库调用
    // let pinyin = text.toPinyin()
    // print("拼音: \(pinyin)")
    print("拼音: [需要实际运行库]")
    print()
}

print("\n🎵 音调格式演示")
print("-" * 30)
let toneDemo = "中国"
print("原文: \(toneDemo)")
print("无音调: [需要实际运行库]")
print("数字音调: [需要实际运行库]")
print("音调符号: [需要实际运行库]")

print("\n🔤 多音字演示")
print("-" * 30)
let polyphoneDemo = "中国银行"
print("原文: \(polyphoneDemo)")
print("第一个读音: [需要实际运行库]")
print("所有读音: [需要实际运行库]")
print("智能读音: [需要实际运行库]")

print("\n🌈 音调颜色演示")
print("-" * 30)
print("默认颜色配置:")
print("  第一声 (阴平): 红色 #FF0000")
print("  第二声 (阳平): 绿色 #00FF00")
print("  第三声 (上声): 蓝色 #0000FF")
print("  第四声 (去声): 橙色 #FF7F00")
print("  轻声:          灰色 #7F7F7F")
print()
print("颜色配置选项:")
print("  ✅ 使用默认颜色: .withDefaultColors")
print("  ✅ 自定义颜色: .withColors(customConfig)")
print("  ✅ 单色配置: .singleColor(\"#3498DB\")")
print("  ✅ 禁用颜色: .withoutColors()")
print("  ✅ 主题色配置: 深色/浅色主题")
print("  ✅ 可访问性配置: 高对比度颜色")

print("\n💡 使用建议")
print("-" * 30)
print("1. 歌词应用: 使用颜色拼音增强视觉效果")
print("2. 学习应用: 根据用户水平选择颜色策略")
print("3. 输入法: 使用智能读音选择")
print("4. 大文本: 使用异步转换避免阻塞")
print("5. 主题适配: 根据深色/浅色模式调整颜色")
print("6. 可访问性: 为视觉障碍用户提供高对比度选项")

print("\n🎯 特性对比")
print("-" * 30)
print("✅ 完整的多音字支持")
print("✅ 三种音调格式")
print("✅ 灵活的颜色配置（开发者可选）")
print("✅ Swift Package Manager")
print("✅ 异步转换支持")
print("✅ 智能读音选择")
print("✅ 学习卡片生成")
print("✅ 主题色和可访问性支持")

print("\n🚀 开始使用")
print("-" * 30)
print("1. 在Xcode中添加Swift Package:")
print("   https://github.com/yourusername/hanyupinyin.git")
print("2. import hanyupinyin")
print("3. 调用 \"你的文本\".toPinyin()")

print("\n" + "=" * 50)
print("hanyupinyin - 让中文拼音转换更强大！")

// 字符串重复扩展
extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
} 