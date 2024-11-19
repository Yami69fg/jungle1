import UIKit
import SnapKit

class ReflexGame: UIViewController {
    
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
        return label
    }()
    
    private let jungleTimerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChangaOne", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let jungleHoldButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleGreen"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    private var jungleGlobalScore = 0
    private var jungleLocalScore = 0
    var jungleOnReturnToMenu: (() -> ())?
    
    private var jungleTimer: Timer?
    private var jungleTimeLeft: Int = 30
    private var jungleIsHoldingButton = false
    private var jungleIsButtonRed = false
    private var jungleRedButtonTimer: Timer?
    var jungleGameTimerInterval: TimeInterval = 1.0
    private var jungleGameStarted = false
    private var jungleIsPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jungleSetupInterface()
        jungleTimerLabel.text = "\(jungleTimeLeft)"
        jungleGlobalScore = jungleGlobalScoreValue
        jungleUpdateGlobalScoreLabel()
    }
    
    private func jungleSetupInterface() {
        view.addSubview(jungleBackdropImageView)
        view.addSubview(jungleScoreBackgroundImageView)
        view.addSubview(jungleScoreLabel)
        view.addSubview(jungleHoldButton)
        view.addSubview(jungleSettingButton)
        view.addSubview(jungleTimerLabel)
        
        jungleBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        jungleScoreBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        jungleScoreLabel.snp.makeConstraints { make in
            make.edges.equalTo(jungleScoreBackgroundImageView)
        }
        
        jungleSettingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
        }
        
        jungleHoldButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        jungleTimerLabel.snp.makeConstraints { make in
            make.center.equalTo(jungleHoldButton)
        }
        
        jungleSettingButton.addTarget(self, action: #selector(jungleSettingButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleSettingButton)
        jungleHoldButton.addTarget(self, action: #selector(jungleHandleButtonTouchDown), for: .touchDown)
        addJungleSound(button: jungleHoldButton)
        jungleHoldButton.addTarget(self, action: #selector(jungleHandleButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        
    }
    
    private func jungleStartTimer() {
        jungleTimer = Timer.scheduledTimer(timeInterval: jungleGameTimerInterval, target: self, selector: #selector(jungleUpdateTimer), userInfo: nil, repeats: true)
    }
    
    private func jungleStopTimer() {
        jungleTimer?.invalidate()
    }
    
    @objc private func jungleUpdateTimer() {
        if jungleTimeLeft > 0 {
            jungleTimeLeft -= 1
            jungleLocalScore += 1
            jungleGlobalScore += 1
            jungleTimerLabel.text = "\(jungleTimeLeft)"
            jungleUpdateGlobalScoreLabel()
            
            jungleCheckGameConditions()
            if !jungleIsButtonRed && Bool.random() {
                jungleChangeButtonToRed()
            }
        } else {
            jungleStopTimer()
            jungleGameOver(isWin: true)
        }
    }
    
    private func jungleChangeButtonToRed() {
        jungleIsButtonRed = true
        jungleHoldButton.setImage(UIImage(named: "JungleRed"), for: .normal)
        jungleRedButtonTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(jungleChangeButtonToGreen), userInfo: nil, repeats: false)
    }
    
    @objc private func jungleChangeButtonToGreen() {
        jungleIsButtonRed = false
        jungleHoldButton.setImage(UIImage(named: "JungleGreen"), for: .normal)
        jungleRedButtonTimer?.invalidate()
    }
    
    private func jungleCheckGameConditions() {
        if jungleIsButtonRed && jungleIsHoldingButton {
            jungleGameOver(isWin: false)
        }
        if !jungleIsButtonRed && !jungleIsHoldingButton {
            jungleGameOver(isWin: false)
        }
    }
    
    @objc private func jungleHandleButtonTouchDown() {
        jungleIsHoldingButton = true
        if !jungleGameStarted {
            jungleGameStarted = true
            jungleStartTimer()
        }
        if jungleIsButtonRed {
            jungleGameOver(isWin: false)
        }
    }
    
    @objc private func jungleHandleButtonTouchUp() {
        jungleIsHoldingButton = false
        if !jungleIsButtonRed {
            jungleGameOver(isWin: false)
        }
    }
    
    private func jungleGameOver(isWin: Bool) {
        junglePauseGame()
        jungleGlobalScoreValue = jungleGlobalScore
        let jungleGameOverVC = JungleGameOverViewController()
        jungleGameOverVC.jungleWin = isWin
        jungleGameOverVC.jungleScore = jungleLocalScore
        jungleGameOverVC.jungleOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.jungleOnReturnToMenu?()
        }
        jungleGameOverVC.jungleOnRestart = { [weak self] in
            self?.jungleRestartGame()
        }
        jungleGameOverVC.modalPresentationStyle = .overCurrentContext
        self.present(jungleGameOverVC, animated: false, completion: nil)
    }
    
    @objc private func jungleSettingButtonTapped() {
        junglePauseGame()
        let jungleSettingsVC = JungleSettingViewController()
        jungleSettingsVC.jungleOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.jungleOnReturnToMenu?()
        }
        jungleSettingsVC.jungleResume = { [weak self] in
            self?.jungleResumeGame()
        }
        jungleSettingsVC.modalPresentationStyle = .overCurrentContext
        present(jungleSettingsVC, animated: true, completion: nil)
    }
    
    private func jungleUpdateGlobalScoreLabel() {
        jungleScoreLabel.text = "\(jungleGlobalScore)"
    }
    
    private var jungleGlobalScoreValue: Int {
        get { UserDefaults.standard.integer(forKey: "jungleScore") }
        set { UserDefaults.standard.set(newValue, forKey: "jungleScore") }
    }

    
    func jungleResumeGame() {
        jungleStartTimer()
        jungleIsPaused = false
    }
    
    func junglePauseGame() {
        jungleStopTimer()
        jungleIsPaused = true
    }
    
    func jungleRestartGame() {
        jungleTimeLeft = 30
        jungleLocalScore = 0
        jungleGlobalScore = jungleGlobalScoreValue
        jungleUpdateGlobalScoreLabel()
        jungleIsHoldingButton = false
        jungleIsPaused = false
        jungleGameStarted = false
        jungleTimerLabel.text = "\(jungleTimeLeft)"
    }
}
