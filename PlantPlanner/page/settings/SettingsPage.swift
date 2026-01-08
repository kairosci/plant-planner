import SwiftUI

struct SettingsPage: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = Locale.preferredLanguages.first ?? "en"
    @AppStorage("temperatureUnit") private var temperatureUnit = "Celsius"
    @AppStorage("lengthUnit") private var lengthUnit = "Meters"
    
    @State private var notificationsEnabled = true
    
    var clear = Color.clear
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.cyan.opacity(0.25), Color.green.opacity(0.25)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    Form {
                        Section {
                            languagePicker
                                .padding(.vertical, 8)
                            notificationToggle
                                .padding(.vertical, 8)
                            temperatureUnitPicker
                                .padding(.vertical, 8)
                            lengthUnitPicker
                                .padding(.vertical, 8)
                        }
                        .listRowBackground(clear)
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.top, -20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .onAppear {
            selectedLanguage = selectedLanguage
            temperatureUnit = temperatureUnit
            lengthUnit = lengthUnit
        }
        .onChange(of: selectedLanguage) { newValue in
            updateAppLanguage(to: newValue)
        }
    }
    
    private var languagePicker: some View {
        HStack {
            Text("Language")
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            Picker("", selection: $selectedLanguage) {
                Text("English").tag("en")
                Text("Italian").tag("it")
                Text("Spanish").tag("es")
                Text("French").tag("fr")
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(.black)
        }.onAppear {
            print("Lingua selezionata: \(selectedLanguage)")
        }
    }
    
    private var notificationToggle: some View {
        Toggle(isOn: $notificationsEnabled) {
            Text("Notifications")
                .font(.body)
                .foregroundColor(.black)
        }
        .toggleStyle(SwitchToggleStyle(tint: .black))
    }
    
    private var temperatureUnitPicker: some View {
        HStack {
            Text("Temperature Unit")
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            Picker("", selection: $temperatureUnit) {
                Text("Celsius").tag("Celsius")
                Text("Fahrenheit").tag("Fahrenheit")
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(.black)
        }
    }
    
    private var lengthUnitPicker: some View {
        HStack {
            Text("Length Unit")
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            Picker("", selection: $lengthUnit) {
                Text("Meters").tag("Meters")
                Text("Feet").tag("Feet")
                Text("Yards").tag("Yards")
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(.black)
        }
    }
    
    private func updateAppLanguage(to languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        
        Bundle.setLanguage(languageCode)
        
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

#Preview {
    SettingsPage()
}
