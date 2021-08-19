//
//  BuddyScene.swift
//  WristBuddy WatchKit Extension
//
//  Created by Luigi Greco on 23/07/21.
//

import WatchKit
import SpriteKit


class BuddyScene: SKScene {
    
    var rssURL = URL(string: "https://www.ansa.it/sito/notizie/topnews/topnews_rss.xml")
    var news = [RSSData]()
    var closeButton = SKSpriteNode()
    //let newsFrame = SKShapeNode(rectOf: CGSize(width: 165 , height: 170), cornerRadius: 10)
    let newsTitle = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let newsDescription = SKLabelNode(fontNamed: "AmericanTypewriter")
    let newsCounter = SKLabelNode(fontNamed: "AmericanTypewriter")
    var newsCount = Int()
    var currentNewsIndex = Int()
    var isShowingNews = Bool()
    
    var newsFrame = SKSpriteNode()
    var leftPaw = SKSpriteNode()
    var rightPaw = SKSpriteNode()
    var numImages = Int()
    var dog = SKSpriteNode()
    var buddyActionFrames: [SKTexture] = []
    var objectAnimationFrames: [SKTexture] = []
    var firstFrameTexture = SKTexture()
    var boneNode = SKSpriteNode()
    var soapNode = SKSpriteNode()
    var ballNode = SKSpriteNode()
    var newspaperNode = SKSpriteNode()
    var boneAnimNode = SKSpriteNode()
    var newspaperAnimNode = SKSpriteNode()
    var bubblesNode = SKSpriteNode()
    var ballAnimNode = SKSpriteNode()
    var background = SKSpriteNode()
    var foreground = SKSpriteNode()
    var celestialObj = SKSpriteNode()
    let objectsAtlas = SKTextureAtlas(named: "objects")
    let bubblesAtlas = SKTextureAtlas(named: "bubbles")
    let dogJumpAtlas = SKTextureAtlas(named: "dogJump")
    let ballPlayingAtlas = SKTextureAtlas(named: "ballPlaying")
    let ballAnimAtlas = SKTextureAtlas(named: "ballAnim")
    var setBackground = SKAction()
    var setForeground = SKAction()
    var setCelestial = SKAction()
    
    override func sceneDidLoad() {
        setScene()
        bubblesNode.name = "bubblesNode"
        setupRestingAnimation()
        restDog()
        scene?.addChild(dog)
        setupBone()
        setupSoap()
        setupBall()
        setupNewspaper()
        downloadNews()
        
        let newsFrameTexture = SKTextureAtlas(named: "objects").textureNamed("frame")
        let setNewsFrameTexture = SKAction.setTexture(newsFrameTexture, resize: false)
        newsFrame.run(setNewsFrameTexture)
        var pawTexture = SKTextureAtlas(named: "objects").textureNamed("pawL")
        var setPawTexture = SKAction.setTexture(pawTexture, resize: false)
        leftPaw.run(setPawTexture)
        leftPaw.position = CGPoint(x: -70 ,y: -85)
        pawTexture = SKTextureAtlas(named: "objects").textureNamed("pawR")
        setPawTexture = SKAction.setTexture(pawTexture, resize: false)
        rightPaw.run(setPawTexture)
        rightPaw.position = CGPoint(x: 70 ,y: -85)
        
    }
    
    func redrawBackground(){
        setScene()
        background.zPosition = -3
        celestialObj.zPosition = -2
        foreground.zPosition = -1
    }
    
    func downloadNews(){
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            config.allowsCellularAccess = true
            config.allowsConstrainedNetworkAccess = true
            config.allowsExpensiveNetworkAccess = true
            config.waitsForConnectivity = true
            return URLSession(configuration: config)
        }()

