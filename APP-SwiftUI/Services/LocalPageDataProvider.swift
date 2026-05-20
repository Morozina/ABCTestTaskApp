import Foundation

struct LocalPageDataProvider: PageDataProvider {

    func loadPages() async throws -> [Page] {
        Self.pages
    }

    private static let pages: [Page] = [
        Page(
            title: "Mountains",
            imageSymbol: "mountain.2.fill",
            gradientStart: GradientColor(red: 0.20, green: 0.40, blue: 0.50),
            gradientEnd: GradientColor(red: 0.35, green: 0.55, blue: 0.45),
            items: [
                ListItem(title: "Mount Everest", subtitle: "Highest peak on Earth", imageSymbol: "triangle.fill"),
                ListItem(title: "Matterhorn", subtitle: "Pyramidal summit in the Alps", imageSymbol: "mountain.2.fill"),
                ListItem(title: "Kilimanjaro", subtitle: "Tanzanian dormant volcano", imageSymbol: "flame.fill"),
                ListItem(title: "Denali", subtitle: "Tallest mountain in North America", imageSymbol: "snowflake"),
                ListItem(title: "Mont Blanc", subtitle: "Highest summit in western Europe", imageSymbol: "mountain.2.fill"),
                ListItem(title: "Fuji", subtitle: "Iconic Japanese volcano", imageSymbol: "triangle.fill"),
                ListItem(title: "Aconcagua", subtitle: "Highest peak in the Americas", imageSymbol: "mountain.2.fill"),
                ListItem(title: "Elbrus", subtitle: "Tallest peak in Europe", imageSymbol: "snowflake"),
            ]
        ),
        Page(
            title: "Forests",
            imageSymbol: "tree.fill",
            gradientStart: GradientColor(red: 0.10, green: 0.35, blue: 0.20),
            gradientEnd: GradientColor(red: 0.30, green: 0.55, blue: 0.30),
            items: [
                ListItem(title: "Amazon Rainforest", subtitle: "Largest tropical forest", imageSymbol: "leaf.fill"),
                ListItem(title: "Black Forest", subtitle: "Dense woodland in Germany", imageSymbol: "tree.fill"),
                ListItem(title: "Daintree", subtitle: "Ancient Australian rainforest", imageSymbol: "leaf.fill"),
                ListItem(title: "Białowieża", subtitle: "Primeval European forest", imageSymbol: "tree.fill"),
                ListItem(title: "Sequoia Grove", subtitle: "Giant Californian trees", imageSymbol: "tree.fill"),
                ListItem(title: "Taiga", subtitle: "Boreal coniferous biome", imageSymbol: "snowflake"),
                ListItem(title: "Congo Basin", subtitle: "Second largest rainforest", imageSymbol: "leaf.fill"),
                ListItem(title: "Yakushima", subtitle: "Cedar forest on a Japanese isle", imageSymbol: "tree.fill"),
                ListItem(title: "Tongass", subtitle: "Largest temperate rainforest", imageSymbol: "leaf.fill"),
                ListItem(title: "Sundarbans", subtitle: "Mangrove forest delta", imageSymbol: "drop.fill"),
            ]
        ),
        Page(
            title: "Rivers",
            imageSymbol: "water.waves",
            gradientStart: GradientColor(red: 0.15, green: 0.40, blue: 0.55),
            gradientEnd: GradientColor(red: 0.25, green: 0.55, blue: 0.65),
            items: [
                ListItem(title: "Amazon", subtitle: "Largest river by discharge", imageSymbol: "water.waves"),
                ListItem(title: "Nile", subtitle: "Longest river in Africa", imageSymbol: "drop.fill"),
                ListItem(title: "Yangtze", subtitle: "Longest river in Asia", imageSymbol: "water.waves"),
                ListItem(title: "Mississippi", subtitle: "Major North American waterway", imageSymbol: "drop.fill"),
                ListItem(title: "Danube", subtitle: "Second longest in Europe", imageSymbol: "water.waves"),
                ListItem(title: "Mekong", subtitle: "Southeast Asian river", imageSymbol: "drop.fill"),
                ListItem(title: "Volga", subtitle: "Longest river in Europe", imageSymbol: "water.waves"),
                ListItem(title: "Ganges", subtitle: "Sacred river of India", imageSymbol: "drop.fill"),
                ListItem(title: "Rhine", subtitle: "Central European river", imageSymbol: "water.waves"),
            ]
        ),
        Page(
            title: "Oceans",
            imageSymbol: "drop.fill",
            gradientStart: GradientColor(red: 0.05, green: 0.25, blue: 0.45),
            gradientEnd: GradientColor(red: 0.20, green: 0.45, blue: 0.65),
            items: [
                ListItem(title: "Pacific Ocean", subtitle: "Largest body of water", imageSymbol: "drop.fill"),
                ListItem(title: "Atlantic Ocean", subtitle: "Connects the Americas to Europe", imageSymbol: "water.waves"),
                ListItem(title: "Indian Ocean", subtitle: "Warmest of the world's oceans", imageSymbol: "drop.fill"),
                ListItem(title: "Arctic Ocean", subtitle: "Smallest and shallowest", imageSymbol: "snowflake"),
                ListItem(title: "Southern Ocean", subtitle: "Surrounds Antarctica", imageSymbol: "snowflake"),
                ListItem(title: "Caribbean Sea", subtitle: "Tropical Atlantic basin", imageSymbol: "sun.max.fill"),
                ListItem(title: "Mediterranean", subtitle: "Cradle of civilization", imageSymbol: "water.waves"),
            ]
        ),
        Page(
            title: "Deserts",
            imageSymbol: "sun.max.fill",
            gradientStart: GradientColor(red: 0.70, green: 0.55, blue: 0.30),
            gradientEnd: GradientColor(red: 0.85, green: 0.70, blue: 0.40),
            items: [
                ListItem(title: "Sahara", subtitle: "Largest hot desert", imageSymbol: "sun.max.fill"),
                ListItem(title: "Gobi", subtitle: "Cold desert in Central Asia", imageSymbol: "wind"),
                ListItem(title: "Kalahari", subtitle: "Southern African basin", imageSymbol: "sun.max.fill"),
                ListItem(title: "Atacama", subtitle: "Driest non-polar desert", imageSymbol: "sun.max.fill"),
                ListItem(title: "Mojave", subtitle: "Iconic American desert", imageSymbol: "sun.max.fill"),
                ListItem(title: "Patagonian", subtitle: "Largest desert in the Americas", imageSymbol: "wind"),
                ListItem(title: "Karakum", subtitle: "Central Asian sandy desert", imageSymbol: "sun.max.fill"),
                ListItem(title: "Namib", subtitle: "Ancient coastal desert", imageSymbol: "wind"),
            ]
        ),
    ]
}
