import SwiftUI

struct MainPage: View {
    @AppStorage("language") private var language: String = Locale.preferredLanguages.first ?? ""
    @Environment(\.colorScheme) var colorScheme
    @State private var userPlants: [UserPlantData] = []
    @State private var searchText: String = ""
    @State private var tabViewPresented = false
    @State var isChange = false
    
    var body: some View {
        Group {
            if !tabViewPresented {
                TabView {
                    gardenView()
                        .tabItem {
                            Image(systemName: "leaf.fill")
                            Text(Bundle.localizedString(forKey: "Garden", comment: ""))
                        }
                    
                    ReminderPage()
                        .tabItem {
                            Image(systemName: "bell.fill")
                            Text(Bundle.localizedString(forKey: "Reminders", comment: ""))
                        }
                    
                    SettingsPage()
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                            Text(Bundle.localizedString(forKey: "Settings", comment: ""))
                        }
                }
                .tint(.black)
            } else {
                CreatePage(onUserPlantAdded: {
                    loadUserPlantsFromCache()
                    tabViewPresented = false
                })
            }
        }
        .onAppear {
            initializeLanguage()
            loadUserPlantsFromCache()
        }
    }
    
    private func gardenView() -> some View {
        NavigationStack {
            VStack {
                getTopBar()
                homeContent()
                Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.cyan.opacity(0.25), Color.green.opacity(0.25)]),
                               startPoint: .top,
                               endPoint: .bottom)
            )
        }
    }
    
    private func initializeLanguage() {
        if language.isEmpty {
            language = Locale.preferredLanguages.first ?? ""
        }
        Bundle.setLanguage(language)
    }
    
    private func loadUserPlantsFromCache() {
        userPlants = PlantCache.shared.loadUserPlantsFromJSON()
    }
    
    private func homeContent() -> some View {
        VStack(spacing: 20) {
            if userPlants.isEmpty {
                getEmptyStateView()
            } else {
                getPlantGrid()
            }
        }
        .padding()
    }
    
    private func getEmptyStateView() -> some View {
        VStack {
            Spacer()
            Image("main.void")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            Text(Bundle.localizedString(forKey: "PlantNotFound", comment: "Message when no plants are found"))
                .font(.custom("Helvetica", size: 18))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
    
    private func getPlantGrid() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                ForEach(filteredPlants) { plant in
                    NavigationLink(destination: PlantDetailPage(plants: $userPlants, plant: plant)) {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorScheme == .dark ? .black : .white)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                .frame(height: 70)
                            
                            HStack(spacing: 0) {
                                Image(plant.plant.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(.white, lineWidth: 2))
                                    .shadow(radius: 4)
                                    .offset(x: -16)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(plant.name)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                    
                                    Text(plant.plant.name)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.leading, 16)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 16)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func deletePlant(_ plant: UserPlantData) {
        PlantCache.shared.deleteUserPlant(plant: plant)
        loadUserPlantsFromCache()
    }
    
    private func getTopBar() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(Bundle.localizedString(forKey: "MyGarden", comment: "My Garden Title"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Spacer()
                
                NavigationLink(destination: CreatePage(onUserPlantAdded: {
                    loadUserPlantsFromCache()
                    tabViewPresented = false
                })) {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            }
            .padding(.horizontal)
            
            getSearchBar()
        }
        .padding(.top, 32)
    }
    
    private func getSearchBar() -> some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField(Bundle.localizedString(forKey: "SearchPlaceholder", comment: "Search"), text: $searchText)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .font(.subheadline)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? Color.gray.opacity(0.5) : Color.white.opacity(0.2))
            )
        }
        .padding(.horizontal)
    }
    
    private var filteredPlants: [UserPlantData] {
        if searchText.isEmpty {
            return userPlants
        } else {
            return userPlants.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
