import UIKit

class StoryViewController: UIViewController
{
    @IBOutlet weak var storyLabel: UILabel!
    
    public var story: Story!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        storyLabel.text = story.content
    }
    
    @IBAction func questionButtonTapped(_ sender: UIButton)
    {
        var questionNumber: Int
        
        switch sender.accessibilityIdentifier! {
        case "question0": questionNumber = 0
        case "question1": questionNumber = 1
        case "question2": questionNumber = 2
        default: questionNumber = -1
        }
        
        let question = story.questions[questionNumber]
        
        let questionMenu = UIAlertController(title: question.question, message: nil, preferredStyle: .alert)
        
        for i in 0..<question.answers.count
        {
            let action = UIAlertAction(title: question.answers[i], style: .default, handler:
            {
                (action:UIAlertAction!) -> Void in
                

                if question.correctAnswer == i
                {
                    sender.imageView?.image = UIImage(named: "star_filled")
                }
            })
            
            questionMenu.addAction(action)
        }
        
        self.present(questionMenu, animated: true, completion: nil)
    }
}
