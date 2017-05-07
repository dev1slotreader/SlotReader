import UIKit

class StoryViewController: UIViewController
{
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    
    @IBOutlet weak var question0Button: UIButton!
    @IBOutlet weak var question1Button: UIButton!
    @IBOutlet weak var question2Button: UIButton!
    private var questionButtons: [UIButton]!
    
    public var story: Story!
    public var storiesFile: String!
    private var answersState = [Bool](repeating: false, count: 3)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        questionButtons = [question0Button, question1Button, question2Button]
        storyTitleLabel.text = story.name
        storyLabel.text = story.content
        storyLabel.sizeToFit()
        setupButtons(buttons: questionButtons)
        retrieveAnswers()
        saveState()
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
                    self.answersState[questionNumber] = true
                    
                    self.saveAnswers()
                }
            })
            
            questionMenu.addAction(action)
        }
        
        self.present(questionMenu, animated: true, completion: nil)
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
    
    func setupButtons(buttons: [UIButton])
    {
        for button in buttons
        {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
    }
}
