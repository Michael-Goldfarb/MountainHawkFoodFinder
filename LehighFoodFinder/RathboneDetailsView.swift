import SwiftUI

struct RathboneDetailsView: View {
    var body: some View {
        VStack {
            Text("Rathbone Dining Hall Details")
                .font(.title)
                .padding()
            
            // Add more content here to display the details of Rathbone Dining Hall
            
            Spacer()
        }
        .background(Color.white) // Set the background color to white
        .navigationBarTitle("Rathbone Dining Hall", displayMode: .inline)
    }
}

struct RathboneDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RathboneDetailsView()
    }
}
