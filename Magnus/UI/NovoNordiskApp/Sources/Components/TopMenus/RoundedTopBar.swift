//
//  RoundedTopBar.swift
//  Magnus
//
//  Created by Paweł Sałek on 14/07/2025.
//

import SwiftUI

struct RoundedTopBar : View {
    let title: String
    let canGoBack: Bool
    let showSearchButton: Bool
    let showNotificationButtons: Bool
    let showProfileButton: Bool
    let showSettingsButton: Bool
    let onBackTap: () -> Void
    let onProfileTap: () -> Void
    let onSettingsTap: () -> Void
    
    init(
        title: String,
        canGoBack: Bool = false,
        showSearchButton: Bool = false,
        showNotificationButtons: Bool = true,
        showProfileButton: Bool = true,
        showSettingsButton: Bool = false,
        onBackTap: @escaping () -> Void = {},
        onProfileTap: @escaping () -> Void = {},
        onSettingsTap: @escaping () -> Void = {}
    ) {
        self.title = title
        self.canGoBack = canGoBack
        self.showSearchButton = showSearchButton
        self.showNotificationButtons = showNotificationButtons
        self.showProfileButton = showProfileButton
        self.showSettingsButton = showSettingsButton
        self.onBackTap = onBackTap
        self.onProfileTap = onProfileTap
        self.onSettingsTap = onSettingsTap
    }
    
    var body: some View {
        HStack {
            if canGoBack {
                backButton
            }
            titleSection
            Spacer()
            buttonSection
        }
        .frame(height: 54)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .background {
            Rectangle()
                .fill(Color.white)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 25,
                        bottomTrailingRadius: 25,
                        topTrailingRadius: 0
                    )
                )
                .ignoresSafeArea(edges: .all)
                .shadow(color: .black.opacity(0.2), radius: 20, y: 5)
        }
    }
    
    @ViewBuilder
    var backButton: some View {
        Button(action: onBackTap) {
            FAIcon(.back, type: .light, size: 20, color: Color.novoNordiskBlue)
                .frame(width: 40, height: 40)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    var titleSection: some View {
        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding(0)
    }
    
    @ViewBuilder
    var buttonSection: some View {
        HStack(spacing: 1) {
            if showSearchButton {
                TopBarSearchButton(action: {})
                    .padding(.trailing, 4)
            }
            
            if showNotificationButtons {
                TopBarEnvelopeButton(action: {})
                    .padding(.trailing, 4)
                TopBarAlertButton(action: {})
                    .padding(.trailing, 4)
            }
            
            if showProfileButton {
                TopBarUserButton(action: onProfileTap)
            }
            
            if showSettingsButton {
                Button(action: onSettingsTap) {
                    FAIcon(.settings, type: .light, size: 20, color: Color.novoNordiskBlue)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(0)
    }
}

#Preview("RoundedTopBar") {

    ZStack {
       // Rectangle().fill(.black.gradient).opacity(0.2).ignoresSafeArea()
        VStack {
            RoundedTopBar(title: "Sample Title")
            Spacer()
        }
        
    }
}

#Preview("Dashboard") {
    Dashboard()
}
