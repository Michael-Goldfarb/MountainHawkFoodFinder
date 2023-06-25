//
//  FavouriteNumberView.swift
//  PlanetPicks IOS2
//
//  Created by Michael Goldfarb on 6/10/23.
//


import SwiftUI
import Combine
import FirebaseAnalytics
import FirebaseAnalyticsSwift

class HomeViewModel: ObservableObject {
  @Published var betAmount: Double = 10.0

  private var defaults = UserDefaults.standard
  private let betAmountKey = "betAmount"
  private var cancellables = Set<AnyCancellable>()

  init() {
    if let amount = defaults.object(forKey: betAmountKey) as? Double {
      betAmount = amount
    }
    $betAmount
      .sink { amount in
        self.defaults.set(amount, forKey: self.betAmountKey)
      }
      .store(in: &cancellables)
  }
}

struct HomeView: View {
  @StateObject var viewModel = HomeViewModel()

  var body: some View {
    VStack {
      Text("Place your bet")
        .font(.title)
        .multilineTextAlignment(.center)
      Spacer()
      Stepper(value: $viewModel.betAmount, in: 0...100, step: 10) {
        Text("$\(viewModel.betAmount)")
      }
    }
    .frame(maxHeight: 150)
    .foregroundColor(.white)
    .padding()
    #if os(iOS)
    .background(Color(UIColor.systemBlue))
    #endif
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .padding()
    .shadow(radius: 8)
    .navigationTitle("Sports Betting")
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      HomeView()
    }
  }
}