        let request = URLRequest(url: rssURL!)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            if let obtainedData = data {
                self.parseNews(withData: obtainedData)
            }
            else if let requestError = error {
                print("error \(requestError)")
            } else {
                print("unexpected error")
            }
        }
        task.resume()
    }
    
    func parseNews(withData: Data){
        let parser = RSSParser()
        parser.startParsingWithData(downloadedData: withData) { (Bool) in
            if let data = parser.parsedData as [[String:String]]? {
                for element in data {
                    let data = RSSData.init(title: element["title"]!, description: element["description"]!, url: element["link"]!)
                    news.append(data)
                }
                newsCount = data.count
            }
            
        }
        
    }
    
    func displayNews(){
        isShowingNews = true
        if (news.count) != 0 {
            currentNewsIndex = 0
            dog.isHidden = true
            boneNode.isHidden = true
            soapNode.isHidden = true
            ballNode.isHidden = true
            newspaperNode.isHidden = true
            
            //newsFrame.fillColor = .black
            
            let closeButtonTexture = SKTextureAtlas(named: "objects").textureNamed("closeButton")
            let setCloseButtonTexture = SKAction.setTexture(closeButtonTexture, resize: false)
            closeButton.setScale(0.5)
            closeButton.position = CGPoint(x: frame.midX - 75, y: frame.midY + 80)
            closeButton.run(setCloseButtonTexture)
            
            
            newsTitle.lineBreakMode = .byClipping
            newsTitle.preferredMaxLayoutWidth = 160
            newsTitle.verticalAlignmentMode = .center
            newsTitle.numberOfLines = 2
            newsTitle.text = news[0].title
            newsTitle.fontSize = 13
            newsTitle.fontColor = SKColor.black
            newsTitle.position = CGPoint(x: frame.midX , y: frame.midY + 40)
            
            newsDescription.lineBreakMode = .byClipping
            newsDescription.preferredMaxLayoutWidth = 150
            newsDescription.verticalAlignmentMode = .center
            newsDescription.numberOfLines = 4
            newsDescription.text = news[0].description
            newsDescription.fontSize = 12
            newsDescription.fontColor = SKColor.black
            newsDescription.position = CGPoint(x: frame.midX , y: frame.midY - 20)
            
            
            newsCounter.fontSize = 10
            newsCounter.fontColor = SKColor.black
            newsCounter.position = CGPoint(x: frame.midX, y: frame.midY - 75)
            newsCounter.text = "\(currentNewsIndex+1) of \(newsCount)"
            
            addChild(newsFrame)
            addChild(newsTitle)
            addChild(newsDescription)
            addChild(newsCounter)
            addChild(closeButton)
            addChild(leftPaw)
            addChild(rightPaw)
        } else {
            print("There are no news downloaded")
            
            dog.isHidden = true
            boneNode.isHidden = true
            soapNode.isHidden = true
            ballNode.isHidden = true
            newspaperNode.isHidden = true
            
            
            newsDescription.lineBreakMode = .byWordWrapping
            newsDescription.preferredMaxLayoutWidth = 160
            newsDescription.numberOfLines = 4
            newsDescription.text = "Error fetching news. Please check your internet connection"
            newsDescription.fontSize = 12
            newsDescription.fontColor = SKColor.white
            newsDescription.position = CGPoint(x: frame.midX , y: frame.midY - 30)

            
            let closeButtonTexture = SKTextureAtlas(named: "objects").textureNamed("closeButton")
            let setCloseButtonTexture = SKAction.setTexture(closeButtonTexture, resize: false)
            closeButton.setScale(0.8)
            closeButton.run(setCloseButtonTexture)
            closeButton.position = CGPoint(x: frame.midX - 75, y: frame.midY + 80)
            
            //newsFrame.fillColor = .black
            
            addChild(newsFrame)
            addChild(newsDescription)
            addChild(closeButton)
            addChild(leftPaw)
            addChild(rightPaw)
        }
        
    }
    
