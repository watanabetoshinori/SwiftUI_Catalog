//
//  ContentView.swift
//  MobilityTrends
//
//  Created by Watanabe Toshinori on 2020/04/24.
//  Copyright © 2020 Watanabe Toshinori. All rights reserved.
//

import SwiftUI
import Charts

struct ContentView: View {

    var body: some View {
        ScrollView {
            Header()

            Text("Change in routing requests since January 13, 2020")
                .foregroundColor(.secondary)
                .padding()

            LineChart()
                .frame(height: 525)
                .padding()
        }
        .edgesIgnoringSafeArea(.top)
    }

}

// MARK: - Header

struct Header: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Maps")
                .font(.title)

            Text("Mobility Trends Reports")
                .font(.title)
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .top, spacing: 20) {
                Text("Learn about COVID‑19 mobility trends in countries/regions and cities. Reports are published daily and reflect requests for directions in Apple Maps. Privacy is one of our core values, so Maps doesn’t associate your data with your Apple ID, and Apple doesn’t keep a history of where you’ve been.")
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: -10) {
                    Icon(systemName: "person.fill", color: .orange)
                    Icon(systemName: "car.fill", color: .red)
                    Icon(systemName: "tram.fill", color: .purple)
                }
                .padding(.top, 20)
            }
        }
        .padding(20)
        .padding(.top, 40)
        .background(Color(UIColor.systemGray6))
    }

}

struct Icon: View {

    let systemName: String

    let color: Color

    var body: some View {
        Circle()
            .foregroundColor(color)
            .frame(width: 60, height: 60)
            .overlay(
                Circle()
                    .stroke(Color(UIColor.systemGray6), lineWidth: 4)
            )
            .overlay(
                Image(systemName: systemName)
                    .font(.system(size: 26))
                    .foregroundColor(.white)
            )
            .zIndex(1)
    }
}

// MARK: - Charts

struct LineChart: UIViewRepresentable {

    // Mobility Trends Data
    // https://www.apple.com/covid19/mobility

    let period = ["JAN 13","","","","","","","","","","","","","","","","","","",
                  "FEB","","","","","","","","","","","","","","","","","","","","","","","","","","","",
                  "MAR","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",
                  "APR","","","","","","","","","","","","APR 13"]

    let driving = ["100","97.94","99.14","103.16","123.15","130.54","104.44","100.01","99.73","99.02","102.76","129.78","131.34","101.47","94.7",
                   "99.11","101.33","101.75","128.05","132.95","106.91","103.28","103.66","103.12","105.07","132.39","148.54","120.49","128.3","112.01",
                   "109.2","110.99","134.71","131.54","114.42","111.43","111.19","112.58","116.79","140.56","161.69","142.83","116.21","107.01","107.46",
                   "103.29","112.22","114.58","103.92","105.91","103.24","106.01","110.8","122.87","115.69","113.65","108.76","116.12","117.83","115.47",
                   "123.4","133.14","120.19","119.97","123.25","127.56","152.83","161.59","148.75","127.72","124.82","128.24","128.82","121.43","122.59",
                   "111.03","111.53","105.3","97.79","98.41","99.61","107.26","97.79","91.93","87.35","83.74","81.2","79.75","85.41","69.08","67.85","74.14"]

    let transit = ["100","99.33","101.16","107.02","128.61","131.7","104.9","102.13","102.41","101.15","105.97","131.96","132.99","101.53","96.58",
                   "100.7","102.45","103.5","129.82","131.35","109.27","106.53","108.0","105.15","108.17","132.29","155.72","120.26","127.42","113.31",
                   "112.26","114.08","133.01","128.41","114.64","112.88","112.02","112.54","116.33","134.17","146.81","130.41","112.61","104.56","102.38",
                   "97.64","102.82","104.61","98.18","100.79","97.95","100.36","104.22","109.49","101.58","106.0","102.41","109.49","111.98","110.47",
                   "108.61","113.41","110.5","112.5","115.65","118.04","127.64","131.95","123.18","116.13","116.35","118.84","117.95","109.55","102.47",
                   "91.71","99.29","95.23","93.59","92.36","91.56","91.22","81.07","82.91","78.3","73.88","70.69","68.03","69.34","56.65","57.7","61.63"]

    let walking = ["100","96.07","102.01","108.67","135.81","148.78","105.94","101.99","103.65","97.98","108.94","147.47","148.88","99.96","90.56",
                   "103.86","110.98","109.17","145.33","148.04","115.13","113.98","116.67","109.4","111.67","143.57","154.39","121.72","138.39","119.7",
                   "121.38","124.99","150.75","138.76","119.97","122.2","122.62","124.25","127.0","145.9","163.51","145.52","121.18","112.83","111.53",
                   "104.84","112.22","116.77","101.49","113.27","103.49","109.96","117.33","121.2","102.85","118.47","108.01","126.08","132.61","130.25",
                   "112.95","124.7","122.39","129.51","136.79","138.72","142.88","149.4","140.39","133.79","134.98","141.1","142.0","123.41","105.55",
                   "84.38","105.3","105.72","94.47","98.5","101.04","100.06","82.85","88.32","84.77","79.34","75.52","72.25","75.47","56.71","46.81","63.73"]

