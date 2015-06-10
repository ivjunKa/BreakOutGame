import SpriteKit

class GameStartScene: SKScene {
    let gameStartButton: SKSpriteNode! = nil
    let gameExitButton: SKSpriteNode?
    let gameTutorialButton: SKSpriteNode?
    
    override init(size: CGSize){
        super.init(size: size)
        let backgroundImage = SKSpriteNode(imageNamed: "bgwall")
        backgroundImage.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(backgroundImage)
        
        gameStartButton = SKSpriteNode(imageNamed: "startGameButton")
        gameStartButton.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(gameStartButton)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if gameStartButton.containsPoint(location){
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene)
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}