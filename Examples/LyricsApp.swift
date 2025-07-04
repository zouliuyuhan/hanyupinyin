import UIKit
import hanyupinyin

/// 歌词应用示例
/// 展示如何在歌词词典应用中使用hanyupinyin
class LyricsViewController: UIViewController {
    
    @IBOutlet weak var originalLyricsLabel: UILabel!
    @IBOutlet weak var pinyinLyricsLabel: UILabel!
    @IBOutlet weak var coloredLyricsLabel: UILabel!
    @IBOutlet weak var polyphoneLyricsLabel: UILabel!
    
    // 示例歌词
    let sampleLyrics = """
    我爱你中国
    心爱的母亲
    我为你流泪
    也为你自豪
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayLyrics()
    }
    
    private func setupUI() {
        title = "歌词拼音显示"
        
        // 设置标签样式
        originalLyricsLabel.numberOfLines = 0
        pinyinLyricsLabel.numberOfLines = 0
        coloredLyricsLabel.numberOfLines = 0
        polyphoneLyricsLabel.numberOfLines = 0
        
        originalLyricsLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        pinyinLyricsLabel.font = UIFont.systemFont(ofSize: 16)
        coloredLyricsLabel.font = UIFont.systemFont(ofSize: 16)
        polyphoneLyricsLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func displayLyrics() {
        // 1. 显示原始歌词
        originalLyricsLabel.text = sampleLyrics
        
        // 2. 显示拼音歌词（音调符号）
        let pinyinLyrics = sampleLyrics.toPinyin(withFormat: .withToneSymbol, separator: " ")
        pinyinLyricsLabel.text = pinyinLyrics
        
        // 3. 显示颜色拼音歌词
        displayColoredLyrics()
        
        // 4. 显示多音字信息
        displayPolyphoneLyrics()
    }
    
    /// 显示带颜色的拼音歌词
    private func displayColoredLyrics() {
        let coloredResults = sampleLyrics.toColoredPinyin(withFormat: .withDefaultColors)
        let attributedString = NSMutableAttributedString()
        
        for result in coloredResults {
            var attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16)
            ]
            
            // 设置颜色
            if let colorHex = result.color {
                attributes[.foregroundColor] = UIColor(hex: colorHex) ?? .black
            } else {
                attributes[.foregroundColor] = UIColor.black
            }
            
            // 为汉字添加背景色
            if result.tone != nil {
                attributes[.backgroundColor] = UIColor(hex: result.color ?? "#FFFFFF")?.withAlphaComponent(0.2)
            }
            
            let text = result.text == "\n" ? "\n" : result.text + " "
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedString.append(attributedText)
        }
        
        coloredLyricsLabel.attributedText = attributedString
    }
    
    /// 显示多音字信息
    private func displayPolyphoneLyrics() {
        let polyphoneInfo = sampleLyrics.getPolyphoneInfo()
        
        if polyphoneInfo.isEmpty {
            polyphoneLyricsLabel.text = "此歌词中没有多音字"
        } else {
            var polyphoneText = "多音字信息：\n"
            for (character, pinyins) in polyphoneInfo {
                polyphoneText += "\(character): \(pinyins.joined(separator: ", "))\n"
            }
            polyphoneLyricsLabel.text = polyphoneText
        }
    }
}

// MARK: - 歌词播放控制器
class LyricsPlayerViewController: UIViewController {
    
    @IBOutlet weak var lyricsDisplayView: UIView!
    @IBOutlet weak var currentLineLabel: UILabel!
    @IBOutlet weak var nextLineLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var formatSegmentedControl: UISegmentedControl!
    
    // 歌词数据
    let lyricsLines = [
        "我爱你中国",
        "心爱的母亲",
        "我为你流泪",
        "也为你自豪"
    ]
    
    private var currentLineIndex = 0
    private var displayTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateLyricsDisplay()
    }
    
    private func setupUI() {
        title = "歌词播放器"
        
        currentLineLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nextLineLabel.font = UIFont.systemFont(ofSize: 16)
        nextLineLabel.textColor = .gray
        
        formatSegmentedControl.removeAllSegments()
        formatSegmentedControl.insertSegment(withTitle: "无音调", at: 0, animated: false)
        formatSegmentedControl.insertSegment(withTitle: "数字音调", at: 1, animated: false)
        formatSegmentedControl.insertSegment(withTitle: "音调符号", at: 2, animated: false)
        formatSegmentedControl.insertSegment(withTitle: "彩色", at: 3, animated: false)
        formatSegmentedControl.selectedSegmentIndex = 0
        
        formatSegmentedControl.addTarget(self, action: #selector(formatChanged), for: .valueChanged)
    }
    
    @objc private func formatChanged() {
        updateLyricsDisplay()
    }
    
    private func updateLyricsDisplay() {
        guard currentLineIndex < lyricsLines.count else { return }
        
        let currentLine = lyricsLines[currentLineIndex]
        let nextLine = currentLineIndex + 1 < lyricsLines.count ? lyricsLines[currentLineIndex + 1] : ""
        
        // 根据选择的格式显示当前行
        switch formatSegmentedControl.selectedSegmentIndex {
        case 0: // 无音调
            currentLineLabel.text = currentLine.toPinyin()
            nextLineLabel.text = nextLine.toPinyin()
        case 1: // 数字音调
            currentLineLabel.text = currentLine.toPinyin(withFormat: .withToneNumber)
            nextLineLabel.text = nextLine.toPinyin(withFormat: .withToneNumber)
        case 2: // 音调符号
            currentLineLabel.text = currentLine.toPinyin(withFormat: .withToneSymbol)
            nextLineLabel.text = nextLine.toPinyin(withFormat: .withToneSymbol)
        case 3: // 彩色
            displayColoredLine(currentLine, label: currentLineLabel)
            displayColoredLine(nextLine, label: nextLineLabel)
        default:
            break
        }
    }
    
    private func displayColoredLine(_ line: String, label: UILabel) {
        let coloredResults = line.toColoredPinyin(withFormat: .withDefaultColors)
        let attributedString = NSMutableAttributedString()
        
        for result in coloredResults {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: label.font!,
                .foregroundColor: UIColor(hex: result.color ?? "#000000") ?? .black
            ]
            
            let attributedText = NSAttributedString(string: result.text + " ", attributes: attributes)
            attributedString.append(attributedText)
        }
        
        label.attributedText = attributedString
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if displayTimer == nil {
            startPlaying()
        } else {
            stopPlaying()
        }
    }
    
    private func startPlaying() {
        playButton.setTitle("暂停", for: .normal)
        displayTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.nextLine()
        }
    }
    
    private func stopPlaying() {
        playButton.setTitle("播放", for: .normal)
        displayTimer?.invalidate()
        displayTimer = nil
    }
    
    private func nextLine() {
        currentLineIndex += 1
        if currentLineIndex >= lyricsLines.count {
            currentLineIndex = 0
        }
        updateLyricsDisplay()
    }
}

// MARK: - 学习模式控制器
class LyricsLearningViewController: UIViewController {
    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var pinyinLabel: UILabel!
    @IBOutlet weak var toneInfoLabel: UILabel!
    @IBOutlet weak var polyphoneInfoLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    private var learningCards: [PinyinLearningCard] = []
    private var currentCardIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLearningCards()
        displayCurrentCard()
    }
    
    private func setupLearningCards() {
        let learningText = "我爱你中国心爱的母亲"
        learningCards = learningText.generateLearningCards()
    }
    
    private func displayCurrentCard() {
        guard currentCardIndex < learningCards.count else { return }
        
        let card = learningCards[currentCardIndex]
        
        // 显示汉字
        characterLabel.text = card.character
        
        // 显示拼音
        pinyinLabel.text = card.pinyin.joined(separator: " / ")
        
        // 显示音调信息
        if let firstResult = card.coloredResults.first,
           let tone = firstResult.tone {
            toneInfoLabel.text = "第\(tone.rawValue)声 (\(getToneName(tone)))"
            toneInfoLabel.textColor = UIColor(hex: firstResult.color ?? "#000000")
        } else {
            toneInfoLabel.text = "非汉字"
            toneInfoLabel.textColor = .gray
        }
        
        // 显示多音字信息
        if card.isPolyphone {
            polyphoneInfoLabel.text = "多音字：\(card.pinyin.joined(separator: ", "))"
            polyphoneInfoLabel.textColor = .orange
        } else {
            polyphoneInfoLabel.text = "单音字"
            polyphoneInfoLabel.textColor = .blue
        }
        
        // 更新按钮状态
        nextButton.setTitle(currentCardIndex == learningCards.count - 1 ? "重新开始" : "下一个", for: .normal)
    }
    
    private func getToneName(_ tone: PinyinTone) -> String {
        switch tone {
        case .first: return "阴平"
        case .second: return "阳平"
        case .third: return "上声"
        case .fourth: return "去声"
        case .light: return "轻声"
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        currentCardIndex += 1
        if currentCardIndex >= learningCards.count {
            currentCardIndex = 0
        }
        displayCurrentCard()
    }
}

// MARK: - UIColor扩展
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