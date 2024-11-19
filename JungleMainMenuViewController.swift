import UIKit
import SnapKit

class JungleMainMenuViewController: UIViewController {

    private let jungleBackgroundView: UIImageView = {
        let jungleImageView = UIImageView()
        jungleImageView.image = UIImage(named: "MainJungle")
        jungleImageView.contentMode = .scaleAspectFill
        return jungleImageView
    }()
    
    private let jungleSnakeImageView: UIImageView = {
        let jungleImageView = UIImageView()
        jungleImageView.image = UIImage(named: "JungleSnake")
        jungleImageView.contentMode = .scaleAspectFit
        return jungleImageView
    }()
    
    private let jungleStartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleStart"), for: .normal)
        return button
    }()
    
    private let jungleStoreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleStore"), for: .normal)
        return button
    }()
    
    private let jungleAchievementsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleAchieve"), for: .normal)
        return button
    }()
    
    private let jungleTimerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleScore"), for: .normal)
        return button
    }()
    
    private let jungleTimerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChangaOne", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private var jungleGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "jungleScore") }
        set { UserDefaults.standard.set(newValue, forKey: "jungleScore") }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jungleConfigureUI()
        jungleSetupActions()
        jungleLoadSavedTimerState()
        jungleStartTimer()
        jungleConfigureTimerLabel()
        jungleTimerButton.isEnabled = false
    }
    
    private func jungleConfigureUI() {
        view.addSubview(jungleBackgroundView)
        view.addSubview(jungleTimerButton)
        view.addSubview(jungleSnakeImageView)
        view.addSubview(jungleStartButton)
        view.addSubview(jungleAchievementsButton)
        view.addSubview(jungleStoreButton)
        jungleBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        jungleTimerButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(75)
            make.centerX.equalToSuperview()
            make.width.equalTo(175)
            make.height.equalTo(50)
        }

        jungleSnakeImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(jungleTimerButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        jungleStartButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(jungleSnakeImageView.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }

        jungleAchievementsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(jungleStartButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        jungleStoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(jungleAchievementsButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
    }
    
    private func jungleSetupActions() {
        jungleStartButton.addTarget(self, action: #selector(jungleTapStartButton), for: .touchUpInside)
        addJungleSound(button: jungleStartButton)
        jungleStoreButton.addTarget(self, action: #selector(jungleTapStoreButton), for: .touchUpInside)
        addJungleSound(button: jungleStoreButton)
        jungleAchievementsButton.addTarget(self, action: #selector(jungleTapAchieveButton), for: .touchUpInside)
        addJungleSound(button: jungleAchievementsButton)
        jungleTimerButton.addTarget(self, action: #selector(jungleRewardButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleTimerButton)
    }
    
    private let jungleKey: String = "jungleTimer"
    private let jungleTimerDuration: TimeInterval = 5400
    private var jungleTimer: Timer?
    private var jungleRemainingTime: TimeInterval = 5400
    
    @objc private func jungleTapStartButton() {
        let jungleGames = JungleMainGamesViewController()
        jungleGames.modalTransitionStyle = .crossDissolve
        jungleGames.modalPresentationStyle = .fullScreen
        present(jungleGames, animated: true, completion: nil)
    }
    
    @objc private func jungleTapStoreButton() {
        let jungleGames = JungleStoreViewController()
        jungleGames.modalTransitionStyle = .crossDissolve
        jungleGames.modalPresentationStyle = .fullScreen
        present(jungleGames, animated: true, completion: nil)
    }
    
    @objc private func jungleTapAchieveButton() {
        let jungleGames = JungleAchieveViewController()
        jungleGames.modalTransitionStyle = .crossDissolve
        jungleGames.modalPresentationStyle = .fullScreen
        present(jungleGames, animated: true, completion: nil)
    }
    
    private func jungleStartTimer() {
        jungleTimer?.invalidate()
        jungleTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(jungleUpdateTimer), userInfo: nil, repeats: true)
    }

    @objc private func jungleUpdateTimer() {
        if jungleRemainingTime > 0 {
            jungleRemainingTime -= 1
            jungleTimerLabel.text = jungleFormatTime(jungleRemainingTime)
            jungleSaveTimerState()
        } else {
            jungleTimer?.invalidate()
            jungleTimerLabel.text = "00:00:00"
            jungleUnlockRewardButton()
        }
    }

    private func jungleFormatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func jungleUnlockRewardButton() {
        jungleTimerButton.isEnabled = true
    }

    private func jungleLoadSavedTimerState() {
        let timerStartTime = UserDefaults.standard.double(forKey: jungleKey)
        if timerStartTime == 0 {
            jungleRemainingTime = jungleTimerDuration
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: jungleKey)
        } else {
            let elapsedTime = Date().timeIntervalSince1970 - timerStartTime
            jungleRemainingTime = max(0, jungleTimerDuration - elapsedTime)
        }
        jungleTimerLabel.text = jungleFormatTime(jungleRemainingTime)
    }

    private func jungleSaveTimerState() {
        UserDefaults.standard.set(jungleRemainingTime, forKey: "remainingTime")
    }

    @objc private func jungleRewardButtonTapped() {
        jungleRemainingTime = jungleTimerDuration
        jungleGlobalScore += 50
        jungleTimerLabel.text = jungleFormatTime(jungleRemainingTime)
        jungleTimerButton.isEnabled = false
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: jungleKey)
        jungleStartTimer()
    }
    
    private func jungleConfigureTimerLabel() {
        jungleTimerLabel.text = jungleFormatTime(jungleRemainingTime)
        jungleTimerButton.addSubview(jungleTimerLabel)
        jungleTimerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
