import UIKit

class StoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var stories = [Story]()
    var selectedStory: Story?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        readStories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationVc = segue.destination as? StoryViewController
        {
            destinationVc.story = selectedStory
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
        
        cell.storyNameLabel.text = currentStory.name
        cell.wordCountLabel.text = "(" + String(currentStory.content.components(separatedBy: " ").count) + ")"
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedStory = stories[indexPath.row]
        performSegue(withIdentifier: "ShowStory", sender: self)
    }
    
    func readStories()
    {
        let path = Bundle.main.path(forResource: "stories", ofType: "txt")
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
}
