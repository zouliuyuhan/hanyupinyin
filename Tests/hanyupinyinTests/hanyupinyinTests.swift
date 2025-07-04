import XCTest
@testable import hanyupinyin

final class hanyupinyinTests: XCTestCase {
    
    func testBasicPinyinConversion() {
        let text = "我爱中文"
        let pinyin = text.toPinyin()
        XCTAssertFalse(pinyin.isEmpty)
        print("基本拼音转换: \(text) -> \(pinyin)")
    }
    
    func testToneSymbolConversion() {
        let text = "我爱中文"
        let pinyin = text.toPinyin(withFormat: .withToneSymbol)
        XCTAssertFalse(pinyin.isEmpty)
        print("音调符号转换: \(text) -> \(pinyin)")
    }
    
    func testToneNumberConversion() {
        let text = "我爱中文"
        let pinyin = text.toPinyin(withFormat: .withToneNumber)
        XCTAssertFalse(pinyin.isEmpty)
        print("数字音调转换: \(text) -> \(pinyin)")
    }
    
    func testPolyphoneConversion() {
        let text = "中国"
        let pinyin = text.toPinyin(withFormat: .polyphone)
        XCTAssertFalse(pinyin.isEmpty)
        print("多音字转换: \(text) -> \(pinyin)")
    }
    
    func testAcronymConversion() {
        let text = "我爱中文"
        let acronym = text.toPinyinAcronym()
        XCTAssertFalse(acronym.isEmpty)
        print("拼音首字母: \(text) -> \(acronym)")
    }
    
    func testColoredPinyinConversion() {
        let text = "我爱中文"
        let coloredResults = text.toColoredPinyin()
        XCTAssertFalse(coloredResults.isEmpty)
        
        for result in coloredResults {
            print("带颜色拼音: \(result.text), 颜色: \(result.color ?? "无"), 音调: \(result.tone?.rawValue ?? 0)")
        }
    }
    
    func testChineseCharacterDetection() {
        let chineseText = "我爱中文"
        let englishText = "I love Chinese"
        let mixedText = "我爱Chinese"
        
        XCTAssertTrue(chineseText.hasChineseCharacter)
        XCTAssertFalse(englishText.hasChineseCharacter)
        XCTAssertTrue(mixedText.hasChineseCharacter)
        
        XCTAssertEqual(chineseText.chineseCharacterCount, 4)
        XCTAssertEqual(englishText.chineseCharacterCount, 0)
        XCTAssertEqual(mixedText.chineseCharacterCount, 2)
    }
    
    func testPolyphoneInfo() {
        let text = "中国银行"
        let polyphoneInfo = text.getPolyphoneInfo()
        print("多音字信息: \(polyphoneInfo)")
    }
    
    func testSmartPinyinConversion() {
        let text = "中国银行"
        let smartPinyin = text.toSmartPinyin()
        XCTAssertFalse(smartPinyin.isEmpty)
        print("智能拼音转换: \(text) -> \(smartPinyin)")
    }
    
    func testLearningCards() {
        let text = "中国"
        let cards = text.generateLearningCards()
        XCTAssertFalse(cards.isEmpty)
        
        for card in cards {
            print("学习卡片 - 汉字: \(card.character), 拼音: \(card.pinyin), 多音字: \(card.isPolyphone)")
        }
    }
    
    func testPinyinTones() {
        let tones = PinyinTone.allCases
        for tone in tones {
            print("音调 \(tone.rawValue): 符号=\(tone.symbol), 数字=\(tone.number), 默认颜色=\(tone.defaultHexColor)")
        }
    }
    
    func testTonedPinyin() {
        let tonedPinyin = TonedPinyin(pinyin: "zhong", tone: .first)
        print("带音调拼音: \(tonedPinyin.withToneSymbol)")
        
        let tonedPinyin2 = TonedPinyin(pinyin: "guo", tone: .second)
        print("带音调拼音: \(tonedPinyin2.withToneSymbol)")
    }
    
    func testPerformance() {
        let longText = String(repeating: "我爱中文编程，Swift是一门很棒的编程语言。", count: 100)
        
        measure {
            let _ = longText.toPinyin()
        }
    }
    
    func testAsyncConversion() {
        let expectation = XCTestExpectation(description: "异步拼音转换")
        let text = "我爱中文"
        
        text.toPinyin { pinyin in
            XCTAssertFalse(pinyin.isEmpty)
            print("异步拼音转换: \(text) -> \(pinyin)")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCustomColorConfig() {
        let text = "我爱中文"
        
        // 测试默认颜色配置
        let defaultColorResults = text.toColoredPinyin(withFormat: .withDefaultColors)
        print("默认颜色配置:")
        for result in defaultColorResults {
            print("  \(result.text) - 颜色: \(result.color ?? "无")")
        }
        
        // 测试自定义颜色配置
        let customColorConfig = PinyinColorConfig(
            firstTone: "#FF6B6B",   // 浅红色
            secondTone: "#4ECDC4",  // 青色
            thirdTone: "#45B7D1",   // 浅蓝色
            fourthTone: "#F9CA24",  // 黄色
            lightTone: "#95A5A6"    // 浅灰色
        )
        let customFormat = PinyinOutputFormat.withToneSymbol.withColors(customColorConfig)
        let customColorResults = text.toColoredPinyin(withFormat: customFormat)
        print("自定义颜色配置:")
        for result in customColorResults {
            print("  \(result.text) - 颜色: \(result.color ?? "无")")
        }
        
        // 测试无颜色配置
        let noColorFormat = PinyinOutputFormat.withToneSymbol.withoutColors()
        let noColorResults = text.toColoredPinyin(withFormat: noColorFormat)
        print("无颜色配置:")
        for result in noColorResults {
            print("  \(result.text) - 颜色: \(result.color ?? "无")")
        }
        
        // 测试单色配置
        let singleColorConfig = PinyinColorConfig.singleColor("#9B59B6")
        let singleColorFormat = PinyinOutputFormat.withToneSymbol.withColors(singleColorConfig)
        let singleColorResults = text.toColoredPinyin(withFormat: singleColorFormat)
        print("单色配置:")
        for result in singleColorResults {
            print("  \(result.text) - 颜色: \(result.color ?? "无")")
        }
    }
} 