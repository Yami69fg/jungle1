import UIKit
import SnapKit

class JungleSettingViewController: UIViewController {
    
    private let jungleBackgroundBlurImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "JungleBlur")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let jungleControlPanelBackgroundDetails: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Background")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let jungleControlPanelSettingsHeaderLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "JungleSettingLabel")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let jungleSoundTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sound"
        label.font = UIFont(name: "ChangaOne", size: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let jungleVibrationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Vibration"
        label.font = UIFont(name: "ChangaOne", size: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let jungleSoundToggleSwitchButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let jungleVibrationToggleSwitchButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let jungleMainMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleMenu"), for: .normal)
        return button
    }()
    
    private let jungleReturnToGameplayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleBack"), for: .normal)
        return button
    }()
    
    var jungleOnReturnToMenu: (() -> ())?
    var jungleResume: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jungleSetupSubviewsAndConstraints()
        jungleConfigureButtonActions()
        jungleSetupDefaultSettings()
        jungleLoadToggleButtonStates()

    }


    private func jungleSetupSubviewsAndConstraints() {
        view.addSubview(jungleBackgroundBlurImageView)
        view.addSubview(jungleControlPanelBackgroundDetails)
        view.addSubview(jungleControlPanelSettingsHeaderLabel)
        view.addSubview(jungleSoundTitleLabel)
        view.addSubview(jungleSoundToggleSwitchButton)
        view.addSubview(jungleVibrationTitleLabel)
        view.addSubview(jungleVibrationToggleSwitchButton)
        view.addSubview(jungleMainMenuButton)
        view.addSubview(jungleReturnToGameplayButton)
        
        jungleControlPanelBackgroundDetails.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        jungleControlPanelSettingsHeaderLabel.snp.makeConstraints {
            $0.bottom.equalTo(jungleControlPanelBackgroundDetails.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(100)
        }
        
        jungleSoundTitleLabel.snp.makeConstraints {
            $0.left.equalTo(jungleControlPanelBackgroundDetails.snp.left).offset(20)
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        jungleSoundToggleSwitchButton.snp.makeConstraints {
            $0.left.equalTo(jungleSoundTitleLabel.snp.right).offset(20)
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
        
        jungleVibrationTitleLabel.snp.makeConstraints {
            $0.left.equalTo(jungleControlPanelBackgroundDetails.snp.left).offset(30)
            $0.centerY.equalToSuperview().offset(30)
        }
        
        jungleVibrationToggleSwitchButton.snp.makeConstraints {
            $0.left.equalTo(jungleVibrationTitleLabel.snp.right).offset(20)
            $0.centerY.equalToSuperview().offset(30)
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
        
        jungleMainMenuButton.snp.makeConstraints {
            $0.top.equalTo(jungleControlPanelBackgroundDetails.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(50)
            $0.width.equalTo(135)
            $0.height.equalTo(60)
        }
        
        jungleReturnToGameplayButton.snp.makeConstraints {
            $0.top.equalTo(jungleControlPanelBackgroundDetails.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-50)
            $0.width.equalTo(135)
            $0.height.equalTo(60)
        }
    }

    private func jungleSetupDefaultSettings() {
        if UserDefaults.standard.object(forKey: "soundOn") == nil {
            UserDefaults.standard.set(true, forKey: "soundOn")
        }
        if UserDefaults.standard.object(forKey: "vibrationOn") == nil {
            UserDefaults.standard.set(true, forKey: "vibrationOn")
        }
    }

    private func jungleLoadToggleButtonStates() {
        let soundOn = UserDefaults.standard.bool(forKey: "soundOn")
        let vibrationOn = UserDefaults.standard.bool(forKey: "vibrationOn")
        
        jungleSoundToggleSwitchButton.setImage(UIImage(named: soundOn ? "On" : "Off"), for: .normal)
        jungleVibrationToggleSwitchButton.setImage(UIImage(named: vibrationOn ? "On" : "Off"), for: .normal)
    }

    private func jungleConfigureButtonActions() {
        jungleMainMenuButton.addTarget(self, action: #selector(jungleMainMenuTapped), for: .touchUpInside)
        addJungleSound(button: jungleMainMenuButton)
        jungleReturnToGameplayButton.addTarget(self, action: #selector(jungleReturnToGameplayTapped), for: .touchUpInside)
        addJungleSound(button: jungleReturnToGameplayButton)
        jungleSoundToggleSwitchButton.addTarget(self, action: #selector(jungleToggleSound), for: .touchUpInside)
        addJungleSound(button: jungleSoundToggleSwitchButton)
        jungleVibrationToggleSwitchButton.addTarget(self, action: #selector(jungleToggleVibration), for: .touchUpInside)
        addJungleSound(button: jungleVibrationToggleSwitchButton)
    }
    
    @objc private func jungleToggleSound() {
        let soundOn = jungleSoundToggleSwitchButton.currentImage == UIImage(named: "On")
        let newSoundOn = !soundOn
        jungleSoundToggleSwitchButton.setImage(UIImage(named: newSoundOn ? "On" : "Off"), for: .normal)
        UserDefaults.standard.set(newSoundOn, forKey: "soundOn")
    }
    
    @objc private func jungleToggleVibration() {
        let vibrationOn = jungleVibrationToggleSwitchButton.currentImage == UIImage(named: "On")
        let newVibrationOn = !vibrationOn
        jungleVibrationToggleSwitchButton.setImage(UIImage(named: newVibrationOn ? "On" : "Off"), for: .normal)
        UserDefaults.standard.set(newVibrationOn, forKey: "vibrationOn")
    }
    
    @objc private func jungleMainMenuTapped() {
        dismiss(animated: false)
        jungleOnReturnToMenu?()
    }
    
    @objc private func jungleReturnToGameplayTapped() {
        jungleResume?()
        dismiss(animated: true)
    }

}
