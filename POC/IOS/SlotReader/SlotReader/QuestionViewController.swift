import UIKit
import GoogleMobileAds

protocol QuestionDelegate
{
    func userDidAnswer(question: Int, result: Bool)
}

class QuestionViewController: UIViewController, UIGestureRecognizerDelegate
{
    // MARK: - Properties
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var questionContainer: UIView!
    @IBOutlet weak var questionView: UIView!
    
    var questionNumber: Int!
    var question: StoryQuestion!
    var delegate: QuestionDelegate?
    var isAnswerCorrect = false
    
    lazy var questionInteractionViewController: QuestionInteractionViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "QuestionInteractionViewController") as! QuestionInteractionViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    lazy var questionResultViewController: QuestionResultViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "QuestionResultViewController") as! QuestionResultViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    // MARK: - Default Members
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateContainerView(false)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideOfBoard(sender:)))
        tap.delegate = self
        questionView.addGestureRecognizer(tap)
        
        if !nonConsumablePurchaseMade
        {
            setupBannerAds()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        bannerView.isHidden = !isParentalGatePassed
    }
    
    // MARK: - Actions
    
    func handleTapOutsideOfBoard(sender: UITapGestureRecognizer? = nil)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    public func updateContainerView(_ isResultProvided: Bool)
    {
        questionInteractionViewController.view.isHidden = isResultProvided
        questionResultViewController.view.isHidden = !isResultProvided
        
        if (isResultProvided)
        {
            questionResultViewController.setupResultView(isAnswerCorrect)
            questionResultViewController.playSound(isAnswerCorrect: isAnswerCorrect)
        }
        else
        {
            questionInteractionViewController.questionLabel.text = question.question
            setupAnswerButtons(viewController: questionInteractionViewController)
        }
    }
    
    private func addViewControllerAsChildViewController(childViewController: UIViewController)
    {
        addChildViewController(childViewController)
        
        questionContainer.addSubview(childViewController.view)
        
        childViewController.view.frame = questionContainer.bounds
        childViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        childViewController.didMove(toParentViewController: self)
    }
    
    // MARK: - Setup ViewController
    
    private func setupAnswerButtons(viewController: QuestionInteractionViewController)
    {
        for buttonIndex in 0..<viewController.answerButtons.count
        {
            let button = viewController.answerButtons[buttonIndex]
            
            button.clipsToBounds = true
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            button.titleLabel?.textAlignment = NSTextAlignment.left
            button.contentHorizontalAlignment = .left
            button.titleLabel?.numberOfLines = 2
            button.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
            
            if question.answers.indices.contains(buttonIndex)
            {
                button.isHidden = false
                button.setTitle(String(buttonIndex + 1) + ". " + question.answers[buttonIndex], for: .normal)
            }
            else
            {
                button.isHidden = true
            }
        }
    }
    
    private func setupBannerAds()
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
}
