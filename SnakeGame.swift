import UIKit
import SnapKit

class SnakeGame: UIViewController {

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
    
    private var jungleGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "jungleScore") }
        set { UserDefaults.standard.set(newValue, forKey: "jungleScore") }
    }

    private var jungleGameTimer: Timer?
    private var jungleCountdownTimer: Timer?
    private var jungleTimeLeft = 30
    private var jungleScore = 0
    private var jungleCurrentImageViews: [UIImageView] = []
    private var jungleImageTimer: Timer?
    
    var jungleImageDisplayTime: TimeInterval = 1.0
    private var isGamePaused = false
    
    var jungleOnReturnToMenu: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        jungleSetupInterfaceLayout()
        jungleStartGame()
    }

    private func jungleSetupInterfaceLayout() {
        view.addSubview(jungleBackdropImageView)
        view.addSubview(jungleSettingButton)
        view.addSubview(jungleScoreBackgroundImageView)
        jungleScoreBackgroundImageView.addSubview(jungleScoreLabel)
        
        jungleBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

    private func jungleStartGame() {
        jungleScoreLabel.text = "\(jungleGlobalScore)"
        jungleStartCountdownTimer()
        jungleStartGameTimer()
        jungleScheduleImageDisplay()
    }

    private func jungleStartCountdownTimer() {
        jungleCountdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(jungleCountdown), userInfo: nil, repeats: true)
    }

    private func jungleStartGameTimer() {
        jungleGameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(jungleUpdateGame), userInfo: nil, repeats: true)
    }

    @objc private func jungleUpdateGame() {
        jungleTimeLeft -= 1
        if jungleTimeLeft <= -1 {
            jungleGameOver(jungleScore: jungleScore, jungleIsWin: true)
        }
    }

    @objc private func jungleCountdown() {
        jungleScoreLabel.text = "\(jungleGlobalScore)"
    }

    private func jungleScheduleImageDisplay() {
        jungleImageTimer?.invalidate()
        
        jungleImageTimer = Timer.scheduledTimer(timeInterval: jungleImageDisplayTime, target: self, selector: #selector(jungleShowImage), userInfo: nil, repeats: true)
    }

    @objc private func jungleShowImage() {
        if isGamePaused { return }

        if jungleCurrentImageViews.count >= 2 {
            jungleGameOver(jungleScore: jungleScore, jungleIsWin: false)
            return
        }

        let imageView = UIImageView()
        imageView.image = UIImage(named: "JungleSnake")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        let width = view.bounds.width * 0.2
        let height = view.bounds.height * 0.2
        let randomX = CGFloat.random(in: 0...view.bounds.width - width)
        let randomY = CGFloat.random(in: view.bounds.height * 0.1...view.bounds.height * 0.9 - height)

        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(randomX)
            make.top.equalToSuperview().offset(randomY)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }

        jungleCurrentImageViews.append(imageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(jungleHandleImageTap(_:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }

    @objc private func jungleHandleImageTap(_ gesture: UITapGestureRecognizer) {
        guard let imageView = gesture.view as? UIImageView else { return }
        snakeSound()
        imageView.removeFromSuperview()
        jungleCurrentImageViews.removeAll { $0 == imageView }

        jungleScore += 1
        jungleGlobalScore += 1
        jungleScoreLabel.text = "\(jungleGlobalScore)"
    }

    private func jungleGameOver(jungleScore: Int, jungleIsWin: Bool) {
        junglePauseGame()
        let jungleOver = JungleGameOverViewController()
        jungleOver.jungleWin = jungleIsWin
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

    private func junglePauseGame() {
        isGamePaused = true
        jungleGameTimer?.invalidate()
        jungleCountdownTimer?.invalidate()
        jungleImageTimer?.invalidate()
    }

    private func jungleResumeGame() {
        isGamePaused = false
        jungleStartGameTimer()
        jungleStartCountdownTimer()
        jungleScheduleImageDisplay()
    }

    private func jungleRestartGame() {
        jungleResumeGame()

        for imageView in jungleCurrentImageViews {
            imageView.removeFromSuperview()
        }
        jungleCurrentImageViews.removeAll()

        jungleScore = 0
        jungleTimeLeft = 30
        jungleScoreLabel.text = "\(jungleGlobalScore)"
        
        jungleGameTimer?.invalidate()
        jungleCountdownTimer?.invalidate()
        jungleImageTimer?.invalidate()

        jungleStartGame()
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
}
