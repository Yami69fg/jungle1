import UIKit
import SnapKit

class JungleAchieveViewController: UIViewController {
    
    private let jungleBackdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainJungle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let jungleCenterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let jungleLeftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleBackButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    private let jungleRightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleNextButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    private let jungleCloseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleCloseButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        return button
    }()
    
    private let jungleCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleCheck"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 10
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
    
    private let jungleImageNames = ["JungleAchieveButton1", "JungleAchieveButton2", "JungleAchieveButton3"]
    private var jungleCurrentImageIndex = 0
    
    private var jungleGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "jungleScore") }
        set { UserDefaults.standard.set(newValue, forKey: "jungleScore") }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        jungleScoreLabel.text = "\(jungleGlobalScore)"
        configureJungleUI()
        updateJungleCenterImage()
        setupJungleActions()
        updateJungleAchievementStatus()
    }

    private func configureJungleUI() {
        view.addSubview(jungleBackdropImageView)
        view.addSubview(jungleCenterImageView)
        view.addSubview(jungleScoreBackgroundImageView)
        jungleScoreBackgroundImageView.addSubview(jungleScoreLabel)
        view.addSubview(jungleCloseButton)
        view.addSubview(jungleLeftButton)
        view.addSubview(jungleRightButton)
        view.addSubview(jungleCheckButton)
        
        jungleBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        jungleCenterImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(jungleCenterImageView.snp.width)
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
        
        jungleCloseButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
        }
        

        jungleLeftButton.snp.makeConstraints { make in
            make.centerY.equalTo(jungleCenterImageView)
            make.right.equalTo(jungleCenterImageView.snp.left).offset(-20)
            make.width.height.equalTo(55)
        }
        

        jungleRightButton.snp.makeConstraints { make in
            make.centerY.equalTo(jungleCenterImageView)
            make.left.equalTo(jungleCenterImageView.snp.right).offset(20)
            make.width.height.equalTo(55)
        }

        jungleCheckButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(jungleCenterImageView.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func updateJungleCenterImage() {
        jungleCenterImageView.image = UIImage(named: jungleImageNames[jungleCurrentImageIndex])
        updateJungleAchievementStatus()
    }
    
    private func updateJungleAchievementStatus() {
        let isConditionMet = checkJungleConditionForCurrentImage()
        
        jungleCenterImageView.alpha = isConditionMet ? 1.0 : 0.5
    }
    
    private func setupJungleActions() {
        jungleLeftButton.addTarget(self, action: #selector(jungleLeftButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleLeftButton)
        jungleRightButton.addTarget(self, action: #selector(jungleRightButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleRightButton)
        jungleCloseButton.addTarget(self, action: #selector(jungleCloseButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleCloseButton)
        jungleCheckButton.addTarget(self, action: #selector(jungleCheckButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleCheckButton)
    }
    
    @objc private func jungleLeftButtonTapped() {
        if jungleCurrentImageIndex > 0 {
            jungleCurrentImageIndex -= 1
            updateJungleCenterImage()
        }
    }
    
    @objc private func jungleRightButtonTapped() {
        if jungleCurrentImageIndex < jungleImageNames.count - 1 {
            jungleCurrentImageIndex += 1
            updateJungleCenterImage()
        }
    }
    
    @objc private func jungleCloseButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func jungleCheckButtonTapped() {
        let message = jungleAchievementMessageForCurrentImage()
        let alertController = UIAlertController(title: "Jungle Achievement Status", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func checkJungleConditionForCurrentImage() -> Bool {
        switch jungleCurrentImageIndex {
        case 0:
            return true
        case 1:
            return UserDefaults.standard.bool(forKey: "Jungle1p") || UserDefaults.standard.bool(forKey: "Jungle2p") || UserDefaults.standard.bool(forKey: "Jungle3p")
        case 2:
            return jungleGlobalScore >= 1000
        default:
            return false
        }
    }

    private func jungleAchievementMessageForCurrentImage() -> String {
        switch jungleCurrentImageIndex {
        case 0:
            return "Achievement completed! You first opening the app!"
        case 1:
            return UserDefaults.standard.bool(forKey: "Jungle1p") || UserDefaults.standard.bool(forKey: "Jungle2p") || UserDefaults.standard.bool(forKey: "Jungle3p") ? "Achievement completed! First purchased!" : "Achievement not completed. Buy background!"
        case 2:
            return jungleGlobalScore >= 1000 ? "Achievement completed! 1000 jungle points collected!" : "Achievement not completed. Collect 1000 jungle points!"
        default:
            return ""
        }
    }
}
