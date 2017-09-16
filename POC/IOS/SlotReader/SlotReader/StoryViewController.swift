import UIKit
import GoogleMobileAds
import UnityAds

class StoryViewController: UIViewController, UINavigationControllerDelegate, StoryDelegate, QuestionDelegate, GADRewardBasedVideoAdDelegate, UnityAdsDelegate
{
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var storyImage: UIImageView!
    @IBOutlet weak var storyImageLabel: UILabel!
    @IBOutlet weak var fontSizeStepper: UIStepper!
    @IBOutlet weak var blackBoardImageView: UIImageView!
    
    @IBOutlet weak var question0Button: UIButton!
    @IBOutlet weak var question1Button: UIButton!
    @IBOutlet weak var question2Button: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    private var questionButtons: [UIButton]!

    public var story: Story!
    public var storiesFile: String!
    public var isFreeStory = false
    private var answersCorrectness = [Bool](repeating: false, count: 3)
    private var questionsState = [Bool](repeating: false, count: 3)
    private var isUserSeenAds = false
    private var storyFontSize: CGFloat = 22.0
    private var textColor: UIColor!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let language = UserDefaults.standard.string(forKey: "language")
        let boardColor = UserDefaults.standard.integer(forKey: "colorScheme")
        navigationController?.delegate = self
        questionButtons = [question0Button, question1Button, question2Button]
        
        setupBlackboard(boardColor)
        setupStory(in: language!)
        
        if !nonConsumablePurchaseMade
        {
            setupBannerView()
            setupRewardedVideo()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        bannerView.isHidden = !isParentalGatePassed
        setupStoryFontSize(storyFontSize)
    }
    
    // MARK: - Setup ViewController
    
    func setupStory(in language: String)
    {
        storyFontSize = CGFloat(story.getFontSize())
        storyTitleLabel.text = story.name
        storyLabel.text = story.content
        storyLabel.sizeToFit()
        setupButtons(buttons: questionButtons + [resetButton])
        setStoryPictureFor(story: story.name, in: language)
        fontSizeStepper.value = Double(storyFontSize)
        retrieveAnswers()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        storyImage.addGestureRecognizer(tap)
    }
    
    func setupBlackboard(_ colorScheme: Int)
    {
        var blackBoardImageName: String
        
        switch colorScheme
        {
        case 0:
            blackBoardImageName = "Blackboard"
            textColor = UIColor.white
        case 1:
            blackBoardImageName = "Blackboard-light"
            textColor = UIColor.black
        case 2:
            blackBoardImageName = "Blackboard-dark"
            textColor = UIColor.white
        default:
            blackBoardImageName = "Blackboard-dark"
            textColor = UIColor.white
        }
        
        blackBoardImageView.image = UIImage(named: blackBoardImageName)
        storyTitleLabel.textColor = textColor
        storyLabel.textColor = textColor
        fontSizeStepper.tintColor = textColor
    }
    
