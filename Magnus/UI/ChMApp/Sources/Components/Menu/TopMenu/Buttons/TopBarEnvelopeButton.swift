import SwiftUI
import MagnusFeatures

struct TopBarEnvelopeButton: View {
    @StateObject private var viewModel: TopBarEnvelopeButtonViewModel
    @State private var loadTask: Task<Void, Never>?
    let action: () -> Void
    let isActive: Bool
    
    init(action: @escaping () -> Void, isActive: Bool = false) {
        self.action = action
        self.isActive = isActive
        _viewModel = StateObject(wrappedValue: TopBarEnvelopeButtonViewModel())
    }

    var body: some View {
        ZStack {
            Button(action: action) {
                FAIcon(
                    .email,
                    type: .light,
                    size: 18,
                    color: Color.novoNordiskTextGrey
                )
                .frame(width: 30, height: 30)
            }
            .background(Color.novoNordiskGreyButton)
            .clipShape(Circle())
            .overlay(
                isActive ? Circle()
                    .stroke(Color.novoNordiskLightBlue, lineWidth: 1)
                    : nil
            )
            .frame(width: 40, height: 40)
            
            if viewModel.unreadMessagesCount > 0 {
                Circle()
                    .fill(Color.novoNordiskOrangeRed)
                    .frame(width: 8, height: 8)
                    .offset(x: 12, y: -12)
            }
        }
        .onAppear {
            loadTask?.cancel()
            loadTask = Task { @MainActor in
                await viewModel.getUnreadMessagesCount()
            }
        }
        .onDisappear {
            loadTask?.cancel()
            loadTask = nil
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("TopBarEnvelopeButton Preview")
            .font(.title2)
            .fontWeight(.bold)
        
    
        TopBarEnvelopeButton(action: {}, isActive: false)
        
        TopBarEnvelopeButton(action: {}, isActive: true)
        .background(Color.gray)
    }
}
