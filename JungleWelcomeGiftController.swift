import UIKit
import SnapKit

class JungleWelcomeGiftController: UIViewController {
    
    private let jungleBackdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainJungle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let jungleGreetingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "JungleWelcomeGiftLabel")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let jungleSnakeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleSnake"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()

    
    private var jungleGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "jungleScore") }
        set { UserDefaults.standard.set(newValue, forKey: "jungleScore") }
    }
    
    private var jungleTapCount = 0
    private let jungleMaxTaps = 15
    private let jungleBonusPoints = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        jungleApplyConstraints()
        jungleSetupActions()
    }
    
    private func jungleApplyConstraints() {
        view.addSubview(jungleBackdropImageView)
        view.addSubview(jungleGreetingImageView)
        view.addSubview(jungleSnakeButton)
        
        jungleBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        jungleGreetingImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        
        jungleSnakeButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(275)
        }
    }
    
    private func jungleSetupActions() {
        jungleSnakeButton.addTarget(self, action: #selector(jungleBonusButtonTapped), for: .touchUpInside)
    }
    
    @objc private func jungleBonusButtonTapped() {
        snakeSound()
        jungleTapCount += 1
        jungleAnimateShakeAndRedden()
        
        if jungleTapCount == jungleMaxTaps {
            jungleGlobalScore += jungleBonusPoints
            jungleShowGiftAlert()
        }
    }
    
    private func jungleAnimateShakeAndRedden() {
        UIView.animate(withDuration: 0.1, animations: {
            self.jungleSnakeButton.transform = CGAffineTransform(translationX: -10, y: 0)
            self.jungleSnakeButton.tintColor = .red
            self.jungleSnakeButton.alpha = 0.8
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.jungleSnakeButton.transform = CGAffineTransform(translationX: 10, y: 0)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.jungleSnakeButton.transform = .identity
                    self.jungleSnakeButton.tintColor = .white
                    self.jungleSnakeButton.alpha = 1.0
                }
            }
        }
    }

    
    private func jungleShowGiftAlert() {
        let alert = UIAlertController(
            title: "Welcome!",
            message: "You have received \(jungleBonusPoints) jungle points!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.jungleMenu()
        })
        
        present(alert, animated: true)
    }
    
    private func jungleMenu() {
        let menuController = JungleMainMenuViewController()
        menuController.modalPresentationStyle = .fullScreen
        present(menuController, animated: true)
    }
}
