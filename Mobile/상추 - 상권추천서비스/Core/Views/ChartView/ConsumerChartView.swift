//
//  ConsumerChartView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/25/24.
//

import SwiftUI
import Charts

// 사용자 인터페이스를 정의하는 ContentView.swift 파일입니다.
// 애플리케이션의 뷰를 구성하고 네트워크 요청을 통해 차트 데이터를 로드합니다.

let MainColors: [Color] = [Color(hex: "50B792"),Color(hex: "3B7777")]

enum ConsumerEndpoints: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case 분기별유동인구 = "floatingDataByQuarter"
    case 요일별유동인구 = "floatingDataByDay"
    case 시간대별유동인구 = "floatingDataByTime"
    case 연령별유동인구 = "floatingDataByAge"
    case 분기별상주인구 = "residentDataByQuarter"
    case 성연령별상주인구 = "residentByGenderAndAge"
    case 분기별직장인구 = "workingDataByQuarter"
    case 성연령별직장인구 = "workingDataByGenderAndAge"

    var englishEndpoint: String {
        switch self {
            case .분기별유동인구:
                return "/consumer/graph/floating/quarterly-trends"
            case .요일별유동인구:
                return "/consumer/graph/floating/day"
            case .시간대별유동인구:
                return "/consumer/graph/floating/time"
            case .연령별유동인구:
                return "/consumer/graph/floating/age"
            case .분기별상주인구:
                return "/consumer/graph/resident/quarterly-trends"
            case .성연령별상주인구:
                return "/consumer/graph/resident/gender-age"
            case .분기별직장인구:
                return "/consumer/graph/working/quarterly-trends"
            case .성연령별직장인구:
                return "/consumer/graph/working/gender-age"
        }
    } // end of englishEndpoint
    
    var displayName: String {
            switch self {
                case .분기별유동인구:
                    return "분기별유동인구"
                case .요일별유동인구:
                    return "요일별유동인구"
                case .시간대별유동인구:
                    return "시간대별유동인구"
                case .연령별유동인구:
                    return "연령별유동인구"
                case .분기별상주인구:
                    return "분기별상주인구"
                case .성연령별상주인구:
                    return "성/연령별상주인구"
                case .분기별직장인구:
                    return "분기별직장인구"
                case .성연령별직장인구:
                    return "성/연령별직장인구"
            }
        } // end of displayName
    
}

// 왼쪽에서 오른쪽
//struct QuarterlyFloatingChartView: View {
//    var chartData: [ConsumerModel.ChartData]
//    @State private var presentedData: [ConsumerModel.ChartData] = []
//
//    var body: some View {
//        Chart {
//            ForEach(presentedData) { dataPoint in
//                BarMark(
//                    x: .value("Category", dataPoint.label),
//                    y: .value("Value", dataPoint.value)
//                )
//                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom))
//                .opacity(dataPoint.animate ? 1 : 0) // 각 데이터 항목의 animate 속성에 따라 투명도 적용
//            }
//        }
//        .chartYScale(domain: 0...(chartData.max(by: { $0.value < $1.value })?.value ?? 0 + 5000))
//        .frame(height: 250)
//        .onAppear {
//            animateGraph()
//        }
//    }
//    
//    func animateGraph() {
//        presentedData = chartData.map { var data = $0; data.animate = false; return data }
//
//        for (index, dataPoint) in presentedData.enumerated() {
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
//                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
//                    presentedData[index].animate = true
//                }
//            }
//        }
//    }
//}

// 아래에서 위 // 분기별 유동인구
struct QuarterlyFloatingChartView: View {
    var chartData: [ConsumerModel.ChartData]
    @State private var presentedData: [ConsumerModel.ChartData] = []
    @State private var animate: Bool = false

