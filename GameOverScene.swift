import SpriteKit

class GameOverScene: SKScene {
    
     init(size: CGSize, playerWin: Bool){
        super.init(size: size)
        let backgroundImage = SKSpriteNode(imageNamed: "bgwall")
        backgroundImage.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(backgroundImage)
        
        let message = SKLabelNode(fontNamed: "Arial")
        message.fontSize = 30
        message.position = CGPointMake(self.frame.midX, self.frame.midY)
        
        if playerWin {
            message.text = "Congrats! VICTORY!"
        } else {
            message.text = "You LOSE!!"
        }
        self.addChild(message)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}