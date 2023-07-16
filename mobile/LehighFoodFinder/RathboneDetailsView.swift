import SwiftUI

struct RathboneDetailsView: View {
    @State private var rathboneOptions: [Rathbone] = []
    @State private var isHomeViewPresented = false

    var body: some View {
        NavigationView {
            VStack(spacing: 3) {
                        Spacer() // Add a spacer to push the views to the top
                        Spacer()
                        
                        Text("Rathbone Dining Hall")
                            .font(.system(size: 24, weight: .bold))
                        
                        Text("Click on the Map to Go Back to the Map")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer() // Add a spacer to push the button to the bottom
                        
                        Button(action: {
                            isHomeViewPresented = true
                        }) {
                            Image("AppleMaps")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 33, height: 33)
                        }
                        .fullScreenCover(isPresented: $isHomeViewPresented) {
                            HomeView()
                                .environmentObject(NavigationState()) // Provide the NavigationState environment object
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)

                    List {
                        ForEach(mealTypes, id: \.self) { mealType in
                            Section(header: headerView(for: mealType)) {
                                ForEach(courseNames(for: mealType), id: \.self) { courseName in
                                    Section(header: Text(courseName)) {
                                        ForEach(rathbones(for: mealType, courseName: courseName)) { rathbone in
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("\(rathbone.menuItemName)")
                                                    .font(.headline)
                                                    .lineLimit(nil)
                                                
                                                Text("Calories: \(rathbone.calorieText ?? "N/A")")
                                                    .font(.subheadline)
                                                
                                                HStack(alignment: .top, spacing: 4) {
                                                    Text("Dietary Restrictions: \(rathbone.allergenNames)")
                                                        .font(.subheadline)
                                                     //   .foregroundColor(.secondary)
                                                        .lineLimit(nil)
                                                        .fixedSize(horizontal: false, vertical: true) // Allow multiple lines
                                                }

                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                            .fixedSize(horizontal: false, vertical: true)

                                            .overlay(
                                                HStack(spacing: 4) {
                                                    Spacer()
                                                    HStack(spacing: 4) {
                                                        ForEach(1...5, id: \.self) { star in
                                                            Image(systemName: "star.fill")
                                                                .foregroundColor(rathbone.givenStars >= star ? .yellow : .gray)
                                                                .font(.system(size: 12))
                                                                .onTapGesture {
                                                                    rateRathbone(rathbone, givenStars: star)
                                                                }
                                                        }
                                                    }
                                                    .frame(height: 20)
                                                }
                                                .padding(.trailing, 16)
                                                .padding(.top, 28) // Adjust the top padding value to move the stars up or down
                                                , alignment: .topTrailing
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            .background(Color.white)
                        .navigationBarTitle("", displayMode: .inline)
                        .padding(.top, -25)
                        .onAppear {
                            fetchRathboneOptions()
            }
        }
    }
    
    private func fetchRathboneOptions() {
        guard let url = URL(string: "http://localhost:8000/rathbone") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        var rathboneOptions = try decoder.decode([Rathbone].self, from: data)
                        rathboneOptions.sort { $0.menuItemName < $1.menuItemName } // Sort alphabetically
                        DispatchQueue.main.async {
                            self.rathboneOptions = rathboneOptions
                        }
                    } catch {
                        print("Error decoding JSON:", error)
                    }
                }
            }.resume()
    }
    
    private var mealTypes: [String] {
        let uniqueMealTypes = Set(rathboneOptions.map({ $0.mealType }))
        let sortedMealTypes = uniqueMealTypes.sorted()
        return sortedMealTypes
    }


    private func courseNames(for mealType: String) -> [String] {
        let uniqueCourseNames = Set(rathbones(for: mealType).map({ $0.courseName }))
        let sortedCourseNames = uniqueCourseNames.sorted()
        return sortedCourseNames
    }

    private func rathbones(for mealType: String) -> [Rathbone] {
        return rathboneOptions.filter({ $0.mealType == mealType })
    }

    private func rathbones(for mealType: String, courseName: String) -> [Rathbone] {
        let filteredRathbones = rathbones(for: mealType).filter { $0.courseName == courseName }
        return filteredRathbones.sorted { $0.menuItemName < $1.menuItemName } // Sort alphabetically
    }

    private func rateRathbone(_ rathbone: Rathbone, givenStars: Int) {
        guard let url = URL(string: "http://localhost:8000/rathbone/\(rathbone.id)") else {
            return
        }

        struct RathboneRatingRequest: Codable {
            let givenStars: Int
        }

        let userEmail = GoogleSignInManager.shared.userEmail ?? ""  // Get the userEmail from GoogleSignInManager
        print(userEmail)

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set Content-Type header
        request.setValue(userEmail, forHTTPHeaderField: "userEmail") // Set userEmail header

        let requestBody = RathboneRatingRequest(givenStars: givenStars)
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            print("Error creating JSON data:", error)
            return
        }
        print(requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error rating Rathbone:", error)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    if let index = rathboneOptions.firstIndex(where: { $0.id == rathbone.id }) {
                        rathboneOptions[index].givenStars = givenStars
                    }
                }
                print("Rathbone rated successfully")
            } else {
                print("Failed to rate Rathbone")
            }
        }.resume()
    }



    private func upvoteRathbone(_ rathbone: Rathbone) {
        rateRathbone(rathbone, givenStars: 5)
    }

    private func downvoteRathbone(_ rathbone: Rathbone) {
        rateRathbone(rathbone, givenStars: 1)
    }

    private func headerView(for mealType: String) -> some View {
        Text(mealType)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct Rathbone: Codable, Identifiable {
    let id: Int
    let mealType: String
    let courseName: String
    let menuItemName: String
    let calorieText: String?
    let allergenNames: String
    var givenStars: Int
    let totalGivenStars: Int
    let totalMaxStars: Int
    let averageStars: Double

    init(id: Int, mealType: String, courseName: String, menuItemName: String, calorieText: String?, allergenNames: String, givenStars: Int, totalGivenStars: Int, totalMaxStars: Int, averageStars: Double) {
        self.id = id
        self.mealType = mealType
        self.courseName = courseName
        self.menuItemName = menuItemName
        self.calorieText = calorieText
        self.allergenNames = allergenNames
        self.givenStars = givenStars
        self.totalGivenStars = totalGivenStars
        self.totalMaxStars = totalMaxStars
        self.averageStars = averageStars
    }
}

struct RathboneDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RathboneDetailsView()
    }
}
