//
//  RoundedTopBar.swift
//  Magnus
//
//  Created by Paweł Sałek on 14/07/2025.
//

import SwiftUI

struct RoundedTopBar : View {
    let title: String
    
    var body: some View {
        HStack {
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
            TopBarSearchButton(action: {})
                .padding(.trailing, 4)
            TopBarEnvelopeButton(action: {})
                .padding(.trailing, 4)
            TopBarAlertButton(action: {})
                .padding(.trailing, 4)
            TopBarUserButton(action: {})
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