    var body: some View {
        HStack {
            Spacer() // HStack의 왼쪽 공간을 모두 차지하여, 오른쪽으로 밀어냅니다.
            Text("(단위 : 만명)")
                .font(.caption2)
                .foregroundStyle(Color.customgray)
                .padding(.trailing) // 오른쪽 끝에서 약간 떨어지도록 패딩 추가
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
        Chart {
            ForEach(presentedData) { dataPoint in
                BarMark(
                    x: .value("Category", dataPoint.label),
                    y: .value("Value", animate ? dataPoint.value / 10000 : 0) // 여기서 애니메이션 적용
                )
                .cornerRadius(5)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                .annotation(position: .top) {
                    Text("\(dataPoint.value / 10000, specifier: "%.0f")")
                        .font(.caption2.bold())
                }
            }
        }
        .frame(height: 300)
        .chartXAxis {
            AxisMarks(preset: .aligned, position: .bottom) { value in
                if let category = value.as(String.self) {
                    AxisValueLabel(category, centered: true)
                        .font(.caption2.width(.compressed))
                }
            }
        }
        .onAppear {
            presentedData = chartData // 모든 데이터를 presentedData에 할당
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = true // 애니메이션 시작
                }
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = false // 애니메이션 시작
                }
            }
        }
    }
}

// 요일별 유동인구 차트 뷰
struct DayFloatingChartView: View {
    var chartData: [ConsumerModel.ChartData]
    @State private var presentedData: [ConsumerModel.ChartData] = []
    @State private var animate: Bool = false

    var body: some View {
        HStack {
            Spacer()
            Text("(단위 : 명)")
                .font(.caption2)
                .foregroundStyle(Color.customgray)
                .padding(.trailing)
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
        Chart {
            ForEach(presentedData) { dataPoint in
                BarMark(
                    x: .value("Category", dataPoint.label),
                    y: .value("Value", animate ? dataPoint.value / 10000  : 0)
                )
                .cornerRadius(5)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                .annotation(position: .top, alignment: .center) {
                    Text("\(dataPoint.value, specifier: "%.0f")")
                        .font(.caption2)
                        .foregroundColor(Color.black)
                        .lineLimit(nil) // 라벨에 대한 줄바꿈 제한을 없애 줄바꿈을 허용
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 4)
                }
            }
        }
        .chartXAxis {
            AxisMarks(preset: .aligned, position: .bottom) { value in
                if let category = value.as(String.self) {
                    AxisValueLabel(category, centered: true)
                        .font(.caption2.width(.compressed))
                }
            }
        }
        .frame(height: 300)
        .onAppear {
            presentedData = chartData // 모든 데이터를 presentedData에 할당
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = true // 애니메이션 시작
                }
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = false // 애니메이션 시작
                }
            }
        }
    }
}

// 시간대별 유동인구 차트 뷰
struct TimeFloatingChartView: View {
    var chartData: [ConsumerModel.ChartData]
    @State private var presentedData: [ConsumerModel.ChartData] = []
    @State private var animate: Bool = false

    var body: some View {
        HStack {
            Spacer()
            Text("(단위 : 명)")
                .font(.caption2)
                .foregroundStyle(Color.customgray)
                .padding(.trailing)
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
        Chart {
            ForEach(presentedData) { dataPoint in
                BarMark(
                    x: .value("Category", dataPoint.label),
                    y: .value("Value", animate ? dataPoint.value : 0) // 여기서 애니메이션 적용
                )
                .cornerRadius(5)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                .annotation(position: .top, alignment: .center) {
                    Text("\(dataPoint.value, specifier: "%.0f")")
                        .font(.caption2)
                        .foregroundColor(Color.black)
                        .lineLimit(nil) // 라벨에 대한 줄바꿈 제한을 없애 줄바꿈을 허용
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .chartXAxis {
            AxisMarks(preset: .aligned, position: .bottom) { value in
                if let category = value.as(String.self) {
                    AxisValueLabel(category, centered: true)
                        .font(.caption2.width(.compressed))
                }
            }
        }
        .frame(height: 300)
        .onAppear {
            presentedData = chartData // 모든 데이터를 presentedData에 할당
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = true // 애니메이션 시작
                }
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = false // 애니메이션 시작
                }
            }
        }
    }
}

// 연령별 유동인구 차트 뷰
struct AgeFloatingChartView: View {
    var chartData: [ConsumerModel.ChartData]
    @State private var presentedData: [ConsumerModel.ChartData] = []
    @State private var animate: Bool = false

