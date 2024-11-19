import UIKit
import SnapKit

class JungleLevelsViewController: UIViewController {

    private let jungleBackdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainJungle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let jungleEasyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleEasy"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let jungleMediumButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleMedium"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let jungleHardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleHard"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 10
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
    
    private let jungleTutorButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "JungleTutorialButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 14
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
    
    var jungleGame = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        jungleScoreLabel.text = "\(jungleGlobalScore)"
        jungleConfigureUI()
        jungleSetupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        jungleScoreLabel.text = "\(jungleGlobalScore)"
    }

    private func jungleConfigureUI() {
        view.addSubview(jungleBackdropImageView)
        view.addSubview(jungleMediumButton)
        view.addSubview(jungleEasyButton)
        view.addSubview(jungleHardButton)
        view.addSubview(jungleScoreBackgroundImageView)
        jungleScoreBackgroundImageView.addSubview(jungleScoreLabel)
        view.addSubview(jungleCloseButton)
        view.addSubview(jungleTutorButton)
        
        jungleBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        jungleMediumButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
        }

        jungleHardButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(jungleMediumButton.snp.bottom).offset(50)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }

        jungleEasyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(jungleMediumButton.snp.top).offset(-50)
            make.width.equalTo(200)
            make.height.equalTo(60)
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

        jungleTutorButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.right.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
        }
    }

    private func jungleSetupActions() {
        jungleEasyButton.addTarget(self, action: #selector(jungleTapEasyButton), for: .touchUpInside)
        addJungleSound(button: jungleEasyButton)
        jungleMediumButton.addTarget(self, action: #selector(jungleTapMediumButton), for: .touchUpInside)
        addJungleSound(button: jungleMediumButton)
        jungleHardButton.addTarget(self, action: #selector(jungleTapHardButton), for: .touchUpInside)
        addJungleSound(button: jungleHardButton)
        jungleCloseButton.addTarget(self, action: #selector(jungleCloseButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleCloseButton)
        jungleTutorButton.addTarget(self, action: #selector(jungleTutorButtonTapped), for: .touchUpInside)
        addJungleSound(button: jungleTutorButton)
    }
    
    @objc private func jungleTapEasyButton() {
        if jungleGame == 0 {
            let snakeGame = SnakeGame()
            snakeGame.jungleImageDisplayTime = 1
            snakeGame.modalTransitionStyle = .crossDissolve
            snakeGame.modalPresentationStyle = .fullScreen
            present(snakeGame, animated: true, completion: nil)
        } else if jungleGame == 1 {
            let reflexGame = ReflexGame()
            reflexGame.jungleGameTimerInterval = 1
            reflexGame.modalTransitionStyle = .crossDissolve
            reflexGame.modalPresentationStyle = .fullScreen
            present(reflexGame, animated: true, completion: nil)
        } else if jungleGame == 2 {
            let jungleWord = JungleWord()
            jungleWord.jungleDesiredWordLength = 3
            jungleWord.modalTransitionStyle = .crossDissolve
            jungleWord.modalPresentationStyle = .fullScreen
            present(jungleWord, animated: true, completion: nil)
        }
    }
    
    @objc private func jungleTapMediumButton() {
        if jungleGame == 0 {
            let snakeGame = SnakeGame()
            snakeGame.jungleImageDisplayTime = 0.75
            snakeGame.modalTransitionStyle = .crossDissolve
            snakeGame.modalPresentationStyle = .fullScreen
            present(snakeGame, animated: true, completion: nil)
        } else if jungleGame == 1 {
            let reflexGame = ReflexGame()
            reflexGame.jungleGameTimerInterval = 0.8
            reflexGame.modalTransitionStyle = .crossDissolve
            reflexGame.modalPresentationStyle = .fullScreen
            present(reflexGame, animated: true, completion: nil)
        } else if jungleGame == 2 {
            let jungleWord = JungleWord()
            jungleWord.jungleDesiredWordLength = 4
            jungleWord.modalTransitionStyle = .crossDissolve
            jungleWord.modalPresentationStyle = .fullScreen
            present(jungleWord, animated: true, completion: nil)
        }
    }
    
    @objc private func jungleTapHardButton() {
        if jungleGame == 0 {
            let snakeGame = SnakeGame()
            snakeGame.jungleImageDisplayTime = 0.5
            snakeGame.modalTransitionStyle = .crossDissolve
            snakeGame.modalPresentationStyle = .fullScreen
            present(snakeGame, animated: true, completion: nil)
        } else if jungleGame == 1 {
            let reflexGame = ReflexGame()
            reflexGame.jungleGameTimerInterval = 0.4
            reflexGame.modalTransitionStyle = .crossDissolve
            reflexGame.modalPresentationStyle = .fullScreen
            present(reflexGame, animated: true, completion: nil)
        } else if jungleGame == 2 {
            let jungleWord = JungleWord()
            jungleWord.jungleDesiredWordLength = 5
            jungleWord.modalTransitionStyle = .crossDissolve
            jungleWord.modalPresentationStyle = .fullScreen
            present(jungleWord, animated: true, completion: nil)
        }
    }
    
    @objc private func jungleCloseButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func jungleTutorButtonTapped() {
        let jungleTutor = JungleTutorialViewController()
        jungleTutor.jungleGame = jungleGame
        jungleTutor.modalTransitionStyle = .crossDissolve
        jungleTutor.modalPresentationStyle = .fullScreen
        present(jungleTutor, animated: true, completion: nil)
    }
}
