import UIKit
import GoogleMobileAds

class StoryViewController: UIViewController, GADRewardBasedVideoAdDelegate, UINavigationControllerDelegate, QuestionDelegate
{
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var storyImage: UIImageView!
    @IBOutlet weak var storyImageLabel: UILabel!
    
    @IBOutlet weak var question0Button: UIButton!
    @IBOutlet weak var question1Button: UIButton!
    @IBOutlet weak var question2Button: UIButton!
    private var questionButtons: [UIButton]!
    
    public var story: Story!
    public var storiesFile: String!
    public var isFreeStory = false
    private var answersState = [Bool](repeating: false, count: 3)
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let language = UserDefaults.standard.string(forKey: "language")
        navigationController?.delegate = self
        questionButtons = [question0Button, question1Button, question2Button]
        storyTitleLabel.text = story.name
        storyLabel.text = story.content
        storyLabel.sizeToFit()
        setupButtons(buttons: questionButtons)
        retrieveAnswers()
        setStoryPictureFor(story: story.name, in: language!)
        
        bannerView.adUnitID = "ca-app-pub-9340983276950968/7881710335"
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // for test
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        let state = retrieveStoryStateFor(story: story.name)
        if GADRewardBasedVideoAd.sharedInstance().isReady && !state && !isFreeStory
        {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        storyImage.addGestureRecognizer(tap)
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
    
    func userDidAnswer(question: Int, result: Bool)
    {
        if result
        {
            questionButtons[question].imageView?.image = UIImage(named: "star_filled")
            self.answersState[question] = true
            
            self.saveAnswers()
        }
    }
    
    @IBAction func questionButtonTapped(_ sender: UIButton)
    {
        performSegue(withIdentifier: "ShowQuestion", sender: sender)
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
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func retrieveAnswers()
    {
        let userDefaults = UserDefaults.standard
        
        if let stories = userDefaults.value(forKey: storiesFile) as? [String: [Bool]]
        {
            if let answers = stories[story.name]
            {
                answersState = answers
                
                for i in 0..<answersState.count
                {
                    if answersState[i]
                    {
                        questionButtons[i].setImage(UIImage(named: "star_filled"), for: .normal)
                    }
                }
            }
        }
    }
    
    func saveAnswers()
    {
        let userDefaults = UserDefaults.standard
        
        if var stories = userDefaults.value(forKey: storiesFile) as? [String: [Bool]]
        {
            stories.updateValue(answersState, forKey: story.name)
            userDefaults.set(stories, forKey: storiesFile)
        }
        else
        {
            var stories = [String: [Bool]]()
            stories.updateValue(answersState, forKey: story.name)
            userDefaults.set(stories, forKey: storiesFile)
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
    
    func setupButtons(buttons: [UIButton])
    {
        for button in buttons
        {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Rewarded video opened.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Rewarded video closed.")
        
        let request = GADRequest()
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-9340983276950968/1835176735")
        //GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313") // for test
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Rewarded video received.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Rewarded video started playing.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Rewarded video left app.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("Rewarded video failed to load.")
        
        let request = GADRequest()
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-9340983276950968/1835176735")
        //GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313") // for test
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Should reward user with \(reward.amount) \(reward.type).")
        
        saveState()
    }
}
