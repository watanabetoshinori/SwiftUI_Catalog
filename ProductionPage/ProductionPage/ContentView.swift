//
//  ContentView.swift
//  ProductionPage
//
//  Created by Watanabe Toshinori on 2020/05/01.
//  Copyright © 2020 Watanabe Toshinori. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var orderedItemWidth: CGFloat = 0

    init() {
        UITableView.appearance().backgroundColor = UIColor.black
        UITableView.appearance().separatorStyle = .none
    }

    var body: some View {
        let header = VStack(alignment: .center, spacing: 8) {
            HStack {
                Spacer()

                Text("iPhone and the Envornment")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                Text("")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            }

            HStack(alignment: .top, spacing: 20) {
                Text("We take responsibility for the environmental footprint of our products throughout their life cycle.")
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack {
                Text("Made with better materials")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.top, 20)

            // List
            VStack(alignment: .leading, spacing: 4) {
                ListItemView(message: "100% recycled rare earth elements in the Taptic Engine")
                ListItemView(message: "100% recycled tin in the solder of the main logic board")
                ListItemView(message: "Enclosure made with recyclable, low-carbon aluminum")
                ListItemView(message: "35% or more recycled plastic in multiple components")
            }
        }
        .padding(20)
        .background(Color(red: 22/255, green: 22/255, blue: 22/255))
        .cornerRadius(10)

        // Ordered List
        let footnote = VStack(alignment: .leading, spacing: 4) {
            OrderedItemView(number: "1.", message: "Available space is less and varies due to many factors. ", width: self.$orderedItemWidth)
            OrderedItemView(number: "2.", message: "Size and weight vary by configuration and manufacturing process.", width: self.$orderedItemWidth)
            OrderedItemView(number: "3.", message: "iPhone SE is splash, water, and dust resistant and was tested under controlled laboratory conditions with a rating of IP67 under IEC standard 60529 (maximum depth of 1 meter up to 30 minutes). ", width: self.$orderedItemWidth)
            OrderedItemView(number: "4.", message: "Data plan required.", width: self.$orderedItemWidth)
            OrderedItemView(number: "5.", message: "FaceTime calling requires a FaceTime‑enabled device for the caller and recipient and a Wi‑Fi connection.", width: self.$orderedItemWidth)
            OrderedItemView(number: "6.", message: "Standard Dynamic Range video content only.", width: self.$orderedItemWidth)
            OrderedItemView(number: "7.", message: "Siri may not be available in all languages or in all areas, and features may vary by area. Internet access required. Cellular data charges may apply.", width: self.$orderedItemWidth)
            OrderedItemView(number: "8.", message: "All battery claims depend on network configuration and many other factors; actual results will vary.", width: self.$orderedItemWidth)
            OrderedItemView(number: "9.", message: "Testing conducted by Apple in February 2020 using preproduction iPhone SE (2nd generation) units and software and accessory Apple USB-C Power Adapters (18W Model A1720 and 30W Model A1882).", width: self.$orderedItemWidth)
            OrderedItemView(number: "10.", message: "Qi wireless chargers sold separately.", width: self.$orderedItemWidth)
        }

        // MainView
        return List {
            VStack(spacing: 20) {
                header
                footnote
            }
            .listRowBackground(Color.black)
        }
        .background(Color.black)
        .onReceive(NotificationCenter.default.publisher(for:  UIContentSizeCategory.didChangeNotification, object: nil), perform: { _ in self.orderedItemWidth = 0 })
    }

}

struct ListItemView: View {

    @State var message: String

    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            Text("・")
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(message)
                .font(.footnote)
                .foregroundColor(.white)
        }
    }

}

struct OrderedItemPreferenceKey: PreferenceKey {

    typealias Value = CGFloat

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }

}

struct OrderedItemView: View {

    @State var number: String

    @State var message: String

    @Binding var width: CGFloat

    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            Text(number)
                .font(.footnote)
                .foregroundColor(.gray)
                .frame(width: width, alignment: .trailing)
                .background(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.clear)
                            .preference(key: OrderedItemPreferenceKey.self, value: geometry.size.width)
                    }
                    .scaledToFill()
                )
                .onPreferenceChange(OrderedItemPreferenceKey.self) {
                    self.width = max($0 / 2, self.width)
                }

            Text(message)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
