import SwiftUI

struct RathboneDetailsView: View {
    @State private var rathboneOptions: [Rathbone] = []

    var body: some View {
        VStack {
            Text("Rathbone Dining Hall Details")
                .font(.title)
                .padding()

            List(rathboneOptions.indices, id: \.self) { index in
                let rathbone = rathboneOptions[index]
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
}


struct Rathbone: Codable {
    let id: String?
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
