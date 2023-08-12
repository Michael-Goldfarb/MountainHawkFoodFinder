//
//  HillsideCafeDetailsView.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 7/17/23.
//

import SwiftUI

struct HillsideCafeDetailsView: View {
    @State private var isHomeViewPresented = false
    @State private var hillsideCafeOptions: [HillsideCafe] = []
    @State private var hoursOfOperation: [HoursOfOperation] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 3) {
                Spacer()
                Spacer()
                
                Text("Hillside Cafe")
                    .font(.system(size: 24, weight: .bold))
                
                Text("Click on the Map to Go Back to the Map")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    isHomeViewPresented = true
                }) {
                    Image("AppleMaps")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 33, height: 33)
                }
                .fullScreenCover(isPresented: $isHomeViewPresented) {
                    TabSelectorView()
                        .environmentObject(NavigationState()) // Provide the NavigationState environment object
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                listSection
            }
            .background(Color.white)
            .navigationBarTitle("", displayMode: .inline)
            .padding(.top, -25)
            .onAppear {
                fetchHillsideCafeOptions()
                fetchHillsideCafeHoursOfOperation()
            }
        }
    }

    
    private var listSection: some View {
        List {
            ForEach(diningNames, id: \.self) { diningName in
                Section(header: headerView(for: diningName)) {
                    ForEach(courseNames(for: diningName), id: \.self) { courseName in
                        section(for: courseName, diningName: diningName)
                    }
                }
            }
        }
    }
    
    private func section(for courseName: String, diningName: String) -> some View {
        Section(header: Text(courseName)) {
            ForEach(hillsideCafes(for: diningName, courseName: courseName)) { hillsideCafe in
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(hillsideCafe.menuItemName)")
                        .font(.headline)
                        .lineLimit(nil)
                    
                    if let calories = hillsideCafe.calorieText, !calories.isEmpty {
                        Text("Calories: \(calories)")
                            .font(.subheadline)
                    }
                    
                    if let price = hillsideCafe.price, !price.isEmpty {
                        Text("Price: \(price)")
                            .font(.subheadline)
                    }
                    
                    if !hillsideCafe.allergenNames.isEmpty {
                        Text("Allergens: \(hillsideCafe.allergenNames)")
                            .font(.subheadline)
                    }
                    
                    if let moreInfo = hillsideCafe.moreInformation, !moreInfo.isEmpty {
                        Text("More Information: \(moreInfo)")
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .fixedSize(horizontal: false, vertical: true)
                .overlay(ratingOverlay(for: hillsideCafe))
            }
        }
    }


    
    private func ratingOverlay(for hillsideCafe: HillsideCafe) -> some View {
        if ["DELI BREAKFAST SANDWICHES [AVAILABLE ALL DAY]", "STARBUCKS REFRESHERS ICED BEVERAGES (CONTAIN CAFFEINE)"].contains(hillsideCafe.courseName) {
            return AnyView(
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) { // Align stars to the right
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: "star.fill")
                                    .foregroundColor(hillsideCafe.givenStars >= star ? .yellow : .gray)
                                    .font(.system(size: 12))
                                    .onTapGesture {
                                        rateHillsideCafe(hillsideCafe, givenStars: star)
                                    }
                            }
                            if hillsideCafe.averageStars != 0.0 {
                                Text("Avg.: \(hillsideCafe.averageStars, specifier: "%.1f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Avg.: N/A")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(height: 20)
                        .padding(.trailing, 16)
                        .alignmentGuide(.lastTextBaseline) { dimension in
                            dimension[.bottom]
                        }
                    }
                }
                .padding(.bottom, 10) // Adjust downward padding
                .padding(.trailing, 16) // Adjust right padding
                .fixedSize(horizontal: false, vertical: true)
            )
        } else {
            return AnyView(EmptyView()) // Return an empty view for other course names
        }
    }


    
    private func fetchHillsideCafeOptions() {
        guard let url = URL(string: "http://localhost:8000/dining-places") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                URLSession.shared.finishTasksAndInvalidate()
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let diningPlaces = try decoder.decode([HillsideCafe].self, from: data)
                    
                    DispatchQueue.main.async {
                        // Filter the diningPlaces array to only include items with placeName "Hillside Cafe"
                        self.hillsideCafeOptions = diningPlaces.filter { $0.placeName == "Hillside Cafe" }
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
                print("Loaded in dining places")
            }
        }.resume()
    }

    
    private func fetchHillsideCafeHoursOfOperation() {
        guard let url = URL(string: "http://localhost:8000/hours-of-operation") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                URLSession.shared.finishTasksAndInvalidate()
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let hoursOfOperation = try decoder.decode([HoursOfOperation].self, from: data)
                    DispatchQueue.main.async {
                        self.hoursOfOperation = hoursOfOperation
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
                print("Loaded in hours of operation")
            }
        }.resume()
    }
    
    private var diningNames: [String] {
            let allDiningNames = [""]
            let uniqueDiningNames = Array(Set(hillsideCafeOptions.map({ $0.diningNames }))) // Replace with actual dining names
            let orderedDiningNames = allDiningNames.filter { uniqueDiningNames.contains($0) }
            return orderedDiningNames
        }
        
        private func courseNames(for diningName: String) -> [String] {
            let uniqueCourseNames = Set(hillsideCafeOptions.filter({ $0.diningNames == diningName }).map({ $0.courseName }))
            let sortedCourseNames = uniqueCourseNames.sorted()
            return sortedCourseNames
        }
        
        private func hillsideCafes(for diningName: String) -> [HillsideCafe] {
            return hillsideCafeOptions.filter({ $0.diningNames == diningName })
        }
        
        private func hillsideCafes(for diningName: String, courseName: String) -> [HillsideCafe] {
            let filteredHillsideCafes = hillsideCafes(for: diningName).filter { $0.courseName == courseName }
            return filteredHillsideCafes.sorted { $0.menuItemName < $1.menuItemName } // Sort alphabetically
        }
    
    private func rateHillsideCafe(_ hillsideCafe: HillsideCafe, givenStars: Int) {
        guard let url = URL(string: "http://localhost:8000/dining-places/\(hillsideCafe.id)") else {
            return
        }
        struct HillsideCafeRatingRequest: Codable {
            let givenStars: Int
        }
        
        let userEmail = GoogleSignInManager.shared.userEmail ?? ""  // Get the userEmail from GoogleSignInManager
        print(userEmail)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set Content-Type header
        request.setValue(userEmail, forHTTPHeaderField: "userEmail") // Set userEmail header
        
        let requestBody = HillsideCafeRatingRequest(givenStars: givenStars)
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            print("Error creating JSON data:", error)
            return
        }
        print(requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                URLSession.shared.finishTasksAndInvalidate()
            }
            
            if let error = error {
                print("Error rating Hillside Cafe:", error)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("WE GOODY")
                DispatchQueue.main.async {
                    print("FINALLY")
                    if let index = hillsideCafeOptions.firstIndex(where: { $0.id == hillsideCafe.id }) {
                        hillsideCafeOptions[index].givenStars = givenStars
                        // Fetch the updated Hillside Cafe object
                        fetchUpdatedHillsideCafe(hillsideCafeId: hillsideCafe.id)
                    }
                }
                print("Hillside Cafe rated successfully")
            } else {
                print("Failed to rate Hillside Cafe")
            }
        }.resume()
    }
    
    private func fetchUpdatedHillsideCafe(hillsideCafeId: Int) {
        guard let url = URL(string: "http://localhost:8000/dining-places/\(hillsideCafeId)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                URLSession.shared.finishTasksAndInvalidate()
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let updatedHillsideCafe = try decoder.decode(HillsideCafe.self, from: data)
                    
                    DispatchQueue.main.async {
                        if let index = hillsideCafeOptions.firstIndex(where: { $0.id == hillsideCafeId }) {
                            hillsideCafeOptions[index].givenStars = updatedHillsideCafe.givenStars
                            hillsideCafeOptions[index].totalGivenStars = updatedHillsideCafe.totalGivenStars
                            hillsideCafeOptions[index].totalMaxStars = updatedHillsideCafe.totalMaxStars
                            hillsideCafeOptions[index].averageStars = updatedHillsideCafe.averageStars
                        }
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
            }
        }.resume()
    }
    
    private func headerView(for mealType: String) -> some View {
        if let hours = hoursOfOperation(for: "Hillside Cafe", in: hoursOfOperation) {
            return Text("\(mealType.capitalized) (\(hours))")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            return Text(mealType.capitalized)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private func hoursOfOperation(for diningName: String, in hoursOfOperation: [HoursOfOperation]) -> String? {
        let currentDay = Calendar.current.component(.weekday, from: Date())
        for hours in hoursOfOperation {
            if hours.diningHallName == "Hillside Cafe" &&
                hours.dayOfWeek.contains(Calendar.current.weekdaySymbols[currentDay - 1]) {
                return hours.hours
            }
        }
        return nil
    }
}

struct HillsideCafe: Codable, Identifiable {
    let id: Int
    let placeName: String
    let diningNames: String
    let courseName: String
    let menuItemName: String
    let calorieText: String?
    let allergenNames: String
    var givenStars: Int
    var totalGivenStars: Int
    var totalMaxStars: Int
    var averageStars: Double
    let price: String?
    let moreInformation: String?
    
    init(id: Int, placeName: String, diningNames: String, courseName: String, menuItemName: String, calorieText: String?, allergenNames: String, givenStars: Int, totalGivenStars: Int, totalMaxStars: Int, averageStars: Double, price: String?, moreInformation: String?) {
        self.id = id
        self.placeName = placeName
        self.diningNames = diningNames
        self.courseName = courseName
        self.menuItemName = menuItemName
        self.calorieText = calorieText
        self.allergenNames = allergenNames
        self.givenStars = givenStars
        self.totalGivenStars = totalGivenStars
        self.totalMaxStars = totalMaxStars
        self.averageStars = averageStars
        self.price = price
        self.moreInformation = moreInformation
    }
}

struct HillsideCafeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HillsideCafeDetailsView()
    }
}
