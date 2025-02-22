//
//  DropScene.swift
//  TheLastStop
//
//  Created by 송재훈 on 2/19/25.
//

import SwiftUI
import SpriteKit

enum DropPhase {
    case drop
    case inTransition
}

class DropScene: SKScene {
    weak var sceneManager: SceneManager?
    
    private var phase: DropPhase = .drop
    private var scripts: [SKNode] = []
    private var sky: SKSpriteNode!
    private var trainFrame: SKSpriteNode!
    private var crane: SKSpriteNode!
    private var ocean: SKSpriteNode!
    private var oceanGround: SKSpriteNode!
    
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
        setupSky()
        setupOcean()
        setupOceanGround()
        setupTrainFrame()
        setupCrane()
        setupScript()
    }
    
    private func setupSky() {
        sky = SKSpriteNode(color: UIColor(Color("SkyColor")), size: CGSize(width: size.width, height: size.height * 3))
        sky.name = "sky"
        sky.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        addChild(sky)
    }
    
    private func setupTrainFrame() {
        let trainFrameTexture = SKTexture(imageNamed: "TrainFrame")
        
        trainFrame = SKSpriteNode(texture: trainFrameTexture, size: trainFrameTexture.size())
        trainFrame.name = "trainFrame"
        trainFrame.position = CGPoint(x: size.width / 2, y: (size.height / 2) + (size.height * 0.2))
        
        addChild(trainFrame)
    }
    
    private func setupCrane() {
        let craneTexture = SKTexture(imageNamed: "Crane")
        
        crane = SKSpriteNode(texture: craneTexture, size: craneTexture.size())
        crane.name = "crane"
        crane.position = CGPoint(x: size.width / 2, y: size.height + (-size.height * 0.15) + (size.height * 0.2))
        
        addChild(crane)
    }
    
    private func setupOcean() {
        ocean = SKSpriteNode(color: UIColor(Color("OceanColor")), size: size)
        ocean.name = "ocean"
        ocean.position = CGPoint(x: size.width / 2, y: -size.height * 2.0)
        ocean.zPosition = 0
        
        addChild(ocean)
    }
    
    private func setupOceanGround() {
        oceanGround = SKSpriteNode(color: UIColor(Color("OceanGroundColor")), size: CGSize(width: size.width, height: size.height / 2))
        oceanGround.name = "oceanGround"
        oceanGround.position = CGPoint(x: size.width / 2, y: -size.height * 2)
        oceanGround.zPosition = 0.1
        
        addChild(oceanGround)
    }
    
    private func setupScript() {
        switch phase {
        case .drop:
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
    
    private func clearScript() {
        scripts.forEach({ $0.removeFromParent() })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if let name = touchedNode.name, name.contains("next") {
            switch phase {
            case .drop:
                phase = .inTransition
                clearScript()
                
                let waitOneSecond = SKAction.wait(forDuration: 1.0)
                let release = SKAction.moveBy(x: 0, y: size.height / 2, duration: 1.0)
                let moveCenter = SKAction.moveTo(y: size.height / 2, duration: 1.0)
                let moveGround = SKAction.moveBy(x: 0, y: size.height * 2 + trainFrame.size.height / 2, duration: 1.0)
                let moveSky = SKAction.moveBy(x: 0, y: size.height, duration: 1.0)
                
                let transitionAction = SKAction.run { [weak self] in
                    self?.sceneManager?.transition(to: .aging)
                }
                
                let trainSequence = SKAction.sequence([moveCenter])
                let craneSequence = SKAction.sequence([release])
                let oceanSequence = SKAction.sequence([waitOneSecond, moveCenter])
                let oceanGroundSequence = SKAction.sequence([waitOneSecond, waitOneSecond, moveGround, transitionAction])
                let skySequence = SKAction.sequence([moveSky])
                
                trainFrame.run(trainSequence)
                crane.run(craneSequence)
                ocean.run(oceanSequence)
                oceanGround.run(oceanGroundSequence)
                sky.run(skySequence)
            case .inTransition:
                break
            }
        }
    }
}

struct DropScenePreview: PreviewProvider {
    static var scene: SKScene {
        DropScene(manager: SceneManager(), size: CGSize(width: 1024, height: 768))
    }
    
    static var previews: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}
