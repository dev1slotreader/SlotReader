import UIKit

class QuestionInteractionViewController: UIViewController
{
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    
    var answerButtons = [UIButton]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        answerButtons = [answer1Button, answer2Button, answer3Button]
    }
    
    // MARK: - Actions
    
    @IBAction func answerButtonTapped(_ sender: UIButton)
    {
        let viewController = parent as! QuestionViewController
        
        let isAnswerCorrect = answerButtons[viewController.question.correctAnswer] == sender
        viewController.delegate?.userDidAnswer(question: viewController.questionNumber, result: isAnswerCorrect)
        viewController.isAnswerCorrect = isAnswerCorrect
        
        viewController.updateContainerView(true)
    }
}
