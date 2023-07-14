import SwiftUI

struct RathboneDetailsView: View {
    @State private var rathboneOptions: [Rathbone] = []

    var body: some View {
        VStack {
            Text("Rathbone Dining Hall Details")
                .font(.title)
                .padding()

            List {
                ForEach(mealTypes, id: \.self) { mealType in
                    Section(header: headerView(for: mealType)) {
                        ForEach(courseNames(for: mealType), id: \.self) { courseName in
                            Section(header: Text(courseName)) {
                                ForEach(rathbones(for: mealType, courseName: courseName)) { rathbone in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(rathbone.menuItemName)
                                                .font(.headline)
                                            Spacer()
                                            HStack(spacing: 16) {
                                                Button(action: {
                                                    upvoteRathbone(rathbone)
                                                }) {
                                                    Image(systemName: "hand.thumbsup")
                                                }
                                                .buttonStyle(BorderlessButtonStyle()) // Add button style
                                                Text("\(rathbone.upvotes)")
                                                Button(action: {
                                                    downvoteRathbone(rathbone)
                                                }) {
                                                    Image(systemName: "hand.thumbsdown")
                                                }
                                                .buttonStyle(BorderlessButtonStyle()) // Add button style
                                                Text("\(rathbone.downvotes)")
                                            }
                                        }
                                        Text("Calories: \(rathbone.calorieText ?? "N/A")")
                                            .font(.subheadline)
                                        Text("Allergens: \(rathbone.allergenNames)")
                                            .font(.subheadline)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                }
            }

            Spacer()
        }
        .background(Color.white)
        .navigationBarTitle("Rathbone Dining Hall", displayMode: .inline)
        .onAppear {
            fetchRathboneOptions()
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
                    let rathboneOptions = try decoder.decode([Rathbone].self, from: data)
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
        let sortedMealTypes = ["breakfast", "lunch", "dinner"].filter({ uniqueMealTypes.contains($0) })
        return sortedMealTypes
    }

    private func courseNames(for mealType: String) -> [String] {
        let uniqueCourseNames = Set(rathbones(for: mealType).map({ $0.courseName }))
        return Array(uniqueCourseNames)
    }

    private func rathbones(for mealType: String) -> [Rathbone] {
        return rathboneOptions.filter({ $0.mealType == mealType })
    }

    private func rathbones(for mealType: String, courseName: String) -> [Rathbone] {
        return rathbones(for: mealType).filter({ $0.courseName == courseName })
    }
    
    private func upvoteRathbone(_ rathbone: Rathbone) {
        guard let url = URL(string: "http://localhost:8000/rathbone/\(rathbone.id)?upvoted=true&downvoted=false") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error upvoting Rathbone:", error)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    if let index = rathboneOptions.firstIndex(where: { $0.id == rathbone.id }) {
                        // Check if the rathbone has already been upvoted or downvoted
                        if !rathboneOptions[index].upvoted && !rathboneOptions[index].downvoted {
                            rathboneOptions[index].upvotes += 1
                            rathboneOptions[index].upvoted = true
                            rathboneOptions[index].downvotes = 0  // Reset downvotes to 0
                            rathboneOptions[index].downvoted = false
                        }
                    }
                }
                print("Rathbone upvoted successfully")
            } else {
                print("Failed to upvote Rathbone")
            }
        }.resume()
    }

    private func downvoteRathbone(_ rathbone: Rathbone) {
        guard let url = URL(string: "http://localhost:8000/rathbone/\(rathbone.id)?upvoted=false&downvoted=true") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error downvoting Rathbone:", error)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    if let index = rathboneOptions.firstIndex(where: { $0.id == rathbone.id }) {
                        // Check if the rathbone has already been upvoted or downvoted
                        if !rathboneOptions[index].downvoted && !rathboneOptions[index].upvoted {
                            rathboneOptions[index].downvotes += 1
                            rathboneOptions[index].downvoted = true
                            rathboneOptions[index].upvotes = 0  // Reset upvotes to 0
                            rathboneOptions[index].upvoted = false
                        }
                    }
                }
                print("Rathbone downvoted successfully")
            } else {
                print("Failed to downvote Rathbone")
            }
        }.resume()
    }










    
    // Custom section header view for mealType
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
    var upvotes: Int
    var downvotes: Int
    var upvoted: Bool  // New property
    var downvoted: Bool  // New property
        
    init(id: Int, mealType: String, courseName: String, menuItemName: String, calorieText: String?, allergenNames: String, upvotes: Int, downvotes: Int, upvoted: Bool, downvoted: Bool) {
            self.id = id
            self.mealType = mealType
            self.courseName = courseName
            self.menuItemName = menuItemName
            self.calorieText = calorieText
            self.allergenNames = allergenNames
            self.upvotes = upvotes
            self.downvotes = downvotes
            self.upvoted = upvoted
            self.downvoted = downvoted
        }
}

struct RathboneDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RathboneDetailsView()
    }
}
