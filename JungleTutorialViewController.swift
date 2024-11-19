import UIKit
import SnapKit

class JungleTutorialViewController: UIViewController {
    
    private let jungleBackdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainJungle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let jungleCloseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleCloseButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private let jungleDopImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Background")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let jungleInstructionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "JungleTutorialLabel")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let jungleInstructionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChangaOne", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.49
        return label
    }()
    
    var jungleGame = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureJungleInterface()
        setupJungleInstructionText()
    }
    
    private func configureJungleInterface() {
        view.addSubview(jungleBackdropImageView)
        view.addSubview(jungleDopImageView)
        view.addSubview(jungleCloseButton)
        jungleDopImageView.addSubview(jungleInstructionLabel)
        view.addSubview(jungleInstructionImageView)
        
        jungleBackdropImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        jungleDopImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(jungleDopImageView.snp.width).multipliedBy(1.3)
        }
        
        jungleCloseButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalToSuperview().inset(10)
            $0.size.equalTo(45)
        }
        
        jungleInstructionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.77)
            $0.height.equalTo(jungleDopImageView.snp.width).multipliedBy(1.2)
        }
        
        jungleInstructionImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(jungleDopImageView.snp.top)
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
        
        jungleCloseButton.addTarget(self, action: #selector(jungleCloseTapped), for: .touchUpInside)
        addJungleSound(button: jungleCloseButton)
    }
    
    private func setupJungleInstructionText() {
        switch jungleGame {
        case 0:
            jungleInstructionLabel.text = "You are given 30 seconds, and your task is to avoid being bitten by the snake. The snake will bite if you don't hit it; simply clicking on the snake will make it go away. Depending on the difficulty, the snakes will appear faster. If you survive, you win."
        case 1:
            jungleInstructionLabel.text = "You need to keep your finger on the button when it is green. If it turns red, you need to remove your finger from the button. If it turns yellow, you don't need to do anything. Hold on like this for 30 seconds. Depending on the difficulty, the button will change more frequently."
        default:
            jungleInstructionLabel.text = "You are given the same keyboard with 10 characters. On the easy level, you need to form 5 words, each 3 letters long; on the medium level, 4-letter words; and on the hard level, 5-letter words. Not all words may be in the dictionary, so you’ll need to try and enter the correct word."
        }
    }
    
    @objc private func jungleCloseTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
