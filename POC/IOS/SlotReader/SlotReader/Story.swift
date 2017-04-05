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
}