    var body: some View {
        HStack {
            Spacer()
            Text("(단위 : 명)")
                .font(.caption2)
                .foregroundStyle(Color.customgray)
                .padding(.trailing)
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
        Chart {
            ForEach(presentedData) { dataPoint in
                BarMark(
                    x: .value("Category", dataPoint.label),
                    y: .value("Value", animate ? dataPoint.value : 0) // 여기서 애니메이션 적용
                )
                .cornerRadius(5)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                .annotation(position: .top, alignment: .center) {
                    Text("\(dataPoint.value, specifier: "%.0f")")
                        .font(.caption2)
                        .foregroundColor(Color.black)
                        .fontWidth(.compressed)
                        .lineLimit(nil) // 라벨에 대한 줄바꿈 제한을 없애 줄바꿈을 허용
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .chartXAxis {
            AxisMarks(preset: .aligned, position: .bottom) { value in
                if let category = value.as(String.self) {
                    AxisValueLabel(category, centered: true)
                        .font(.caption2.width(.compressed))
                }
            }
        }
        .frame(height: 300)
        .onAppear {
            presentedData = chartData // 모든 데이터를 presentedData에 할당
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = true // 애니메이션 시작
                }
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = false // 애니메이션 시작
                }
            }
        }
    }
}

// 분기별 상주인구 차트 뷰
struct QuarterlyResidentChartView: View {
    var chartData: [ConsumerModel.ChartData]
    @State private var presentedData: [ConsumerModel.ChartData] = []
    @State private var animate: Bool = false

    var body: some View {
        HStack {
            Spacer()
            Text("(단위 : 명)")
                .font(.caption2)
                .foregroundStyle(Color.customgray)
                .padding(.trailing)
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
        Chart {
            ForEach(presentedData) { dataPoint in
                BarMark(
                    x: .value("Category", dataPoint.label),
                    y: .value("Value", animate ? dataPoint.value : 0) // 여기서 애니메이션 적용
                )
                .cornerRadius(5)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                .annotation(position: .top, alignment: .center) {
                    Text("\(dataPoint.value, specifier: "%.0f")")
                        .font(.caption2)
                        .foregroundColor(Color.black)
                        .lineLimit(nil) // 라벨에 대한 줄바꿈 제한을 없애 줄바꿈을 허용
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .chartXAxis {
            AxisMarks(preset: .aligned, position: .bottom) { value in
                if let category = value.as(String.self) {
                    AxisValueLabel(category, centered: true)
                        .font(.caption2.width(.compressed))
                }
            }
        }
        .frame(height: 300)
        .onAppear {
            presentedData = chartData // 모든 데이터를 presentedData에 할당
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = true // 애니메이션 시작
                }
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = false // 애니메이션 시작
                }
            }
        }
    }
}

// 성/연령별 상주인구 차트 뷰
struct GenderAgeResidentChartView: View {
    var chartData: [ConsumerModel.ChartData]
    @State private var presentedData: [ConsumerModel.ChartData] = []
    @State private var animate: Bool = false
    @State private var selectedGender: String = "남성" // 성별 선택을 위한 상태

