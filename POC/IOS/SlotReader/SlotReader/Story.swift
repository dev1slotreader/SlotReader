import Foundation

class Story
{
    var name = String()
    var content = String()
    var partsContent = String()
    
    var questions = [StoryQuestion]()
    
    init?(json: [String: Any])
    {
        guard let name = json["name"] as? String,
            let content = json["content"] as? String,
            let partsContent = json["partsContent"] as? String,
            let questions = json["questions"] as? [[String: Any]]
        else
        {
            return nil
        }
        
        var questionsArray = [StoryQuestion]()
        
        for string in questions
        {
            guard let q = StoryQuestion(json: string)
            else
            {
                return nil
            }
            questionsArray.append(q)
        }
        
        self.name = name
        self.content = content
        self.partsContent = partsContent
        self.questions = questionsArray
    }
    
    // MARK: - Methods
    
    /**
     Retrieves an array of Bool values which indicates whether the questions were answered correctly or not.
     - parameter file: Name of the .txt file where story originaly resides in (e.g. stories_en).
     */
    func retrieveAnswersCorrectness(for file: String) -> [Bool]
    {
        var answersState = [Bool]()
        
        let userDefaults = UserDefaults.standard
        
        if let stories = userDefaults.value(forKey: file) as? [String: [Bool]]
        {
            if let answers = stories[name]
            {
                answersState = answers
            }
        }
        
        return answersState
    }
    
    /**
     Retrieves an array of Bool values which indicates whether the questions were answered.
     This method only returns the state of question, but doesn't give any information whether the questions were answered correctly or not. Use **retrieveAnswersCorrectness** method to determine the correctness of the given answers.
     - parameter file: Name of the .txt file where story originaly resides in (e.g. stories_en).
     */
    func retrieveQuestionsState(for file: String) -> [Bool]
    {
        var answersState = [Bool]()
        let userDefaults = UserDefaults.standard
        
        if let stories = userDefaults.value(forKey: file + "_answerStates") as? [String: [Bool]]
        {
            if let state = stories[name]
            {
                answersState = state
            }
        }
        
        return answersState
    }
    
    /**
     Saves the state of questions and correctness of given answers to User Defaults.
     - parameter file: Name of the .txt file where story originaly resides in (e.g. stories_en).
     - parameter questionsState: Array of Bool which indicates whether the questions were answered.
     - parameter answersCorrectness: Array of Bool which indicates whether the questions were answerred correctly.
     */
    func saveAnswers(for file: String, _ questionsState: [Bool], _ answersCorrectness: [Bool])
    {
        let userDefaults = UserDefaults.standard
        
        if var stories = userDefaults.value(forKey: file + "_answerStates") as? [String: [Bool]]
        {
            stories.updateValue(questionsState, forKey: name)
            userDefaults.set(stories, forKey: file + "_answerStates")
        }
        else
        {
            var stories = [String: [Bool]]()
            stories.updateValue(questionsState, forKey: name)
            userDefaults.set(stories, forKey: file + "_answerStates")
        }
        
        if var stories = userDefaults.value(forKey: file) as? [String: [Bool]]
        {
            stories.updateValue(answersCorrectness, forKey: name)
            userDefaults.set(stories, forKey: file)
        }
        else
        {
            var stories = [String: [Bool]]()
            stories.updateValue(answersCorrectness, forKey: name)
            userDefaults.set(stories, forKey: file)
        }
    }
    
    func getFontSize() -> Int
    {
        let userDefaults = UserDefaults.standard
        
        if let fontSize = userDefaults.value(forKey: "storyFontSize") as? Int
        {
            return fontSize
        }
        else
        {
            return 22 // default size
        }
    }
    
    func saveFontSize(_ size: Int)
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(size, forKey: "storyFontSize")
        
    }
}
