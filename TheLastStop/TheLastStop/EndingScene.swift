//
//  EndingScene.swift
//  TheLastStop
//
//  Created by 송재훈 on 2/19/25.
//

import SwiftUI
import SpriteKit

class EndingScene: SKScene {
    weak var sceneManager: SceneManager?
    
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
        setupBackgroundColor()
        setupTitleLabel()
        setupReplayLabel()
    }
    
    private func setupBackgroundColor() {
        backgroundColor = UIColor(Color("GrayColor"))
    }
    
    private func setupTitleLabel() {
        let label = SKLabelNode(text: "The Last Stop: Ocean")
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        addChild(label)
    }
    
    private func setupReplayLabel() {
        let nextLabel = SKLabelNode(text: "Replay")
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
        nextArea.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        
        nextArea.addChild(nextLabel)
        addChild(nextArea)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if let name = touchedNode.name, name.contains("next") {
            sceneManager?.transition(to: .onboarding)
        }
    }
}

struct EndingScenePreview: PreviewProvider {
    static var scene: SKScene {
        EndingScene(manager: SceneManager(), size: CGSize(width: 1024, height: 768))
    }
    
    static var previews: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}
