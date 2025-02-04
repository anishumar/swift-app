import SwiftUI

struct EggFact: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
}

struct EggFactsView: View {
    let facts: [EggFact] = [
        EggFact(title: "High-Quality Protein", detail: "Eggs provide all essential amino acids and are considered a complete protein."),
        EggFact(title: "Rich in Vitamins", detail: "Eggs are loaded with vitamins such as vitamin D, B12, and riboflavin, essential for energy and immunity."),
        EggFact(title: "Good for Eye Health", detail: "Eggs contain lutein and zeaxanthin, two antioxidants that help prevent cataracts and age-related macular degeneration."),
        EggFact(title: "Boosts Brain Function", detail: "Eggs are rich in choline, which is vital for brain development and memory function."),
        EggFact(title: "Supports Weight Loss", detail: "Eggs help you feel full longer, reducing calorie intake and promoting weight loss."),
        EggFact(title: "Promotes Heart Health", detail: "Eggs increase good cholesterol (HDL) levels, which can lower the risk of heart disease.")
    ]
    
    @State private var expandedFactID: UUID?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    Text("Egg Facts & Health Benefits")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                    
                    ForEach(facts) { fact in
                        FactCard(fact: fact, isExpanded: expandedFactID == fact.id)
                            .onTapGesture {
                                withAnimation {
                                    if expandedFactID == fact.id {
                                        expandedFactID = nil
                                    } else {
                                        expandedFactID = fact.id
                                    }
                                }
                            }
                    }
                }
                .padding()
            }
            .background(Color.white.edgesIgnoringSafeArea(.all)) // Dark mode background for contrast
            .navigationTitle("Egg Facts")
        }
    }
}

struct FactCard: View {
    let fact: EggFact
    var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(fact.title)
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .padding(.top, 8)
            
            if isExpanded {
                Text(fact.detail)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .transition(.opacity)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow)
        .cornerRadius(12)
        .shadow(radius: 5)
        .animation(.easeInOut, value: isExpanded)
    }
}

struct EggFactsView_Previews: PreviewProvider {
    static var previews: some View {
        EggFactsView()
    }
}