//    func scrollNews(){
//        if isShowingNews {
//            if currentNewsIndex <= newsCount {
//                currentNewsIndex += 1
//                newsTitle.text = news[currentNewsIndex].title
//                newsDescription.text = news[currentNewsIndex].description
//                newsCounter.text = "\(currentNewsIndex+1) of \(newsCount)"
//            }
//        }
//    }
    
    func nextNews(){
        if isShowingNews{
            if currentNewsIndex < newsCount - 1 {
                currentNewsIndex += 1
                newsTitle.text = news[currentNewsIndex].title
                newsDescription.text = news[currentNewsIndex].description
                newsCounter.text = "\(currentNewsIndex+1) of \(newsCount)"
            }
        }

    }
    
    func prevNews(){
        if isShowingNews {
            if currentNewsIndex >= 1 {
                currentNewsIndex -= 1
                newsTitle.text = news[currentNewsIndex].title
                newsDescription.text = news[currentNewsIndex].description
                newsCounter.text = "\(currentNewsIndex+1) of \(newsCount)"
            }
        }

    }
    
    
    func setScene(){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        var celestialPosition = CGPoint(x: 0, y: 0)
        switch hour {
        case 5:
            celestialPosition.x = -70
            celestialPosition.y = 0
            celestialObj.setScale(1.1)
        case 6:
            celestialPosition.x = -65
            celestialPosition.y = 10
            celestialObj.setScale(1.2)
        case 7:
            celestialPosition.x = -55
            celestialPosition.y = 30
            celestialObj.setScale(1.2)
        case 8:
            celestialPosition.x = -40
            celestialPosition.y = 40
            celestialObj.setScale(1.3)
        case 9:
            celestialPosition.x = -30
            celestialPosition.y = 50
            celestialObj.setScale(1.3)
        case 10:
            celestialPosition.x = -25
            celestialPosition.y = 55
            celestialObj.setScale(1.3)
        case 11:
            celestialPosition.x = -20
            celestialPosition.y = 60
            celestialObj.setScale(1.3)
        case 12:
            celestialPosition.x = 0
            celestialPosition.y = 70
            celestialObj.setScale(1.8)
        case 13:
            celestialPosition.x = 20
            celestialPosition.y = 60
            celestialObj.setScale(1.3)
        case 14:
            celestialPosition.x = 25
            celestialPosition.y = 55
            celestialObj.setScale(1.3)
        case 15:
            celestialPosition.x = 30
            celestialPosition.y = 50
            celestialObj.setScale(1.3)
        case 16:
            celestialPosition.x = 40
            celestialPosition.y = 40
            celestialObj.setScale(1.3)
        case 17:
            celestialPosition.x = 55
            celestialPosition.y = 30
            celestialObj.setScale(1.2)
        case 18:
            celestialPosition.x = 70
            celestialPosition.y = 0
            celestialObj.setScale(1)
        case 19:
            celestialPosition.x = -70
            celestialPosition.y = 0
            celestialObj.setScale(1)
        case 20:
            celestialPosition.x = 65
            celestialPosition.y = 10
            celestialObj.setScale(1.1)
        case 21:
            celestialPosition.x = -55
            celestialPosition.y = 30
            celestialObj.setScale(1.1)
        case 22:
            celestialPosition.x = -40
            celestialPosition.y = 40
            celestialObj.setScale(1.2)
        case 23:
            celestialPosition.x = -30
            celestialPosition.y = 50
            celestialObj.setScale(1.2)
        case 0:
            celestialPosition.x = 0
            celestialPosition.y = 70
            celestialObj.setScale(1.2)
        case 1:
            celestialPosition.x = 20
            celestialPosition.y = 60
            celestialObj.setScale(1.2)
        case 2:
            celestialPosition.x = 40
            celestialPosition.y = 40
            celestialObj.setScale(1.2)
        case 3:
            celestialPosition.x = 55
            celestialPosition.y = 30
            celestialObj.setScale(1.1)
        case 4:
            celestialPosition.x = 70
            celestialPosition.y = 0
            celestialObj.setScale(1)
        default:
            celestialPosition.x = 0
            celestialPosition.y = 70
        }
        celestialObj.position = celestialPosition
        if (hour > 7 && hour < 18) {
            // morning
            addBackground(bgTexture: "skyDay", fgTexture: "grassDay", celestialTexture: "sun")
        } else if (hour >= 18 && hour <= 20 ){
            // sunset
            addBackground(bgTexture: "skySunset", fgTexture: "grassSunset", celestialTexture: "sun")
        } else if ( hour >= 5 && hour <= 7) {
            // sunrise
            addBackground(bgTexture: "skySunrise", fgTexture: "grassSunrise", celestialTexture: "sun")
        } else {
            // night
            addBackground(bgTexture: "skyNight", fgTexture: "grassNight", celestialTexture: "moon")
        }
    }
    
    func addBackground(bgTexture: String, fgTexture: String, celestialTexture: String) {
        setBackground = SKAction.setTexture(objectsAtlas.textureNamed(bgTexture), resize: false)
        setForeground = SKAction.setTexture(objectsAtlas.textureNamed(fgTexture), resize: false)
        setCelestial = SKAction.setTexture(objectsAtlas.textureNamed(celestialTexture), resize: false)
        background.run(setBackground)
        scene?.addChild(background)
        celestialObj.run(setCelestial)
        scene?.addChild(celestialObj)
        foreground.run(setForeground)
        scene?.addChild(foreground)
    }
    

    
    func checkForNode(named: String) -> Bool {
        if (childNode(withName: named) as! SKSpriteNode?) != nil {
            print("Node is already present, wait for animation to finish")
            return true
        } else {
            return false
        }
    }
    
    func setupBoneAnim(){
        if checkForNode(named: "boneAnimNode") == false {
        let boneAnimAtlas = SKTextureAtlas(named: "boneAnim")
        numImages = boneAnimAtlas.textureNames.count
        objectAnimationFrames.removeAll()
        for i in 1...numImages {
            let boneAnimTextureName = "boneAnim\(i)"
            objectAnimationFrames.append(boneAnimAtlas.textureNamed(boneAnimTextureName))
        }
        firstFrameTexture = objectAnimationFrames[0]
        let setAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        boneAnimNode.run(setAnimTexture)
        boneAnimNode.setScale(1.4)
        boneAnimNode.position = CGPoint(x: frame.midX, y: frame.midY + 20)
        scene?.addChild(boneAnimNode)
        boneAnimNode.name = "boneAnimNode"
        boneAnimNode.run(SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.15, resize: false, restore: false), completion: boneEatingAnim)
    }
    }
    func
    boneEatingAnim() {
        boneAnimNode.removeFromParent()
        dog.removeAllActions()
        buddyActionFrames.removeAll()
        let dogBonEatingAtlas = SKTextureAtlas(named: "boneEating")
        numImages = dogBonEatingAtlas.textureNames.count
        for i in 1...numImages {
            let dogBoneEatingTextureName = "boneEating\(i)"
            buddyActionFrames.append(dogBonEatingAtlas.textureNamed(dogBoneEatingTextureName))
        }
        firstFrameTexture = buddyActionFrames[0]
        let setBoneEatingTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setBoneEatingTexture)
        dog.run(SKAction.repeat(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.2, resize: false, restore: false), count: 6), completion: {
            self.restDog()
        })
    }
    
    func setupNewspaperAnim(){
        if checkForNode(named: "newspaperAnimNode") == false {
        let newspaperAnimAtlas = SKTextureAtlas(named: "newspaperAnim")
        numImages = newspaperAnimAtlas.textureNames.count
        objectAnimationFrames.removeAll()
        for i in 1...numImages {
            let newspaperAnimTextureName = "News\(i)"
            objectAnimationFrames.append(newspaperAnimAtlas.textureNamed(newspaperAnimTextureName))
        }
        firstFrameTexture = objectAnimationFrames[0]
        let setAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        newspaperAnimNode.run(setAnimTexture)
        newspaperAnimNode.setScale(1.4)
        newspaperAnimNode.position = CGPoint(x: frame.midX, y: frame.midY + 20)
        scene?.addChild(newspaperAnimNode)
        newspaperAnimNode.name = "newspaperAnimNode"
        newspaperAnimNode.run(SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.15, resize: false, restore: false), completion: newsEatingAnim)
    }
    }
    func newsEatingAnim() {
        newspaperAnimNode.removeFromParent()
        dog.removeAllActions()
        buddyActionFrames.removeAll()
        let newsEatingAtlas = SKTextureAtlas(named: "newsEating")
        numImages = newsEatingAtlas.textureNames.count
        for i in 1...numImages {
            let newsEatingTextureName = "newsEat\(i)"
            buddyActionFrames.append(newsEatingAtlas.textureNamed(newsEatingTextureName))
        }
        firstFrameTexture = buddyActionFrames[0]
        let setNewsEatingTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setNewsEatingTexture)
        dog.run(SKAction.repeat(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.2, resize: false, restore: false), count: 2), completion: {
            self.displayNews()
        })
    }
    
    func setupBubblesAnim1(){
        if checkForNode(named: "bubblesNode") == false {
            objectAnimationFrames.removeAll()
        for i in 1...6 {
            let bubblesTextureName = "bubbles\(i)"
            objectAnimationFrames.append(bubblesAtlas.textureNamed(bubblesTextureName))
        }
        firstFrameTexture = objectAnimationFrames[0]
        let setAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        bubblesNode.run(setAnimTexture)
        bubblesNode.setScale(1.5)
        scene?.addChild(bubblesNode)
        bubblesNode.name = "bubblesNode"
        bubblesNode.run(SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.15, resize: false, restore: false), completion: setupBubblesAnim2)
        }
    }
    
    func setupBubblesAnim2(){
        dog.removeAllActions()
        objectAnimationFrames.removeAll()
        let dogBathAtlas = SKTextureAtlas(named: "dogBath")
        let bathFrame = dogBathAtlas.textureNamed("dogBath1")
        let setBathTexture = SKAction.setTexture(bathFrame, resize: false)
        dog.run(setBathTexture)
        numImages = bubblesAtlas.textureNames.count
        for i in 7...numImages {
            let bubblesTextureName = "bubbles\(i)"
            objectAnimationFrames.append(bubblesAtlas.textureNamed(bubblesTextureName))
        }
        firstFrameTexture = objectAnimationFrames[0]
        let setAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        bubblesNode.run(setAnimTexture)
        bubblesNode.run(SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.15, resize: false, restore: false), completion: bathDog)
    }
    
    func setupBallAnim(){
        if checkForNode(named: "ballAnimNode") == false {
        objectAnimationFrames.removeAll()
        numImages = ballAnimAtlas.textureNames.count
        for i in 1...numImages {
            let ballAnimTextureName = "ballAnim\(i)"
            objectAnimationFrames.append(ballAnimAtlas.textureNamed(ballAnimTextureName))
        }
        scene?.addChild(ballAnimNode)
        ballAnimNode.name = "ballAnimNode"
        let incomingBall = SKAction.setTexture(objectAnimationFrames[0], resize: false)
        let animateIncomingBall = SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.1, resize: false, restore: false)
        let sequence = SKAction.sequence([incomingBall, animateIncomingBall])
            ballAnimNode.setScale(1.5)
        ballAnimNode.run(sequence, completion: setupBallAnim2)
        }
    }
    
    func setupBallAnim2(){
        
            numImages = dogJumpAtlas.textureNames.count
            buddyActionFrames.removeAll()
            for i in 1...numImages {
                let dogJumpTextureName = "dogJump\(i)"
                buddyActionFrames.append(dogJumpAtlas.textureNamed(dogJumpTextureName))
            }
            let playWithBall = SKAction.run { [self] in

                        buddyActionFrames.removeAll()
                        numImages = ballPlayingAtlas.textureNames.count
                        for i in 1...numImages {
                            let ballPlayingTextureName = "ballPlaying\(i)"
                            buddyActionFrames.append(ballPlayingAtlas.textureNamed(ballPlayingTextureName))
                        }
                        dog.removeAllActions()
                        dog.position = CGPoint(x: frame.midX, y: frame.midY - 17)
                        dog.run(SKAction.setTexture(ballPlayingAtlas.textureNamed("ballPlaying1"), resize: true))
                        dog.run(SKAction.setTexture(buddyActionFrames[0], resize: false))
                        dog.run(SKAction.repeat(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.15), count: 3), completion: restDog)
                ballAnimNode.removeFromParent()
            }

            // far giocare il cane - azione cane
            
            let sequence = SKAction.sequence([  playWithBall])
            dog.run(sequence)

    }
    
    func setupBone(){
        let boneFrame = objectsAtlas.textureNamed("bone")
        let setBone = SKAction.setTexture(boneFrame, resize: false)
        boneNode.run(setBone)
        boneNode.position = CGPoint(x: frame.midX - 60 , y: frame.midY - 80)
        scene?.addChild(boneNode)
    }
    
    func setupSoap(){
        let soapFrame = objectsAtlas.textureNamed("soap")
        let setSoap = SKAction.setTexture(soapFrame, resize: false)
        soapNode.run(setSoap)
        soapNode.position = CGPoint(x: frame.midX - 20 , y: frame.midY - 80)
        soapNode.setScale(0.5)
        scene?.addChild(soapNode)
    }
    
    func setupBall(){
        let ballFrame = objectsAtlas.textureNamed("ball")
        let setBall = SKAction.setTexture(ballFrame, resize: false)
        ballNode.run(setBall)
        ballNode.setScale(0.75)
        ballNode.position = CGPoint(x: frame.midX + 20, y: frame.midY - 80)
        scene?.addChild(ballNode)
    }
    
    func setupNewspaper(){
        let newspaperFrame = objectsAtlas.textureNamed("newspaper")
        let setNewspaper = SKAction.setTexture(newspaperFrame, resize: false)
        newspaperNode.run(setNewspaper)
        //newspaperNode.setScale(0.75)
        newspaperNode.position = CGPoint(x: frame.midX + 60, y: frame.midY - 80)
        scene?.addChild(newspaperNode)
    }
    
    func setupRestingAnimation(){
        dog.removeAllActions()
        buddyActionFrames.removeAll()
        let lionRestingAtlas = SKTextureAtlas(named: "lionWaving")
        for i in 1...3 {
            let lionTextureName = "lionWaving\(i)"
            buddyActionFrames.append(lionRestingAtlas.textureNamed(lionTextureName))
        }
        firstFrameTexture = buddyActionFrames[0]
        let setRestTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setRestTexture)
        dog.position = CGPoint(x: frame.midX, y: frame.midY - 10)
    }
    
    func restDog(){
        setupRestingAnimation()
        dog.run(SKAction.repeatForever(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.3, resize: false, restore: false)), withKey: "restingLion")
    }
    
    func waveDog(){
        dog.removeAllActions()
        buddyActionFrames.removeAll()
        let dogWavingAtlas = SKTextureAtlas(named: "lionWaving")
        numImages = dogWavingAtlas.textureNames.count
        for i in 4...numImages {
            let dogTextureName = "lionWaving\(i)"
            buddyActionFrames.append(dogWavingAtlas.textureNamed(dogTextureName))
        }
        // Reverse the animation loop
        for i in stride(from: numImages, to: 1, by: -1) {
            let lionTextureName = "lionWaving\(i)"
            buddyActionFrames.append(dogWavingAtlas.textureNamed(lionTextureName))
        }
        firstFrameTexture = buddyActionFrames[0]
        let setWaveTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setWaveTexture)
        dog.run(SKAction.repeat(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.2, resize: false, restore: false), count: 1), completion: {
            self.restDog()
        })
    }
    
    func bathDog(){
        bubblesNode.removeFromParent()
        buddyActionFrames.removeAll()
        dog.removeAllActions()
        let dogBathAtlas = SKTextureAtlas(named: "dogBath")
        numImages = dogBathAtlas.textureNames.count
        for i in 1...numImages {
            let dogTextureName = "dogBath\(i)"
            buddyActionFrames.append(dogBathAtlas.textureNamed(dogTextureName))
        }
        firstFrameTexture = buddyActionFrames[0]
        let setBathTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setBathTexture)
        dog.run(SKAction.repeat(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.2, resize: false, restore: false), count: 8), completion: {
            self.restDog()
        })
    }
    
    func didTap(atPosition: CGPoint) {
        let hitNodes = self.nodes(at: atPosition)
        if hitNodes.contains(dog) {
            waveDog()
        } else if hitNodes.contains(boneNode) {
            setupBoneAnim()
        } else if hitNodes.contains(soapNode) {
            setupBubblesAnim1()
        } else if hitNodes.contains(ballNode) {
            setupBallAnim()
        } else if hitNodes.contains(newspaperNode) {
            setupNewspaperAnim()
        } else if hitNodes.contains(closeButton) {
            scene?.removeChildren(in: [closeButton, newsFrame, newsTitle, newsDescription, newsCounter, leftPaw, rightPaw])
            isShowingNews = false
            dog.isHidden = false
            boneNode.isHidden = false
            soapNode.isHidden = false
            ballNode.isHidden = false
            newspaperNode.isHidden = false
            restDog()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
}
