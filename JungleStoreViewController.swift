import UIKit
import SnapKit

class JungleStoreViewController: UIViewController {

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
    
    private let jungleBuyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleBuy"), for: .normal)
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
    
    private let junglePreviewImageNames = ["JungleButton1", "JungleButton2", "JungleButton3"]
    private let jungleBackgroundImageNames = ["Jungle1", "Jungle2", "Jungle3"]
    private var jungleCurrentImageIndex = 0

    private var jungleSelectedImageName: String {
        get {
            return UserDefaults.standard.string(forKey: "jungleSelectedImageName") ?? "Jungle"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "jungleSelectedImageName")
        }
    }
    
    private var jungleGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "jungleScore") }
        set { UserDefaults.standard.set(newValue, forKey: "jungleScore") }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        jungleScoreLabel.text = "\(jungleGlobalScore)"
        jungleConfigureUI()
        jungleUpdateCenterImage()
        jungleSetupActions()
    }

    private func jungleConfigureUI() {
        view.addSubview(jungleBackdropImageView)
        view.addSubview(jungleCenterImageView)
        view.addSubview(jungleScoreBackgroundImageView)
        jungleScoreBackgroundImageView.addSubview(jungleScoreLabel)
        view.addSubview(jungleCloseButton)
        view.addSubview(jungleLeftButton)
        view.addSubview(jungleRightButton)
        view.addSubview(jungleBuyButton)
        
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

        jungleBuyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(jungleCenterImageView.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func jungleUpdateCenterImage() {
        jungleCenterImageView.image = UIImage(named: junglePreviewImageNames[jungleCurrentImageIndex])?.withRenderingMode(.alwaysOriginal)
    }

    private func jungleSetupActions() {
        jungleLeftButton.addTarget(self, action: #selector(jungleLeftButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleLeftButton)
        jungleRightButton.addTarget(self, action: #selector(jungleRightButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleRightButton)
        jungleCloseButton.addTarget(self, action: #selector(jungleCloseButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleCloseButton)
        jungleBuyButton.addTarget(self, action: #selector(jungleBuyButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleBuyButton)
    }
    
    @objc private func jungleLeftButtonTapped() {
        if jungleCurrentImageIndex > 0 {
            jungleCurrentImageIndex -= 1
            jungleUpdateCenterImage()
        }
    }
    
    @objc private func jungleRightButtonTapped() {
        if jungleCurrentImageIndex < junglePreviewImageNames.count - 1 {
            jungleCurrentImageIndex += 1
            jungleUpdateCenterImage()
        }
    }
    
    @objc private func jungleCloseButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func jungleBuyButtonTapped() {
        let jungleCost = jungleGetCostForCurrentImage()
        let junglePurchasedImageName = jungleBackgroundImageNames[jungleCurrentImageIndex]
        if UserDefaults.standard.bool(forKey: "\(junglePurchasedImageName)p") {
            jungleSetSelectedBackgroundImage(junglePurchasedImageName)
            jungleShowAlert(message: "This image is already purchased and set as the background!")
            return
        }
        
        if jungleGlobalScore < jungleCost {
            let jungleMissingPoints = jungleCost - jungleGlobalScore
            jungleShowAlert(message: "You need \(jungleMissingPoints) more points to buy this image.")
            return
        }
        
        let jungleMessage = "Do you want to buy this image for \(jungleCost) points?"
        let jungleAlertController = UIAlertController(title: "Confirm Purchase", message: jungleMessage, preferredStyle: .alert)
        
        jungleAlertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.jungleGlobalScore -= jungleCost
            UserDefaults.standard.set(true, forKey: "\(junglePurchasedImageName)p")
            self.jungleSetSelectedBackgroundImage(junglePurchasedImageName)
            self.jungleShowAlert(message: "Image purchased and set as the background!")
        }))
        
        jungleAlertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(jungleAlertController, animated: true, completion: nil)
    }

    private func jungleSetSelectedBackgroundImage(_ purchasedImageName: String) {
        jungleSelectedImageName = purchasedImageName
        jungleScoreLabel.text = "\(jungleGlobalScore)"
    }

    private func jungleGetCostForCurrentImage() -> Int {
        switch jungleCurrentImageIndex {
        case 0: return 250
        case 1: return 500
        case 2: return 750
        default: return 0
        }
    }

    private func jungleShowAlert(message: String) {
        let jungleAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        jungleAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(jungleAlert, animated: true)
    }
}

