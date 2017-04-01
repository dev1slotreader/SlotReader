import Foundation

class StoryQuestion
{
    var question = String()
    var answers = [String]()
    var correctAnswer = 0
    
    init?(json: [String: Any])
    {
        guard let question = json["question"] as? String,
            let answers = json["answers"] as? [String],
            let correctAnswer = json["correctAnswer"] as? Int
        else
        {
            return nil
        }
        
        var answersArray = [String]()
        for string in answers
        {
            answersArray.append(string)
        }
        
        self.question = question
        self.answers = answersArray
        self.correctAnswer = correctAnswer
    }
}
