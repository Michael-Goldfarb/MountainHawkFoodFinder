//
//  HawksNestDetailsView.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 7/17/23.
//

import SwiftUI

struct HawksNestDetailsView: View {
    @State private var hawksNestOptions: [HawksNest] = []
    @State private var isHomeViewPresented = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 3) {
                Spacer()
                Spacer()
                
                Text("Hawks Nest")
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
            .background(Color.brown)
            .navigationBarTitle("", displayMode: .inline)
            .padding(.top, -25)
            .onAppear {
                fetchHawksNestOptions()
                fetchHawksNestHoursOfOperation()
            }
        }
        .edgesIgnoringSafeArea(.all)
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
            .listRowBackground(Color.white) // Set the background color of the Section's rows to white
        }
        .listStyle(GroupedListStyle()) // Add the list style modifier
    }
    
    private func section(for courseName: String, diningName: String) -> some View {
        Section(header: Text(courseName)) {
            ForEach(hawksNests(for: diningName, courseName: courseName)) { hawksNest in
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(hawksNest.menuItemName)")
                        .font(.headline)
                        .lineLimit(nil)
                    
                    Text("Calories: \(hawksNest.calorieText ?? "N/A")")
                        .font(.subheadline)
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("Dietary Restrictions: \(hawksNest.allergenNames)")
                            .font(.subheadline)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .fixedSize(horizontal: false, vertical: true)
                .overlay(ratingOverlay(for: hawksNest))
            }
        }
    }
    
    private func fetchHawksNestOptions() {
        // Your API call implementation for fetching Hawks Nest options
    }
    
    private func fetchHawksNestHoursOfOperation() {
        // Your API call implementation for fetching hours of operation
    }
    
    private var diningNames: [String] {
            let allDiningNames = ["", "", ""] // Replace with actual dining names
            let uniqueDiningNames = Array(Set(hawksNestOptions.map({ $0.diningName }))) // Replace with actual dining names
            let orderedDiningNames = allDiningNames.filter { uniqueDiningNames.contains($0) }
            return orderedDiningNames
        }
        
        private func courseNames(for diningName: String) -> [String] {
            let uniqueCourseNames = Set(hawksNestOptions.filter({ $0.diningName == diningName }).map({ $0.courseName }))
            let sortedCourseNames = uniqueCourseNames.sorted()
            return sortedCourseNames
        }
        
        private func hawksNests(for diningName: String) -> [HawksNest] {
            return hawksNestOptions.filter({ $0.diningName == diningName })
        }
        
        private func hawksNests(for diningName: String, courseName: String) -> [HawksNest] {
            let filteredHawksNests = hawksNests(for: diningName).filter { $0.courseName == courseName }
            return filteredHawksNests.sorted { $0.menuItemName < $1.menuItemName } // Sort alphabetically
        }
    
    private func headerView(for diningName: String) -> some View {
        // Your implementation to get the header view for a dining name
    }
    
    private func hoursOfOperation(for diningName: String) -> String? {
        // Your implementation to get hours of operation for a dining name
    }
}

struct HawksNest: Codable, Identifiable {
    let id: Int
    let diningName: String // Replace with actual property name for the dining name
    let courseName: String
    let menuItemName: String
    let calorieText: String?
    let allergenNames: String
    var givenStars: Int
    var totalGivenStars: Int
    var totalMaxStars: Int
    var averageStars: Double
    
    init(id: Int, diningName: String, courseName: String, menuItemName: String, calorieText: String?, allergenNames: String, givenStars: Int, totalGivenStars: Int, totalMaxStars: Int, averageStars: Double) {
        self.id = id
        self.diningName = diningName
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
    
struct HawksNestDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HawksNestDetailsView()
    }
}
