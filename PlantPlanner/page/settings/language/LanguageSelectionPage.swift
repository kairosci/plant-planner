import SwiftUI

struct LanguageSelectionPage: View {
    @Binding var selectedLanguage: String
    @Environment(\.dismiss) private var dismiss
    
    private let languages = ["English", "Italian", "Spanish", "French"]
    private let languageCodes = ["en", "it", "es", "fr"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                getBackgroundGradient()
                VStack {
                    getHeader()
                    getLanguageList()
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func getBackgroundGradient() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.cyan.opacity(0.35), Color.green.opacity(0.35)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    private func getHeader() -> some View {
        HStack {
            Text("Select Language")
                .font(.custom("Helvetica", size: 30))
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.top, 20)
    }
    
    private func getLanguageList() -> some View {
        VStack(spacing: 15) {
            ForEach(0..<languages.count, id: \.self) { index in
                Button(action: {
                    selectedLanguage = languageCodes[index]
                    updateAppLanguage(to: languageCodes[index])
                    dismiss()
                }) {
                    HStack {
                        Text(languages[index])
                            .font(.custom("Helvetica", size: 18))
                            .foregroundColor(.black)
                        Spacer()
                        if selectedLanguage == languageCodes[index] {
                            Image(systemName: "checkmark")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 0)
                }
            }
        }
    }
    
    private func updateAppLanguage(to languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        Bundle.setLanguage(languageCode)
    }
}

