import UIKit
import SnapKit

class JungleWord: UIViewController {

    private let jungleBackdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: UserDefaults.standard.string(forKey: "jungleSelectedImageName") ?? "MainJungle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let jungleSettingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleSettingButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    private let jungleScoreBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "JungleScore")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let jungleScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChangaOne", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0"
        return label
    }()

    private let jungleBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "JungleScore")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let jungleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChangaOne", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Enter"
        return label
    }()
    
    private let jungleCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleCheck"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    private let jungleTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChangaOne", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "60"
        return label
    }()
    
    private var jungleGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "jungleScore") }
        set { UserDefaults.standard.set(newValue, forKey: "jungleScore") }
    }
    
    var jungleScore = 0
    
    var jungleOnReturnToMenu: (() -> ())?
    
    private var jungleEnteredWords: [String] = []
    private let jungleWords3 = ["FOX", "PEN", "ONE", "WOW", "VOW", "PEW", "NEE", "LOP", "WOE", "FEW"]
    private let jungleWords4 = ["WOLF", "FLOW", "PLEA", "PEWL", "FLEE", "WEEP", "VOLE", "LONE", "OPEN", "WOOL"]
    private let jungleWords5 = ["VOWEL", "FELON", "EXPEL", "ELFIN", "WOVEN", "FLOPE", "PEWEL", "LOWNE", "LOPEN", "NOVEL"]

    private let jungleButtonImages = ["JungleXButton", "JungleOButton", "JungleFButton", "JungleNButton", "JunglePButton", "JungleQButton", "JungleEButton", "JungleWButton", "JungleLButton", "JungleVButton"]
    private let jungleButtonSymbols = ["X", "O", "F", "N", "P", "Q", "E", "W", "L", "V"]
    
    var jungleDesiredWordLength: Int = 3
    
    private var jungleButtons: [UIButton] = []
    private var jungleEnteredText: String = ""
    
    private var jungleTimer: Timer?
    private var jungleTimeLeft = 60 {
        didSet {
            jungleTimeLabel.text = "\(jungleTimeLeft)"
            if jungleTimeLeft <= 0 {
                jungleGameOver(isWin: false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jungleScoreLabel.text = "\(jungleGlobalScore)"
        jungleSetupInterfaceLayout()
        jungleSetupButtons()
        jungleStartTimer()
    }

    private func jungleSetupInterfaceLayout() {
        view.addSubview(jungleBackdropImageView)
        view.addSubview(jungleSettingButton)
        view.addSubview(jungleScoreBackgroundImageView)
        jungleScoreBackgroundImageView.addSubview(jungleScoreLabel)
        view.addSubview(jungleBackgroundImageView)
        jungleBackgroundImageView.addSubview(jungleLabel)
        view.addSubview(jungleCheckButton)
        view.addSubview(jungleTimeLabel)
        
        jungleBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        jungleBackgroundImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(110)
        }
        
        jungleCheckButton.addTarget(self, action: #selector(jungleCheckButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleCheckButton)
        jungleCheckButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(jungleBackgroundImageView.snp.bottom).offset(10)
            make.width.equalTo(135)
            make.height.equalTo(50)
        }

        jungleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        jungleTimeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(jungleBackgroundImageView.snp.top).offset(10)
        }
        
        jungleScoreBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }

        jungleScoreLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        jungleSettingButton.addTarget(self, action: #selector(jungleSettingButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleSettingButton)
        jungleSettingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
        }
    }

    private func jungleSetupButtons() {
        let buttonWidth = (view.bounds.width - 70) / 5
        let buttonHeight = buttonWidth
        let buttonSpacing: CGFloat = 10

        for i in 0..<10 {
            let button = UIButton()
            button.setImage(UIImage(named: jungleButtonImages[i]), for: .normal)
            button.contentMode = .scaleAspectFit
            button.clipsToBounds = true
            button.tag = i
            button.addTarget(self, action: #selector(jungleButtonTapped(_:)), for: .touchUpInside)
            addJungleSound(button: button)
            view.addSubview(button)
            jungleButtons.append(button)
            
            let row = i / 5
            let column = i % 5
            
            button.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
                make.bottom.equalToSuperview().inset(50 + (buttonHeight + buttonSpacing) * CGFloat(row))
                if column == 0 {
                    make.left.equalToSuperview().offset(20)
                } else {
                    make.left.equalTo(jungleButtons[i - 1].snp.right).offset(buttonSpacing)
                }
            }
        }
    }

    @objc private func jungleButtonTapped(_ sender: UIButton) {
        if jungleEnteredText.count < 5 || jungleLabel.text == "Try Again" || jungleLabel.text == "Correct!" {
            let symbol = jungleButtonSymbols[sender.tag]
            jungleEnteredText += symbol
            jungleLabel.text = jungleEnteredText
        }
    }
    
    @objc private func jungleSettingButtonTapped() {
        junglePauseGame()
        let jungleSetting = JungleSettingViewController()
        jungleSetting.jungleOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.jungleOnReturnToMenu?()
        }
        jungleSetting.jungleResume = { [weak self] in
            self?.jungleResumeGame()
        }
        jungleSetting.modalPresentationStyle = .overCurrentContext
        present(jungleSetting, animated: true, completion: nil)
    }
    
    private func jungleGameOver(isWin: Bool) {
        let jungleOver = JungleGameOverViewController()
        jungleOver.jungleWin = isWin
        jungleOver.jungleScore = jungleScore
        jungleOver.jungleOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.jungleOnReturnToMenu?()
        }
        jungleOver.jungleOnRestart = { [weak self] in
            self?.jungleRestartGame()
        }
        jungleOver.modalPresentationStyle = .overCurrentContext
        self.present(jungleOver, animated: false, completion: nil)
    }
    
    @objc private func jungleCheckButtonTapped() {
        if jungleEnteredText.isEmpty {
            jungleLabel.text = "Enter a word"
            return
        }
        if jungleCheckWord() {
            if jungleEnteredWords.contains(jungleEnteredText) {
                jungleLabel.text = "Already used"
                jungleEnteredText = ""
            } else {
                jungleEnteredWords.append(jungleEnteredText)
                jungleGlobalScore += 5
                jungleScore += 5
                jungleScoreLabel.text = "\(jungleGlobalScore)"
                jungleEnteredText = ""
                
                if jungleEnteredWords.count == 5 {
                    jungleLabel.text = "You Win!"
                    jungleGameOver(isWin: true)
                } else {
                    jungleLabel.text = "Correct!"
                }
            }
        } else {
            jungleLabel.text = "Try Again"
            jungleEnteredText = ""
        }
    }
    
    private func jungleCheckWord() -> Bool {
        switch jungleEnteredText.count {
        case let length where length == jungleDesiredWordLength:
            switch length {
            case 3:
                return jungleWords3.contains(jungleEnteredText)
            case 4:
                return jungleWords4.contains(jungleEnteredText)
            case 5:
                return jungleWords5.contains(jungleEnteredText)
            default:
                return false
            }
        default:
            return false
        }
    }
    
    private func jungleStartTimer() {
        jungleTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(jungleUpdateTime), userInfo: nil, repeats: true)
    }

    @objc private func jungleUpdateTime() {
        jungleTimeLeft -= 1
    }

    private func jungleStopTimer() {
        jungleTimer?.invalidate()
        jungleTimer = nil
    }
    
    private func junglePauseGame() {
        jungleStopTimer()
    }

    private func jungleResumeGame() {
        jungleStartTimer()
    }

    private func jungleRestartGame() {
        jungleEnteredWords.removeAll()
        jungleTimeLeft = 60
        jungleScore = 0
        jungleScoreLabel.text = "\(jungleGlobalScore)"
        jungleEnteredText = ""
        jungleLabel.text = "Enter"
    }
}
