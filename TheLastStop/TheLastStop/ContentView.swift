//
//  ContentView.swift
//  TheLastStop
//
//  Created by 송재훈 on 2/5/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var sceneManager = SceneManager()
    
    var body: some View {
        ZStack {
            if let scene = sceneManager.currentScene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ContentView()
}
