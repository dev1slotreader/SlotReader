import UIKit

class StoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var stories = [Story]()
    var selectedStory: Story?
    var language: String!
    var storiesFile: String!
    let supportedLanguages = ["en", "ru", "uk"]
    
    @IBOutlet weak var storiesCollection: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        language = UserDefaults.standard.string(forKey: "language")
        storiesFile = "stories_" + language
        readStories(language)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        storiesCollection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationVc = segue.destination as? StoryViewController
        {
            destinationVc.story = selectedStory
            destinationVc.storiesFile = storiesFile
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCell", for: indexPath) as! StoryCollectionViewCell
        
        let currentStory = stories[indexPath.row]
        
        if (currentStory.name.characters.count > 15)
        {
            let index = currentStory.name.index(currentStory.name.startIndex, offsetBy: 15)
            cell.storyNameLabel.text = currentStory.name.substring(to: index) + "..."
        }
        else
        {
            cell.storyNameLabel.text = currentStory.name
        }
        
        cell.wordCountLabel.text = "(" + String(currentStory.content.components(separatedBy: " ").count) + ")"
        
        let answers = retrieveAnswersFor(story: currentStory.name)
        
        if answers.count > 0
        {
            cell.firstQuestionStar.image = answers[0] ? UIImage(named: "star_filled") : UIImage(named: "star")
            cell.secondQuestionStar.image = answers[1] ? UIImage(named: "star_filled") : UIImage(named: "star")
            cell.thirdQuestionStar.image = answers[2] ? UIImage(named: "star_filled") : UIImage(named: "star")
        }
        else
        {
            cell.firstQuestionStar.image = UIImage(named: "star")
            cell.secondQuestionStar.image = UIImage(named: "star")
            cell.thirdQuestionStar.image = UIImage(named: "star")
        }
        
        let state = retrieveStoryStateFor(story: currentStory.name)
            
        if state
        {
            cell.storyIcon.alpha = 1
        }
        else
        {
            cell.storyIcon.alpha = 0.2
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedStory = stories[indexPath.row]
        performSegue(withIdentifier: "ShowStory", sender: self)
    }
    
    func readStories(_ lang: String)
    {
        if supportedLanguages.contains(lang)
        {
            let path = Bundle.main.path(forResource: "stories_" + lang, ofType: "txt")
            let jsonData : NSData = NSData(contentsOfFile: path!)!
            do
            {
                if let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: []) as? [String: Any],
                    let storiesJson = json["stories"] as? [[String: Any]]
                    {
                        for story in storiesJson
                        {
                            if let s = Story(json: story)
                            {
                                stories.append(s)
                            }
                        }
                    }
            }
            catch
            {
                print("Error deserializing JSON.")
            }
        }
        
        stories.sort { $0.0.content.components(separatedBy: " ").count < $0.1.content.components(separatedBy: " ").count }
    }
    
    func retrieveAnswersFor(story name: String) -> [Bool]
    {
        var answersState = [Bool]()
        
        let userDefaults = UserDefaults.standard
        
        if let stories = userDefaults.value(forKey: storiesFile) as? [String: [Bool]]
        {
            if let answers = stories[name]
            {
                answersState = answers
            }
        }

        return answersState
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
}
