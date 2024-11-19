import UIKit
import SnapKit

class JungleGameOverViewController: UIViewController {
    
    private let jungleBackgroundBlurImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "JungleBlur")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private let jungleBackgroundDetailsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Background")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let jungleSettingsHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "JungleWinLabel")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let jungleScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Score"
        label.font = UIFont(name: "ChangaOne", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let jungleTotalScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Total score"
        label.font = UIFont(name: "ChangaOne", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let jungleMainMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleMenu"), for: .normal)
        return button
    }()
    
    private let jungleRetryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleRestart"), for: .normal)
        return button
    }()
    
    var jungleOnReturnToMenu: (() -> ())?
    var jungleOnRestart: (() -> ())?
    
    var jungleWin = false
    var jungleScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endSound()
        configureJungleInterface()
        updateJungleContent()
    }
    
    private func configureJungleInterface() {
        setupJungleConstraints()
        setupJungleActions()
    }
    
    private func setupJungleConstraints() {
        view.addSubview(jungleBackgroundBlurImageView)
        view.addSubview(jungleBackgroundDetailsImageView)
        view.addSubview(jungleSettingsHeaderImageView)
        view.addSubview(jungleScoreTitleLabel)
        view.addSubview(jungleTotalScoreTitleLabel)
        view.addSubview(jungleMainMenuButton)
        view.addSubview(jungleRetryButton)
        
        jungleBackgroundBlurImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        jungleBackgroundDetailsImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.25)
        }

        jungleSettingsHeaderImageView.snp.makeConstraints { make in
            make.bottom.equalTo(jungleBackgroundDetailsImageView.snp.top).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
        }

        jungleScoreTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(jungleBackgroundDetailsImageView.snp.left).offset(20)
            make.centerY.equalToSuperview().offset(-30)
        }

        jungleTotalScoreTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(jungleBackgroundDetailsImageView.snp.left).offset(20)
            make.centerY.equalToSuperview().offset(30)
        }

        jungleMainMenuButton.snp.makeConstraints { make in
            make.top.equalTo(jungleBackgroundDetailsImageView.snp.bottom).offset(10)
            make.left.equalTo(jungleBackgroundDetailsImageView.snp.left)
            make.width.equalTo(135)
            make.height.equalTo(60)
        }

        jungleRetryButton.snp.makeConstraints { make in
            make.top.equalTo(jungleBackgroundDetailsImageView.snp.bottom).offset(10)
            make.right.equalTo(jungleBackgroundDetailsImageView.snp.right)
            make.width.equalTo(135)
            make.height.equalTo(60)
        }
    }
    
    private func setupJungleActions() {
        jungleMainMenuButton.addTarget(self, action: #selector(jungleNavigateToMainMenu), for: .touchUpInside)
        addJungleSound(button: jungleMainMenuButton)
        jungleRetryButton.addTarget(self, action: #selector(jungleRestartGameSession), for: .touchUpInside)
        addJungleSound(button: jungleRetryButton)
    }
    
    private func updateJungleContent() {
        if jungleWin {
            jungleSettingsHeaderImageView.image = UIImage(named: "JungleWinLabel")
        } else {
            jungleSettingsHeaderImageView.image = UIImage(named: "JungleLoseLabel")
        }
        
        jungleScoreTitleLabel.text = "Score \(jungleScore)"
        jungleTotalScoreTitleLabel.text = "Total score \(UserDefaults.standard.integer(forKey: "jungleScore"))"
    }
    
    @objc private func jungleNavigateToMainMenu() {
        dismiss(animated: false)
        jungleOnReturnToMenu?()
    }
    
    @objc private func jungleRestartGameSession() {
        dismiss(animated: true)
        jungleOnRestart?()
    }
    
}
