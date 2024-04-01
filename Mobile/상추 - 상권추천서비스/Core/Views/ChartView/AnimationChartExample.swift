import SwiftUI
import Charts

struct SiteView: Identifiable {
    let id = UUID()
    var hour: String
    var views: Double
    var animate = false  // 애니메이션 상태 제어 프로퍼티 추가
}

let sample_analytics: [SiteView] = [
    SiteView(hour: "9AM", views: 120),
    SiteView(hour: "10AM", views: 150),
    SiteView(hour: "11AM", views: 90),
    SiteView(hour: "12PM", views: 200),
    SiteView(hour: "1PM", views: 170),
]

struct AnimationChartExample: View {
    @State var sampleAnalytics: [SiteView] = sample_analytics
    @State var currentTab: String = "7 Days"
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Views")
                            .fontWeight(.semibold)
                        Picker("", selection: $currentTab) {
                            Text("7 Days").tag("7 Days")
                            Text("Week").tag("Week")
                            Text("Month").tag("Month")
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    let totalValue = sampleAnalytics.reduce(0.0) { partialResult, item in
                        item.views + partialResult
                    }
                    Text(totalValue.stringFormat)
                        .font(.largeTitle.bold())
                    AnimatedChart()
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationTitle("Swift Charts")
            .onChange(of: currentTab) { newValue in
                sampleAnalytics = sample_analytics
                if newValue != "7 Days" {
                    for (index, _) in sampleAnalytics.enumerated() {
                        sampleAnalytics[index].views = .random(in : 1500...10000)
                    }
                }
                animateGraph(fromChange: true)
            }
        }
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        let max = sampleAnalytics.max { item1, item2 in
            item2.views > item1.views
        }?.views ?? 0
        
        Chart {
            ForEach(sampleAnalytics) { item in
                BarMark(
                    x: .value("Hour", item.hour),
                    y: .value("Views", item.animate ? item.views : 0)
                )
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom))
            }
        }
        .chartYScale(domain: 0...(max + 5000))
        .frame(height: 250)
        .onAppear {
            animateGraph()
        }
    }
    
    func animateGraph(fromChange: Bool = false) {
        for (index, _) in sampleAnalytics.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .interactiveSpring(response: 0.8) : .interactiveSpring(response : 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    sampleAnalytics[index].animate = true
                }
            }
        }
    }
}

extension Double {
    var stringFormat: String {
        if self >= 10000 && self < 999999 {
            return String(format: "%.1fK", self / 1000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999 {
            return String(format: "%.1fM", self / 1000000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.0f", self)
    }
}