    var body: some View {
        VStack {
            // 성별 선택을 위한 Picker
            Picker("성별", selection: $selectedGender) {
                Text("남성").tag("남성")
                Text("여성").tag("여성")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Chart {
                ForEach(presentedData.filter { $0.label.contains(selectedGender) }) { dataPoint in
                    BarMark(
                        x: .value("Category", dataPoint.label),
                        y: .value("Value", animate ? dataPoint.value : 0) // 여기서 애니메이션 적용
                    )
                    .cornerRadius(5)
                    .foregroundStyle(selectedGender == "남성" ? Color.blue : Color.red)
                    .annotation(position: .top, alignment: .center) {
                        Text("\(dataPoint.value, specifier: "%.0f")")
                            .font(.caption2)
                            .foregroundColor(Color.black)
                            .lineLimit(nil) // 라벨에 대한 줄바꿈 제한을 없애 줄바꿈을 허용
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, position: .bottom) { value in
                    if let category = value.as(String.self) {
                        AxisValueLabel(category, centered: true)
                            .font(.caption2.width(.compressed))
                    }
                }
            }
            .frame(height: 250)
            .onChange(of: selectedGender) { _ in
                // 성별이 변경될 때마다 차트를 업데이트합니다.
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = false // 애니메이션 초기화
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        animate = true // 애니메이션 재시작
                    }
                }
            }
        }
        .onAppear {
            presentedData = chartData // 모든 데이터를 presentedData에 할당
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = true // 애니메이션 시작
                }
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = false // 애니메이션 종료
                }
            }
        }
    }
}


// 분기별 직장인구 차트 뷰
struct QuarterlyWorkingChartView: View {
    var chartData: [ConsumerModel.ChartData]
    @State private var presentedData: [ConsumerModel.ChartData] = []
    @State private var animate: Bool = false

    var body: some View {
        Chart {
            ForEach(presentedData) { dataPoint in
                BarMark(
                    x: .value("Category", dataPoint.label),
                    y: .value("Value", animate ? dataPoint.value : 0) // 여기서 애니메이션 적용
                )
                .cornerRadius(5)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                .annotation(position: .top, alignment: .center) {
                    Text("\(dataPoint.value, specifier: "%.0f")")
                        .font(.caption2)
                        .foregroundColor(Color.black)
                        .lineLimit(nil) // 라벨에 대한 줄바꿈 제한을 없애 줄바꿈을 허용
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .chartXAxis {
            AxisMarks(preset: .aligned, position: .bottom) { value in
                if let category = value.as(String.self) {
                    AxisValueLabel(category, centered: true)
                        .font(.caption2.width(.compressed))
                }
            }
        }
        .frame(height: 300)
        .onAppear {
            presentedData = chartData // 모든 데이터를 presentedData에 할당
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = true // 애니메이션 시작
                }
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = false // 애니메이션 시작
                }
            }
        }
    }
}

// 성/연령별 직장인구 차트 뷰
struct GenderAgeWorkingChartView: View {
    var chartData: [ConsumerModel.ChartData]
    @State private var presentedData: [ConsumerModel.ChartData] = []
    @State private var animate: Bool = false
    @State private var selectedGender: String = "남성" // 성별 선택을 위한 상태

    var body: some View {
        VStack {
            // 성별 선택을 위한 Picker
            Picker("성별", selection: $selectedGender) {
                Text("남성").tag("남성")
                Text("여성").tag("여성")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Chart {
                ForEach(presentedData.filter { $0.label.contains(selectedGender) }) { dataPoint in
                    BarMark(
                        x: .value("Category", dataPoint.label),
                        y: .value("Value", animate ? dataPoint.value : 0)
                    )
                    .cornerRadius(5)
                    .foregroundStyle(selectedGender == "남성" ? Color.blue : Color.red)
                    .annotation(position: .top, alignment: .center) {
                        Text("\(dataPoint.value, specifier: "%.0f")")
                            .font(.caption2)
                            .foregroundColor(Color.black)
                            .lineLimit(nil) // 라벨에 대한 줄바꿈 제한을 없애 줄바꿈을 허용
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, position: .bottom) { value in
                    if let category = value.as(String.self) {
                        AxisValueLabel(category, centered: true)
                            .font(.caption2.width(.compressed))
                    }
                }
            }
            .frame(height: 250)
            .onChange(of: selectedGender) { newValue in
                // 성별이 변경될 때마다 차트를 업데이트합니다.
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = false // 애니메이션 초기화
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        animate = true // 애니메이션 재시작
                    }
                }
            }
        }
        .onAppear {
            presentedData = chartData // 모든 데이터를 presentedData에 할당
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = true // 애니메이션 시작
                }
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animate = false // 애니메이션 종료
                }
            }
        }
    }
}

