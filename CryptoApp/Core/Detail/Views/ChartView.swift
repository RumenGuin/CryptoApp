//
//  ChartView.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 20/01/22.
//

import SwiftUI

//point (0,0) is the TOP LEFT on iPhone
/*
 
 (minX, minY)  (midX, minY)    (maxX, minY)
 
 (minX, midY)  (midX, midY)    (maxX, midY)
 
 (minX, maxY)  (midX, maxY)    (maxX, maxY)
 
  */

//have to make the chart dynamic because price of every coin is different.
//each chart has to have different y axis
//eg. price of bitcoin is 55000 and eth is 3000.

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date //most recent date
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? [] //its a array of all prices
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60) //7 days back
    }
    var body: some View {
       
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBG)
                .overlay(yAxisLevel.padding(.horizontal, 4), alignment: .leading)
            dateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 1.5)) {
                    percentage = 1
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path {path in
                for index in data.indices { //looping on all the prices
                    /*
                     data.count is no. of items data array(array of prices)
                     let size.width(width of screen) = 300 pts, let 100 items in our data array
                     300/100 = 3 (each item would have an x of 3 pts.)
                     index + 1 because index starts from 0 but .count starts from 1
                     eg.
                     for index = 0, xPosition(for 1st item) = (300/100) * (0+1) = 3
                     for index = 1, xPosition(for 2nd item) = (300/100) * (1+1) = 6
                     for index = 2, xPosition(for 3rd item) = (300/100) * (2+1) = 9
                     */
                    let xPosition =
                    geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    /*
                     60,000 - max
                     50,000 - min
                     60k - 50k = 10k -> yAxis
                     let 52k - data point
                     52k - 50k = 2k
                     data point should be 2k / 10k = 20% above from the bottom
                     the coordinate system of iPhone is in reverse where point 0 is on the top and maxValue(let 50000) of y is at bottom.
                     we need to inverse the y axis here. we just subtract the percent here from 1.
                     so if our percent is 20% we have to do 1 - 20% = 80%
                     */
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height//20% from the bottom (let)
                    
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    
    private var chartBG: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var yAxisLevel: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var dateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
