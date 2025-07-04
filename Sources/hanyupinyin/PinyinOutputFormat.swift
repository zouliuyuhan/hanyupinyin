import Foundation

/// 拼音音调输出类型
public enum PinyinToneType {
    case none           // 无音调
    case toneNumber     // 数字音调 (pin1 yin1)
    case toneSymbol     // 音调符号 (pīn yīn)
}

/// 拼音字符类型
public enum PinyinVCharType {
    case vCharacter     // v字符 (nv)
    case uUnicode       // ü字符 (nü)
    case uAndColon      // u:字符 (nu:)
}

/// 拼音大小写类型
public enum PinyinCaseType {
    case lowercased     // 小写
    case uppercased     // 大写
    case capitalized    // 首字母大写
}

/// 多音字处理策略
public enum PolyphoneStrategy {
    case first          // 只取第一个读音
    case all            // 返回所有读音
    case most_common    // 返回最常用的读音
}

/// 拼音输出格式配置
public struct PinyinOutputFormat {
    public var toneType: PinyinToneType
    public var vCharType: PinyinVCharType
    public var caseType: PinyinCaseType
    public var polyphoneStrategy: PolyphoneStrategy
    public var colorConfig: PinyinColorConfig?
    
    /// 默认格式（无颜色）
    public static var `default`: PinyinOutputFormat {
        return PinyinOutputFormat(
            toneType: .none,
            vCharType: .vCharacter,
            caseType: .lowercased,
            polyphoneStrategy: .first,
            colorConfig: nil
        )
    }
    
    /// 带音调符号的格式（无颜色）
    public static var withToneSymbol: PinyinOutputFormat {
        return PinyinOutputFormat(
            toneType: .toneSymbol,
            vCharType: .uUnicode,
            caseType: .lowercased,
            polyphoneStrategy: .first,
            colorConfig: nil
        )
    }
    
    /// 带数字音调的格式（无颜色）
    public static var withToneNumber: PinyinOutputFormat {
        return PinyinOutputFormat(
            toneType: .toneNumber,
            vCharType: .vCharacter,
            caseType: .lowercased,
            polyphoneStrategy: .first,
            colorConfig: nil
        )
    }
    
    /// 带默认颜色的格式
    public static var withDefaultColors: PinyinOutputFormat {
        return PinyinOutputFormat(
            toneType: .toneSymbol,
            vCharType: .uUnicode,
            caseType: .lowercased,
            polyphoneStrategy: .first,
            colorConfig: .default
        )
    }
    
    /// 多音字格式（无颜色）
    public static var polyphone: PinyinOutputFormat {
        return PinyinOutputFormat(
            toneType: .toneSymbol,
            vCharType: .uUnicode,
            caseType: .lowercased,
            polyphoneStrategy: .all,
            colorConfig: nil
        )
    }
    
    /// 带颜色的多音字格式
    public static var polyphoneWithColors: PinyinOutputFormat {
        return PinyinOutputFormat(
            toneType: .toneSymbol,
            vCharType: .uUnicode,
            caseType: .lowercased,
            polyphoneStrategy: .all,
            colorConfig: .default
        )
    }
    
    public init(
        toneType: PinyinToneType,
        vCharType: PinyinVCharType,
        caseType: PinyinCaseType,
        polyphoneStrategy: PolyphoneStrategy = .first,
        colorConfig: PinyinColorConfig? = nil
    ) {
        self.toneType = toneType
        self.vCharType = vCharType
        self.caseType = caseType
        self.polyphoneStrategy = polyphoneStrategy
        self.colorConfig = colorConfig
    }
    
    /// 便捷方法：启用默认颜色
    public func withDefaultColors() -> PinyinOutputFormat {
        var format = self
        format.colorConfig = .default
        return format
    }
    
    /// 便捷方法：自定义颜色
    public func withColors(_ colorConfig: PinyinColorConfig) -> PinyinOutputFormat {
        var format = self
        format.colorConfig = colorConfig
        return format
    }
    
    /// 便捷方法：禁用颜色
    public func withoutColors() -> PinyinOutputFormat {
        var format = self
        format.colorConfig = nil
        return format
    }
}

/// 拼音颜色配置
/// 开发者可以自定义每个音调的颜色，如果不设置则不显示颜色
public struct PinyinColorConfig {
    public let firstTone: String?   // 第一声颜色
    public let secondTone: String?  // 第二声颜色
    public let thirdTone: String?   // 第三声颜色
    public let fourthTone: String?  // 第四声颜色
    public let lightTone: String?   // 轻声颜色
    
    /// 默认颜色配置
    public static let `default` = PinyinColorConfig(
        firstTone: "#FF0000",   // 红色
        secondTone: "#00FF00",  // 绿色
        thirdTone: "#0000FF",   // 蓝色
        fourthTone: "#FF7F00",  // 橙色
        lightTone: "#7F7F7F"    // 灰色
    )
    
    /// 无颜色配置
    public static let none = PinyinColorConfig(
        firstTone: nil,
        secondTone: nil,
        thirdTone: nil,
        fourthTone: nil,
        lightTone: nil
    )
    
    /// 自定义颜色配置
    public init(firstTone: String?, secondTone: String?, thirdTone: String?, fourthTone: String?, lightTone: String?) {
        self.firstTone = firstTone
        self.secondTone = secondTone
        self.thirdTone = thirdTone
        self.fourthTone = fourthTone
        self.lightTone = lightTone
    }
    
    /// 创建单色配置（所有音调使用同一颜色）
    public static func singleColor(_ color: String) -> PinyinColorConfig {
        return PinyinColorConfig(
            firstTone: color,
            secondTone: color,
            thirdTone: color,
            fourthTone: color,
            lightTone: color
        )
    }
    
    /// 创建渐变色配置
    public static func gradient(from startColor: String, to endColor: String) -> PinyinColorConfig {
        // 简化实现，实际可以计算渐变色
        return PinyinColorConfig(
            firstTone: startColor,
            secondTone: interpolateColor(startColor, endColor, 0.25),
            thirdTone: interpolateColor(startColor, endColor, 0.5),
            fourthTone: interpolateColor(startColor, endColor, 0.75),
            lightTone: endColor
        )
    }
    
    /// 颜色插值辅助函数（简化实现）
    private static func interpolateColor(_ color1: String, _ color2: String, _ ratio: Double) -> String {
        // 简化实现，返回中间色
        return ratio < 0.5 ? color1 : color2
    }
}

/// 带颜色信息的拼音结果
public struct ColoredPinyinResult {
    public let text: String
    public let color: String?
    public let tone: PinyinTone?
    
    public init(text: String, color: String? = nil, tone: PinyinTone? = nil) {
        self.text = text
        self.color = color
        self.tone = tone
    }
} 