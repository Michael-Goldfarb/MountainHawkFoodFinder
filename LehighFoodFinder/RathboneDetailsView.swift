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
                                        Text(rathbone.menuItemName)
                                            .font(.headline)
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
}

struct RathboneDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RathboneDetailsView()
    }
}