    func setupBannerView()
    {
        if isTestModeEnabled
        {
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        }
        else
        {
            bannerView.adUnitID = "ca-app-pub-9340983276950968/7881710335"
        }
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func setupRewardedVideo()
    {
        let state = retrieveStoryStateFor(story: story.name)
        
        if !state && !isFreeStory
        {
            var randomUpperBound: UInt32
            
            if isTestModeEnabled
            {
                randomUpperBound = 1
            }
            else
            {
                randomUpperBound = 2 // to enable unity Ad
            }
            
            let randomNumber = arc4random_uniform(randomUpperBound)
        
            if randomNumber == 0
            {
                GADRewardBasedVideoAd.sharedInstance().delegate = self
            
                if GADRewardBasedVideoAd.sharedInstance().isReady
                {
                    GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
                }
            }
            else
            {
                UnityAds.initialize("1426416", delegate: self)
                let placement = "rewardedVideo"
            
                if (UnityAds.isReady(placement))
                {
                    UnityAds.show(self, placementId: placement)
                }
                else
                {
                    print("UNITY: ads isn't ready")
                }
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
    {
        (viewController as? StoriesViewController)?.isShowPopup = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationVc = segue.destination as? QuestionViewController
        {
            setupQuestionController(destinationVc, sender as! UIButton)
        }
        else if let destinationVc = segue.destination as? ParentalGateViewController
        {
            destinationVc.resetAnswers = true
            destinationVc.storiesFile = storiesFile
            destinationVc.storyName = story.name
            destinationVc.delegate = self
        }
    }
    
    func setupQuestionController(_ questionVc: QuestionViewController, _ sender: UIButton)
    {
        var questionNumber: Int
        
        switch sender.accessibilityIdentifier! {
        case "question0": questionNumber = 0
        case "question1": questionNumber = 1
        case "question2": questionNumber = 2
        default: questionNumber = -1
        }

        let question = story.questions[questionNumber]
        questionVc.question = question
        questionVc.questionNumber = questionNumber
        questionVc.delegate = self
    }
    
    func setupButtons(buttons: [UIButton])
    {
        for buttonIndex in 0..<buttons.count
        {
            buttons[buttonIndex].layer.cornerRadius = 5
            buttons[buttonIndex].layer.borderWidth = 1
            buttons[buttonIndex].layer.borderColor = textColor.cgColor
        }
    }
    
    func setupStoryFontSize(_ size: CGFloat)
    {
        storyTitleLabel.font = storyTitleLabel.font.withSize(storyFontSize)
        storyLabel.font = storyLabel.font.withSize(storyFontSize)
    }
    
    // MARK: - Actions
    
    @IBAction func questionButtonTapped(_ sender: UIButton)
    {
        if !questionsState[Int((sender.accessibilityIdentifier?.replacingOccurrences(of: "question", with: ""))!)!]
        {
            performSegue(withIdentifier: "ShowQuestion", sender: sender)
        }
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer)
    {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton)
    {
        performSegue(withIdentifier: "ParentalGateForReset", sender: self)
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func retrieveAnswers()
    {
        let retrievedAnswersCorrectness = story.retrieveAnswersCorrectness(for: storiesFile)
        let retrievedQuestionsState = story.retrieveQuestionsState(for: storiesFile)
        
        if retrievedQuestionsState.count > 0
        {
            answersCorrectness = retrievedAnswersCorrectness
            questionsState = retrievedQuestionsState
            
            for i in 0..<answersCorrectness.count
            {
                if questionsState[i]
                {
                    questionButtons[i].layer.borderWidth = 0
                    
                    if answersCorrectness[i]
                    {
                        questionButtons[i].setImage(UIImage(named: "star_filled"), for: .normal)
                    }
                    else
                    {
                        questionButtons[i].setImage(UIImage(named: "cross"), for: .normal)
                    }
                }
                else
                {
                    questionButtons[i].setImage(UIImage(named: "star"), for: .normal)
                }
            }
        }
        else
        {
            for i in 0..<questionButtons.count
            {
                questionButtons[i].setImage(UIImage(named: "star"), for: .normal)
            }
        }
    }
    
    @IBAction func fontSizeChanged(_ sender: UIStepper)
    {
        story.saveFontSize(Int(sender.value))
        
        storyFontSize = CGFloat(sender.value)
        setupStoryFontSize(storyFontSize)
    }
    
    // MARK: - Story Logic
    
    func userDidAnswer(question: Int, result: Bool)
    {
        if result
        {
            questionButtons[question].setImage(UIImage(named: "star_filled"), for: .normal)
        }
        else
        {
            questionButtons[question].setImage(UIImage(named: "cross"), for: .normal)
        }
        
        questionButtons[question].layer.borderWidth = 0
        self.answersCorrectness[question] = result
        self.questionsState[question] = true
        
        story.saveAnswers(for: storiesFile, questionsState, answersCorrectness)
    }
    
    func userDidResetStory()
    {
        bannerView.isHidden = !isParentalGatePassed
        
        questionsState = [Bool](repeating: false, count: 3)
        answersCorrectness = [Bool](repeating: false, count: 3)
        
        for i in 0..<questionButtons.count
        {
            questionButtons[i].setImage(UIImage(named: "star"), for: .normal)
            questionButtons[i].layer.borderWidth = 1
        }
    }
    
    func retrieveStoryStateFor(story name: String) -> Bool
    {
        var storyState = false
        let userDefaults = UserDefaults.standard
        
        if let stories = userDefaults.value(forKey: storiesFile + "_states") as? [String: Bool]
        {
            if let state = stories[name]
            {
                storyState = state
            }
        }
        
        return storyState
    }
    
    func saveState()
    {
        let userDefaults = UserDefaults.standard
        
        if var stories = userDefaults.value(forKey: storiesFile + "_states") as? [String: Bool]
        {
            stories.updateValue(true, forKey: story.name)
            userDefaults.set(stories, forKey: storiesFile + "_states")
        }
        else
        {
            var stories = [String: Bool]()
            stories.updateValue(true, forKey: story.name)
            userDefaults.set(stories, forKey: storiesFile + "_states")
        }
    }
    
    func setStoryPictureFor(story name: String, in language: String)
    {
        let image = UIImage(named: story.name + "_" + language)
        let strings = TipsModel(lang: language)
        
        if image == nil
        {
            storyImage.image = UIImage(named: "ImagePlaceholder")
            storyImageLabel.isHidden = false
            storyImageLabel.text = strings.getString(strings.yourImageHereId)
        }
        else
        {
            storyImage.image = image
            storyImageLabel.isHidden = true
        }
    }
    
    // MARK: - Google Ads Delegate
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd)
    {
        print("Rewarded video opened.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd)
    {
        print("Rewarded video closed.")
        
        isUserSeenAds = true
        let request = GADRequest()
        
        if isTestModeEnabled
        {
            GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        }
        else
        {
            GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-9340983276950968/1835176735")
        }
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd)
    {
        print("Rewarded video received.")
        
        if !isUserSeenAds
        {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd)
    {
        print("Rewarded video started playing.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd)
    {
        print("Rewarded video left app.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error)
    {
        print("Rewarded video failed to load.")
        
        let request = GADRequest()
        
        if isTestModeEnabled
        {
            GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        }
        else
        {
            GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-9340983276950968/1835176735")
        }
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward)
    {
        print("Should reward user with \(reward.amount) \(reward.type).")
        
        saveState()
    }
    
    // MARK: - Unity Ads Delegate
    
    func unityAdsReady(_ placementId: String)
    {
        print("UNITY: ads is ready")
        
        if !isUserSeenAds
        {
            UnityAds.show(self, placementId: placementId)
        }
    }
    
    func unityAdsDidStart(_ placementId: String)
    {
        print("UNITY: ads started")
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String)
    {
        print("UNITY: ads failed to start")
    }
    
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState)
    {
        isUserSeenAds = true
        
        if state != .skipped
        {
            saveState()
        }
    }
}
