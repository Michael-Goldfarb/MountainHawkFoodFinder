//
//  LucysCafeDetailsView.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 7/17/23.
//

import SwiftUI

struct LucysCafeDetailsView: View {
    @State private var isHomeViewPresented = false
    @State private var lucysCafeOptions: [LucysCafe] = []
    @State private var hoursOfOperation: [HoursOfOperation] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 3) {
                Spacer()
                Spacer()
                
                Text("Lucy's Cafe")
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
                fetchLucysCafeOptions()
                fetchLucysCafeHoursOfOperation()
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
            ForEach(lucysCafes(for: diningName, courseName: courseName)) { lucysCafe in
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(lucysCafe.menuItemName)")
                        .font(.headline)
                        .lineLimit(nil)
                    
                    Text("Calories: \(lucysCafe.calorieText ?? "N/A")")
                        .font(.subheadline)
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("Dietary Restrictions: \(lucysCafe.allergenNames)")
                            .font(.subheadline)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .fixedSize(horizontal: false, vertical: true)
                .overlay(ratingOverlay(for: lucysCafe))
            }
        }
    }
    
    private func ratingOverlay(for lucysCafe: LucysCafe) -> some View {
        HStack(spacing: 4) {
            Spacer()
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: "star.fill")
                        .foregroundColor(lucysCafe.givenStars >= star ? .yellow : .gray)
                        .font(.system(size: 12))
                        .onTapGesture {
                            rateLucysCafe(lucysCafe, givenStars: star)
                        }
                }
                if lucysCafe.averageStars != 0.0 {
                    Text("Avg.: \(lucysCafe.averageStars, specifier: "%.1f")")
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
        .padding(.top, -10)
        .alignmentGuide(.trailing) { dimension in
            dimension.width // Align the trailing edge of the rating view
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func fetchLucysCafeOptions() {
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
                    let diningPlaces = try decoder.decode([LucysCafe].self, from: data)
                    
                    DispatchQueue.main.async {
                        // Filter the diningPlaces array to only include items with placeName "Lucy's Cafe"
                        self.lucysCafeOptions = diningPlaces.filter { $0.placeName == "Lucy's Cafe" }
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
                print("Loaded in dining places")
            }
        }.resume()
    }

    
    private func fetchLucysCafeHoursOfOperation() {
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
            let uniqueDiningNames = Array(Set(lucysCafeOptions.map({ $0.diningNames }))) // Replace with actual dining names
            let orderedDiningNames = allDiningNames.filter { uniqueDiningNames.contains($0) }
            return orderedDiningNames
        }
        
        private func courseNames(for diningName: String) -> [String] {
            let uniqueCourseNames = Set(lucysCafeOptions.filter({ $0.diningNames == diningName }).map({ $0.courseName }))
            let sortedCourseNames = uniqueCourseNames.sorted()
            return sortedCourseNames
        }
        
        private func lucysCafes(for diningName: String) -> [LucysCafe] {
            return lucysCafeOptions.filter({ $0.diningNames == diningName })
        }
        
        private func lucysCafes(for diningName: String, courseName: String) -> [LucysCafe] {
            let filteredLucysCafes = lucysCafes(for: diningName).filter { $0.courseName == courseName }
            return filteredLucysCafes.sorted { $0.menuItemName < $1.menuItemName } // Sort alphabetically
        }
    
    private func rateLucysCafe(_ lucysCafe: LucysCafe, givenStars: Int) {
        guard let url = URL(string: "http://localhost:8000/dining-places/\(lucysCafe.id)") else {
            return
        }
        struct LucysCafeRatingRequest: Codable {
            let givenStars: Int
        }
        
        let userEmail = GoogleSignInManager.shared.userEmail ?? ""  // Get the userEmail from GoogleSignInManager
        print(userEmail)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set Content-Type header
        request.setValue(userEmail, forHTTPHeaderField: "userEmail") // Set userEmail header
        
        let requestBody = LucysCafeRatingRequest(givenStars: givenStars)
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
                print("Error rating Lucy's Cafe:", error)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("WE GOODY")
                DispatchQueue.main.async {
                    print("FINALLY")
                    if let index = lucysCafeOptions.firstIndex(where: { $0.id == lucysCafe.id }) {
                        lucysCafeOptions[index].givenStars = givenStars
                        // Fetch the updated Lucy's Cafe object
                        fetchUpdatedLucysCafe(lucysCafeId: lucysCafe.id)
                    }
                }
                print("Lucy's Cafe rated successfully")
            } else {
                print("Failed to rate Lucy's Cafe")
            }
        }.resume()
    }
    
    private func fetchUpdatedLucysCafe(lucysCafeId: Int) {
        guard let url = URL(string: "http://localhost:8000/dining-places/\(lucysCafeId)") else {
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
                    let updatedLucysCafe = try decoder.decode(LucysCafe.self, from: data)
                    
                    DispatchQueue.main.async {
                        if let index = lucysCafeOptions.firstIndex(where: { $0.id == lucysCafeId }) {
                            lucysCafeOptions[index].givenStars = updatedLucysCafe.givenStars
                            lucysCafeOptions[index].totalGivenStars = updatedLucysCafe.totalGivenStars
                            lucysCafeOptions[index].totalMaxStars = updatedLucysCafe.totalMaxStars
                            lucysCafeOptions[index].averageStars = updatedLucysCafe.averageStars
                        }
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
            }
        }.resume()
    }
    
    private func headerView(for mealType: String) -> some View {
        if let hours = hoursOfOperation(for: "Lucy's Cafe", in: hoursOfOperation) {
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
            if hours.diningHallName == "Lucy's Cafe" &&
                hours.dayOfWeek.contains(Calendar.current.weekdaySymbols[currentDay - 1]) {
                return hours.hours
            }
        }
        return nil
    }
}

struct LucysCafe: Codable, Identifiable {
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

struct LucysCafeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LucysCafeDetailsView()
    }
}