    func makeUIView(context: Context) -> LineChartView {
        let uiView = LineChartView()

        let formatter = NumberFormatter()
        formatter.positivePrefix = "+"
        formatter.positiveSuffix = "%"
        formatter.negativePrefix = "-"
        formatter.negativeSuffix = "%"

        // Driving Chart
        let drivingEntries = driving.enumerated().map { ChartDataEntry(x: Double($0.offset), y: Double($0.element)! - 100) }
        let latestDrivingEntry = drivingEntries.last!
        let latestDrivingValue = formatter.string(from: NSNumber(value: latestDrivingEntry.y))!
        let drivingDataSet = LineChartDataSet(entries: drivingEntries, label: "Driving \(latestDrivingValue)")
        drivingDataSet.drawCirclesEnabled = false
        drivingDataSet.drawValuesEnabled = false
        drivingDataSet.valueFont = UIFont.systemFont(ofSize: 10)
        drivingDataSet.valueTextColor = .red
        drivingDataSet.colors = [.red]

        // Walking Chart
        let walkingEntries = walking.enumerated().map { ChartDataEntry(x: Double($0.offset), y: Double($0.element)! - 100) }
        let latestWalkingEntry = walkingEntries.last!
        let latestWalkingValue = formatter.string(from: NSNumber(value: latestWalkingEntry.y))!
        let walkingDataSet = LineChartDataSet(entries: walkingEntries, label: "Walking \(latestWalkingValue)")
        walkingDataSet.drawCirclesEnabled = false
        walkingDataSet.drawValuesEnabled = false
        walkingDataSet.valueFont = UIFont.systemFont(ofSize: 10)
        walkingDataSet.valueTextColor = .orange
        walkingDataSet.colors = [.orange]

        // Transit Chart
        let transitEntries = transit.enumerated().map { ChartDataEntry(x: Double($0.offset), y: Double($0.element)! - 100) }
        let latestTransitEntry = transitEntries.last!
        let latestTransitValue = formatter.string(from: NSNumber(value: latestTransitEntry.y))!
        let transitDataSet = LineChartDataSet(entries: transitEntries, label: "Transit \(latestTransitValue)")
        transitDataSet.drawCirclesEnabled = false
        transitDataSet.drawValuesEnabled = false
        transitDataSet.valueFont = UIFont.systemFont(ofSize: 10)
        transitDataSet.valueTextColor = .purple
        transitDataSet.colors = [.purple]

        let data = LineChartData()
        data.addDataSet(drivingDataSet)
        data.addDataSet(transitDataSet)
        data.addDataSet(walkingDataSet)

        // Baseline
        let baseLine = ChartLimitLine(limit: 0.0)
        baseLine.lineWidth = 1
        baseLine.lineColor = .gray
        baseLine.valueFont = UIFont.systemFont(ofSize: 12)

        uiView.rightAxis.enabled = false

        uiView.leftAxis.drawAxisLineEnabled = false
        uiView.leftAxis.axisMaximum = 100
        uiView.leftAxis.axisMinimum = -100
        uiView.leftAxis.gridColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        uiView.leftAxis.labelCount = 10
        uiView.leftAxis.valueFormatter = LeftAxisFormatter(formatter: formatter)
        uiView.leftAxis.labelPosition = .insideChart
        uiView.leftAxis.addLimitLine(baseLine)

        uiView.xAxis.drawAxisLineEnabled = false
        uiView.xAxis.drawGridLinesEnabled = false
        uiView.xAxis.labelPosition = .bottom
        uiView.xAxis.axisMaxLabels = period.count + 15
        uiView.xAxis.setLabelCount(period.count + 15, force: true)
        uiView.xAxis.valueFormatter = XAsixFormatter(values: period)
        uiView.xAxis.spaceMax = 5
        uiView.xAxis.spaceMin = 10

        uiView.legend.enabled = true
        uiView.legend.form = .circle
        uiView.legend.formSize = 12
        uiView.legend.xEntrySpace = 8
        uiView.legend.yEntrySpace = 8
        uiView.legend.formToTextSpace = 8
        uiView.legend.font = UIFont.systemFont(ofSize: 14)

        uiView.data = data
        uiView.highlightPerTapEnabled = false
        uiView.highlightPerDragEnabled = false
        uiView.doubleTapToZoomEnabled = false
        uiView.dragEnabled = false
        uiView.scaleXEnabled = false
        uiView.scaleYEnabled = false
        uiView.maxVisibleCount = period.count * 5

        return uiView
    }

    func updateUIView(_ uiView: LineChartView, context: Context) {

    }

}

class LeftAxisFormatter: NSObject, IAxisValueFormatter {

    let formatter: NumberFormatter

    init(formatter: NumberFormatter) {
        self.formatter = formatter
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch abs(value) {
        case 0.00, 40.0, 80.0, 100.0:
            return ""
        default:
            return formatter.string(from: NSNumber(value: value)) ?? String(value)
        }
    }

}

class XAsixFormatter: NSObject, IAxisValueFormatter {

    let values: [String]

    init(values: [String]) {
        self.values = values
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        if 0 <= value, Int(value) < values.count {
            return values[Int(value)]
        }

        return ""
    }

}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
