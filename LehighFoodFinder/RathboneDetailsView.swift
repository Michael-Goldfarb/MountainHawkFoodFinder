import SwiftUI

class Rathbone: Codable, Identifiable {
    let id: Int
    let mealType: String
    let courseName: String
    let menuItemName: String
    let calorieText: String?
    let allergenNames: String
    var upvotes: Int
    var downvotes: Int
    var upvoted: Bool
    var downvoted: Bool
    
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case mealType
        case courseName
        case menuItemName
        case calorieText
        case allergenNames
        case upvotes
        case downvotes
        case upvoted
        case downvoted
    }
}

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
                                                    Image(systemName: rathbone.upvoted ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                }
                                                Text("\(rathbone.upvotes)")
                                                Button(action: {
                                                    downvoteRathbone(rathbone)
                                                }) {
                                                    Image(systemName: rathbone.downvoted ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                                }
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
                    decoder.dateDecodingStrategy = .iso8601
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
    
    private func upvoteRathbone(_ rathbone: Rathbone) {
        guard let index = rathboneOptions.firstIndex(where: { $0.id == rathbone.id }) else {
            return
        }
        
        var updatedRathbone = rathboneOptions[index]
        
        if updatedRathbone.upvoted {
            updatedRathbone.upvotes -= 1
        } else {
            updatedRathbone.upvotes += 1
            if updatedRathbone.downvoted {
                updatedRathbone.downvotes -= 1
                updatedRathbone.downvoted = false
            }
        }
        
        updatedRathbone.upvoted = !updatedRathbone.upvoted
        
        rathboneOptions[index] = updatedRathbone
        
        guard let url = URL(string: "http://localhost:8000/rathbone/\(rathbone.id)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try? encoder.encode(updatedRathbone)

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error updating rathbone:", error)
            }
        }.resume()
    }

    private func downvoteRathbone(_ rathbone: Rathbone) {
        guard let index = rathboneOptions.firstIndex(where: { $0.id == rathbone.id }) else {
            return
        }
        
        var updatedRathbone = rathboneOptions[index]
        
        if updatedRathbone.downvoted {
            updatedRathbone.downvotes -= 1
        } else {
            updatedRathbone.downvotes += 1
            if updatedRathbone.upvoted {
                updatedRathbone.upvotes -= 1
                updatedRathbone.upvoted = false
            }
        }
        
        updatedRathbone.downvoted = !updatedRathbone.downvoted
        
        rathboneOptions[index] = updatedRathbone
        
        guard let url = URL(string: "http://localhost:8000/rathbone/\(rathbone.id)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try? encoder.encode(updatedRathbone)

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error updating rathbone:", error)
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
    
    // Custom section header view for mealType
    private func headerView(for mealType: String) -> some View {
        Text(mealType)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct RathboneDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RathboneDetailsView()
    }
}
