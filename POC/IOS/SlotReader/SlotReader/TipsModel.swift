import Foundation

class TipsModel
{
    private var tips = [String]()
    private var strings = [String:String]()
    
    let sendYourImageId = "sendYourImage"
    let yourImageHereId = "yourImageHere"
    
    init(lang: String)
    {
        switch lang
        {
            case "en":
                self.tips.append("We add new stories constantly. Stay tuned.")
                self.tips.append("You'll neeed to review advertisement video to open new story.")
            
                self.strings[sendYourImageId] = "Send to us your story or illustration to existing one and we will add best ones to our application. Don't forget to add your name and location where are you from. helpdesk@fivesysdev.com"
                self.strings[yourImageHereId] = "Your illustration can be here"
            case "uk":
                self.tips.append("Ми додаємо нові історії постійно. Залишайтеся з нами.")
                self.tips.append("Вам потрібно проглянути рекламне відео, щоб відкрити нову історію.")
            
                self.strings[sendYourImageId] = "Надсилайте нам свою історію або ілюстрацію до існуючої, і ми додамо найкращі до нашого додатку. Не забудьте додати своє ім'я і місце звідки ви. helpdesk@fivesysdev.com"
                self.strings[yourImageHereId] = "Ваша ілюстрація може бути тут"
            case "ru":
                self.tips.append("Мы постоянно добавляем новые истории. Оставайтесь с нами.")
                self.tips.append("Чтобы открыть новую историю, просмотрите рекламный ролик.")
            
                self.strings[sendYourImageId] = "Отправьте нам свою историю или иллюстрацию к существующей и мы добавим лучшие в наше приложение. Не забудьте указать свое имя и адрес, откуда вы. helpdesk@fivesysdev.com"
                self.strings[yourImageHereId] = "Ваша иллюстрация может быть здесь"
            default:
                self.tips.append("")
        }
    }
    
    func getTip() -> String
    {
        let randomPosition = arc4random_uniform(UInt32(tips.count))
        
        return tips[Int(randomPosition)]
    }
    
    func getString(_ identifier: String) -> String?
    {
        return strings[identifier]
    }
}
