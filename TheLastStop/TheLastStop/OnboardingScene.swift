//
//  OnboardingScene.swift
//  TheLastStop
//
//  Created by 송재훈 on 2/16/25.
//

import SwiftUI
import SpriteKit

enum OnboardingPhase {
    case aboutOldTrain
    case changeOfOldTrain
    case nextScene
    case inTransition
}

class OnboardingScene: SKScene {
    weak var sceneManager: SceneManager?
    
    private var phase: OnboardingPhase = .aboutOldTrain
    private var sky: SKSpriteNode!
    private var ground: SKSpriteNode!
    private var cloud: SKSpriteNode!
    private var train: SKSpriteNode!
    private var rails: [SKSpriteNode] = []
    private var factory: SKSpriteNode!
    private var scripts: [SKNode] = []
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(manager: SceneManager, size: CGSize) {
        self.sceneManager = manager
        super.init(size: size)
        
        print(#fileID, "init")
    }
    
    deinit {
        print(#fileID, "deinit")
    }
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupTrain()
        setupFactory()
        setupRails()
        setupScript()
        startRailAnimation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if let name = touchedNode.name, name.contains("next") {
            switch phase {
            case .aboutOldTrain:
                phase = .changeOfOldTrain
                clearScript()
                setupScript()
            case .changeOfOldTrain:
                phase = .nextScene
                clearScript()
                setupScript()
            case .nextScene:
                clearScript()
                startTransitionAnimation()
            case .inTransition:
                break
            }
        }
    }
    
    private func clearScript() {
        scripts.forEach({ $0.removeFromParent() })
    }
    
    private func setupScript() {
        switch phase {
        case .aboutOldTrain:
            createScriptUI(
                text: "Here is an old train.\nA very, very old train.",
                showNext: true
            )
        case .changeOfOldTrain:
            createScriptUI(
                text: "Now let's see what changes the train will face\nwhen it can no longer run on the rail.",
                showNext: true
            )
        case .nextScene:
            createScriptUI(
                text: nil,
                showNext: true
            )
        case .inTransition:
            break
        }
    }

    private func createScriptUI(text: String?, showNext: Bool) {
        var scriptArea: SKSpriteNode?
        if let scriptText = text {
            let scriptLabel = SKLabelNode(text: scriptText)
            scriptLabel.fontSize = 40
            scriptLabel.fontColor = .white
            scriptLabel.numberOfLines = 0
            scriptLabel.horizontalAlignmentMode = .center
            scriptLabel.verticalAlignmentMode = .center
            scriptLabel.preferredMaxLayoutWidth = size.width * 0.65
            scriptLabel.lineBreakMode = .byWordWrapping

            let scriptWidth = scriptLabel.preferredMaxLayoutWidth + 40
            let scriptHeight = scriptLabel.calculateAccumulatedFrame().height + 40

            scriptArea = SKSpriteNode(color: .black.withAlphaComponent(0.5), size: CGSize(width: scriptWidth, height: scriptHeight))
            scriptArea!.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
            scriptLabel.position = CGPoint(x: 0, y: 0)
            scriptArea!.addChild(scriptLabel)

            addChild(scriptArea!)
        }

        if showNext {
            let nextLabel = SKLabelNode(text: "Next")
            nextLabel.name = "nextLabel"
            nextLabel.fontSize = 30
            nextLabel.fontColor = .white
            nextLabel.horizontalAlignmentMode = .center
            nextLabel.verticalAlignmentMode = .center

            let nextArea = SKSpriteNode(
                color: .black.withAlphaComponent(0.5),
                size: CGSize(width: nextLabel.frame.width * 2, height: nextLabel.frame.height * 3)
            )
            nextArea.name = "nextButton"
            
            if let scriptArea = scriptArea {
                nextArea.position = CGPoint(
                    x: scriptArea.position.x + scriptArea.size.width / 2 + nextArea.size.width / 2 + 10,
                    y: scriptArea.position.y
                )
            } else {
                nextArea.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
            }

            nextArea.addChild(nextLabel)
            addChild(nextArea)

            scripts += [nextArea]
            if let scriptArea = scriptArea {
                scripts.append(scriptArea)
            }
        }
    }
    
    private func setupBackground() {
        let trainTexture = SKTexture(imageNamed: "Train.svg")
        
        sky = SKSpriteNode(color: UIColor(Color("SkyColor")), size: size)
        sky.name = "sky"
        sky.position = CGPoint(x: size.width / 2, y: size.height - trainTexture.size().height / 2)
        
        ground = SKSpriteNode(color: UIColor(Color("OceanGroundColor")), size: size)
        ground.name = "ground"
        ground.position = CGPoint(x: size.width / 2, y: size.height / 2)
                
        addChild(ground)
        addChild(sky)
    }
    
    private func setupTrain() {
        let trainTexture = SKTexture(imageNamed: "Train.svg")
        train = SKSpriteNode(texture: trainTexture, size: trainTexture.size())
        train.name = "train"
        train.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        
        addChild(train)
    }
    
    private func setupFactory() {
        let factoryTexture = SKTexture(imageNamed: "Factory.svg")
        factory = SKSpriteNode(texture: factoryTexture, size: factoryTexture.size())
        factory.name = "factory"
        factory.position = CGPoint(x: size.width * 1.5, y: size.height * 0.5)
        factory.zPosition = 1.0
        
        let label = SKLabelNode(text: "Ocean")
        label.fontSize = 40
        label.fontColor = .white
        
        addChild(factory)
        factory.addChild(label)
    }
    
    private func setupRails() {
        let railTexture = SKTexture(imageNamed: "Rail.svg")
        let railSize = railTexture.size()
        let trainSize = SKTexture(imageNamed: "Train.svg").size()
        rails = []
        
        for i in 1...60 {
            let rail = SKSpriteNode(texture: railTexture, size: railSize)
            
            rail.name = "rail\(i)"
            rail.position = CGPoint(x: 1500 - (CGFloat(i) * railSize.width), y: (size.height * 0.5) - trainSize.height / 2)
            
            addChild(rail)
            rails.append(rail)
        }
    }
    
    private func startRailAnimation() {
        let railTexture = SKTexture(imageNamed: "Rail.svg")
        let railSize = railTexture.size()
        
        let moveLeft = SKAction.moveBy(x: -railSize.width * 3, y: 0, duration: 1)
        let resetPosition = SKAction.run { [weak self] in
            guard let self = self else { return }
            
            let rail = self.rails.removeFirst()
            rail.position.x += railSize.width * 3
            self.rails.append(rail)
        }
        
        let sequence = SKAction.sequence([moveLeft, resetPosition])
        let repeatAction = SKAction.repeatForever(sequence)
        
        for rail in rails {
            rail.run(repeatAction)
        }
    }
    
    private func startTransitionAnimation() {
        let waitOneSecond = SKAction.wait(forDuration: 1.0)
        
        let moveTrainLeft = SKAction.moveBy(x: -size.width / 2, y: 0, duration: 1.0)
        let moveTrainRight = SKAction.moveBy(x: size.width / 2, y: 0, duration: 2.0)
        
        let moveFactoryCenter = SKAction.moveTo(x: size.width / 2, duration: 2.0)
        
        let transitionAction = SKAction.run { [weak self] in
            self?.sceneManager?.transition(to: .title)
        }
        
        let trainSequence = SKAction.sequence([moveTrainLeft, waitOneSecond, waitOneSecond, moveTrainRight, waitOneSecond, transitionAction])
        let factorySequence = SKAction.sequence([waitOneSecond,  moveFactoryCenter])
        
        train.run(trainSequence)
        factory.run(factorySequence)
    }
}

struct OnboardingScenePreview: PreviewProvider {
    static var scene: SKScene {
        OnboardingScene(manager: SceneManager(), size: CGSize(width: 1024, height: 768))
    }
    
    static var previews: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}
