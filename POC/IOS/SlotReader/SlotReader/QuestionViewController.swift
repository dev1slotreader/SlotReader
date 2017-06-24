import UIKit
import GoogleMobileAds

protocol QuestionDelegate
{
    func userDidAnswer(question: Int, result: Bool)
}

class QuestionViewController: UIViewController
{
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var questionNumber: Int!
    var question: StoryQuestion!
    var answerButtons = [UIButton]()
    var delegate: QuestionDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        answerButtons = [answer1Button, answer2Button, answer3Button]
        questionLabel.text = question.question
        setupAnswerButtons()
        
        bannerView.adUnitID = "ca-app-pub-9340983276950968/7881710335"
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // for test
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton)
    {
        let isAnswerCorrect = answerButtons[question.correctAnswer] == sender
        self.delegate?.userDidAnswer(question: questionNumber, result: isAnswerCorrect)
        
        dismiss(animated: true, completion: nil)
    }
    
    func setupAnswerButtons()
    {
        for buttonIndex in 0..<answerButtons.count
        {
            let button = answerButtons[buttonIndex]
            
            button.clipsToBounds = true
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            button.titleLabel?.textAlignment = NSTextAlignment.left
            button.contentHorizontalAlignment = .left
            button.titleLabel?.numberOfLines = 2
            button.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
            
            if question.answers.indices.contains(buttonIndex)
            {
                button.isHidden = false
                button.setTitle(String(buttonIndex + 1) + ". " + question.answers[buttonIndex], for: UIControlState.normal)
            }
            else
            {
                button.isHidden = true
            }
        }
    }
}