struct ConsumerChartView: View {
    @State private var isLoading = true
    // 차트 데이터들이 들어가 있는 배열 상태값
    @State private var chartDataSets: [[ConsumerModel.ChartData]] = Array(repeating: [], count: ConsumerEndpoints.allCases.count)
    @State var cdCode: String = ""
    
    var body: some View {
            VStack (alignment: .leading) {
                if chartDataSets.isEmpty {
                    Text("해당 데이터가 없습니다.")
                        .padding()
                } else {
                    TabView {
                        if isLoading {
                            Text("상권 데이터를 가져오는 중입니다.")
                        }
                        else {
                             Group {
                                // 분기별 유동인구 차트 표시
                                VStack {
                                    if !chartDataSets[0].isEmpty {
                                        Text("분기별 유동인구")
                                            .font(.title2).bold()
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                                        QuarterlyFloatingChartView(chartData: chartDataSets[0])
                                    }
                                }
                                // 요일별 유동인구 차트 표시
                                VStack {
                                    if !chartDataSets[1].isEmpty {
                                        Text("요일별 유동인구")
                                            .font(.title2).bold()
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                                        DayFloatingChartView(chartData: chartDataSets[1])
                                    }
                                }
                                // 시간대별 유동인구 차트 표시
                                VStack {
                                    if !chartDataSets[2].isEmpty {
                                        Text("시간대별 유동인구")
                                            .font(.title2).bold()
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                                        TimeFloatingChartView(chartData: chartDataSets[2])
                                    }
                                }
                                // 연령별 유동인구 차트 표시
                                VStack {
                                    if !chartDataSets[3].isEmpty {
                                        Text("연령별 유동인구")
                                            .font(.title2).bold()
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                                        AgeFloatingChartView(chartData: chartDataSets[3])
                                    }
                                }
                                // 분기별 상주인구 차트 표시
                                VStack {
                                    if !chartDataSets[4].isEmpty {
                                        Text("분기별 상주인구")
                                            .font(.title2).bold()
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                                        QuarterlyResidentChartView(chartData: chartDataSets[4])
                                    }
                                }
                                // 성/연령별 상주인구 차트 표시
                                VStack {
                                    if !chartDataSets[5].isEmpty {
                                        Text("성/연령별 상주인구")
                                            .font(.title2).bold()
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                                        GenderAgeResidentChartView(chartData: chartDataSets[5])
                                    }
                                }
                                // 분기별 직장인구 차트 표시
                                VStack {
                                    if !chartDataSets[6].isEmpty {
                                        Text("분기별 직장인구")
                                            .font(.title2).bold()
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                                        QuarterlyWorkingChartView(chartData: chartDataSets[6])
                                    }
                                }
                                // 성/연령별 직장인구 차트 표시
                                VStack {
                                    if !chartDataSets[7].isEmpty {
                                        Text("성/연령별 직장인구")
                                            .font(.title2).bold()
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                                        GenderAgeWorkingChartView(chartData: chartDataSets[7])
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 400) // end of VStack
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .scrollIndicatorsFlash(onAppear: true)
                    .padding()
                    .onAppear {
                        self.loadAllData()
                     }
                }
            }
        
    } // end of body
    
    func loadAllData() {
        isLoading = true
        let group = DispatchGroup()

        for (index, endpoint) in ConsumerEndpoints.allCases.enumerated() {
            group.enter() // 그룹에 작업 추가 시작
            print("\(index)번째 요청 그룹에 들어옴")
            if endpoint.englishEndpoint.contains("floating") {
                loadFloatingData(endpoint: endpoint, index: index, group: group)
            } else {
                loadResidentOrWorkingData(endpoint: endpoint, index: index, group: group)
            }
        }

        group.notify(queue: .main) {
            // 모든 네트워크 요청 완료 후 실행될 코드
            print("데이터 다 가져왔네요!")
            self.isLoading = false
        }
    }

    private func loadResidentOrWorkingData(endpoint: ConsumerEndpoints, index: Int, group: DispatchGroup) {
        ConsumerNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint , commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                // api 통신에 성공한 경우에 JSON을 받아와서 해석
                    case .success (let data):
                        do {
                            print("\(index)번째 일단 데이터 통신은 성공함")
                            // ApiResponse의 형태로 디코딩한 분기별 데이터
                            let residentOrWorkingApiResponse = try JSONDecoder().decode(ConsumerModel.ResidentOrWorkingApiResponse.self, from: data)
                            print("\(index)번째 일단 JSON디코딩까지는 성공함")
                            
                            // 분기별 - quarterlyTrends
                            if endpoint.englishEndpoint.contains("quarterly") {
                                if let seriesData = residentOrWorkingApiResponse.quarterlyTrends?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(residentOrWorkingApiResponse.quarterlyTrends?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                            // 성/연령별 - genderAge
                            else if endpoint.englishEndpoint.contains("age") {
                                if let seriesData = residentOrWorkingApiResponse.genderAge?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(residentOrWorkingApiResponse.genderAge?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                        } catch {
                            print(String(index) + "번째에서 오류!")
                            print("Decoding error: \(error)")
                            print("\(index)번째 요청 그룹에서 나감")
                            group.leave()
                        }
                // api 통신 실패하면
                    case .failure(let error):
                        print("API Networking Error: \(error.localizedDescription)")
                        print("\(index)번째 요청 그룹에서 나감")
                        group.leave()
                }
            }
        }
    } // end of loadData
    
    private func loadFloatingData(endpoint: ConsumerEndpoints, index: Int, group: DispatchGroup) {
        ConsumerNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint , commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                // api 통신에 성공한 경우에 JSON을 받아와서 해석
                    case .success (let data):
                        do {
                            print("\(index)번째 일단 데이터 통신은 성공함")
                            // ApiResponse의 형태로 디코딩한 분기별 데이터
                            let floatingApiResponse = try JSONDecoder().decode(ConsumerModel.FloatingApiResponse.self, from: data)
                            print("\(index)번째 일단 JSON디코딩까지는 성공함")
                            // 분기별 - quarterlyTrends
                            if endpoint.englishEndpoint.contains("quarterly") {
                                if let seriesData = floatingApiResponse.quarterlyTrends?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(floatingApiResponse.quarterlyTrends?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                            // 요일별 - day
                            else if endpoint.englishEndpoint.contains("day") {
                                if let seriesData = floatingApiResponse.day?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(floatingApiResponse.day?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                            // 시간대별 - time
                            else if endpoint.englishEndpoint.contains("time") {
                                if let seriesData = floatingApiResponse.time?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(floatingApiResponse.time?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                            // 연령별 - age
                            else if endpoint.englishEndpoint.contains("age") {
                                if let seriesData = floatingApiResponse.age?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(floatingApiResponse.age?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                        } catch {
                            print("Decoding error: \(error)")
                            print("\(index)번째 요청 그룹에서 나감")
                            group.leave()
                        }
                // api 통신 실패하면
                    case .failure(let error):
                        print("API Networking Error: \(error.localizedDescription)")
                        print("\(index)번째 요청 그룹에서 나감")
                        group.leave()
                }
            }
        }
    } //end of loadFloatingData
} // end of ContentView
