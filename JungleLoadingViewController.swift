import UIKit
import SnapKit

class JungleLoadingViewController: UIViewController {

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
    
    private let jungleLoadingImageView: UIImageView = {
        let jungleImageView = UIImageView()
        jungleImageView.image = UIImage(named: "JungleLoading1")
        jungleImageView.contentMode = .scaleAspectFill
        return jungleImageView
    }()
    
    private var jungleLoadingTimer: Timer?
    private var jungleRotationTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupJungleUI()
        startJungleSnakeRotation()
        startJungleLoadingAnimation()
        navigateToJungleNextController()
    }
    
    private func setupJungleUI() {
        view.addSubview(jungleBackgroundView)
        view.addSubview(jungleSnakeImageView)
        view.addSubview(jungleLoadingImageView)
        
        jungleBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        jungleSnakeImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.height.equalTo(150)
        }
        
        jungleLoadingImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(jungleSnakeImageView.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func startJungleSnakeRotation() {
        jungleRotationTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.jungleSnakeImageView.transform = self.jungleSnakeImageView.transform.rotated(by: .pi / 180)
        }
    }
    
    private func startJungleLoadingAnimation() {
        var jungleImageIndex = 1
        jungleLoadingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            jungleImageIndex = (jungleImageIndex % 3) + 1
            self.jungleLoadingImageView.image = UIImage(named: "JungleLoading\(jungleImageIndex)")
        }
    }
    
    private func navigateToJungleNextController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            let jungleLaunched = UserDefaults.standard.bool(forKey: "jungle")
            if !jungleLaunched {
                UserDefaults.standard.set(true, forKey: "jungle")
                UserDefaults.standard.synchronize()
                let jungleNextViewController = JungleWelcomeGiftController()
                jungleNextViewController.modalTransitionStyle = .crossDissolve
                jungleNextViewController.modalPresentationStyle = .fullScreen
                self.present(jungleNextViewController, animated: true, completion: nil)
            } else
            {
                let jungleNextViewController = JungleMainMenuViewController()
                jungleNextViewController.modalTransitionStyle = .crossDissolve
                jungleNextViewController.modalPresentationStyle = .fullScreen
                self.present(jungleNextViewController, animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        jungleLoadingTimer?.invalidate()
        jungleRotationTimer?.invalidate()
    }
}
