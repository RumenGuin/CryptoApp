//
//  MarketDataModel.swift
//  CryptoApp
//
//  Created by RUMEN GUIN on 16/01/22.
//

import Foundation

//JSON Data
/*
 URL: https://api.coingecko.com/api/v3/global
 JSON response:
 
 {
   "data": {
     "active_cryptocurrencies": 12473,
     "upcoming_icos": 0,
     "ongoing_icos": 50,
     "ended_icos": 3375,
     "markets": 720,
     "total_market_cap": {
       "btc": 51113997.52939222,
       "eth": 657604163.2315477,
       "ltc": 15102861883.81352,
       "bch": 5683980424.056306,
       "bnb": 4427045528.803263,
       "eos": 753750090703.3154,
       "xrp": 2825984362508.6304,
       "xlm": 8462672027730.257,
       "link": 84578728286.15129,
       "dot": 79122365497.11047,
       "yfi": 65427215.22300338,
       "usd": 2211440176630.689,
       "aed": 8122597654362.7295,
       "ars": 229673279262952.1,
       "aud": 3069890293036.248,
       "bdt": 189945338098548.62,
       "bhd": 833799192756.6577,
       "bmd": 2211440176630.689,
       "brl": 12240100233633.21,
       "cad": 2774671875216.7563,
       "chf": 2021950713655.9119,
       "clp": 1812739627185943.2,
       "cny": 14048394866064.1,
       "czk": 47493331521355.984,
       "dkk": 14417926519579.115,
       "eur": 1937259189211.4841,
       "gbp": 1617082457558.5427,
       "hkd": 17215840631052.232,
       "huf": 691229856009456.5,
       "idr": 31655770980388796,
       "ils": 6871696518451.624,
       "inr": 163992110598269.6,
       "jpy": 252623868577406.44,
       "krw": 2632188784636444,
       "kwd": 667678018128.3394,
       "lkr": 448518745909392.94,
       "mmk": 3930868572080534,
       "mxn": 44903292786486.1,
       "myr": 9240502778051.332,
       "ngn": 916177550776325.9,
       "nok": 19369705962684.332,
       "nzd": 3251447320097.4497,
       "php": 113498737121856.11,
       "pkr": 389545187113495.8,
       "pln": 8792575570274.767,
       "rub": 168589363009458,
       "sar": 8297637567223.428,
       "sek": 19973981990948.664,
       "sgd": 2980523784058.423,
       "thb": 73364350944508.9,
       "try": 29912824405177.32,
       "twd": 60931811186705.22,
       "uah": 61837004514124.484,
       "vef": 221431504886.03052,
       "vnd": 50243920813049224,
       "zar": 33999532679988.195,
       "xdr": 1572460017674.4868,
       "xag": 96317242368.18692,
       "xau": 1216800728.387504,
       "bits": 51113997529392.22,
       "sats": 5111399752939222
     },
     "total_volume": {
       "btc": 1628864.2276015729,
       "eth": 20956058.01118937,
       "ltc": 481287174.66883796,
       "bch": 181133013.08137825,
       "bnb": 141077912.98625255,
       "eos": 24019967497.006496,
       "xrp": 90056443603.43338,
       "xlm": 269682364952.3346,
       "link": 2695294275.156711,
       "dot": 2521414817.6798387,
       "yfi": 2084987.5873444816,
       "usd": 70472590079.13217,
       "aed": 258845118634.75092,
       "ars": 7319063401610.2,
       "aud": 97829062931.59013,
       "bdt": 6053041855129.795,
       "bhd": 26570914890.8459,
       "bmd": 70472590079.13217,
       "brl": 390058738828.9891,
       "cad": 88421254046.38626,
       "chf": 64434075725.61167,
       "clp": 57767086813765.484,
       "cny": 447684175736.69464,
       "czk": 1513483439057.458,
       "dkk": 459460145538.9185,
       "eur": 61735186943.35107,
       "gbp": 51532024406.514244,
       "hkd": 548622066507.0355,
       "huf": 22027617481034.414,
       "idr": 1008783414317240.6,
       "ils": 218982298056.4912,
       "inr": 5225983008055.647,
       "jpy": 8050436327689.654,
       "krw": 83880705067587.88,
       "kwd": 21277084396.691647,
       "lkr": 14293073833648.49,
       "mmk": 125266101458478.34,
       "mxn": 1430945941556.7778,
       "myr": 294469717645.65375,
       "ngn": 29196089343883.6,
       "nok": 617259902703.4573,
       "nzd": 103614792104.49677,
       "php": 3616896382824.245,
       "pkr": 12413746742439.133,
       "pln": 280195494525.12494,
       "rub": 5372484951941.642,
       "sar": 264423165084.69522,
       "sek": 636516537942.58,
       "sgd": 94981195093.90225,
       "thb": 2337922538068.0015,
       "try": 953240442446.3726,
       "twd": 1941731274450.324,
       "uah": 1970577326439.293,
       "vef": 7056420444.623493,
       "vnd": 1601137246597882.2,
       "zar": 1083472731823.758,
       "xdr": 50110028483.89746,
       "xag": 3069368826.113722,
       "xau": 38776133.23924091,
       "bits": 1628864227601.5728,
       "sats": 162886422760157.28
     },
     "market_cap_percentage": {
       "btc": 37.037089476545006,
       "eth": 18.08873440120118,
       "bnb": 3.7993629586437634,
       "usdt": 3.581937408974515,
       "sol": 2.140518948311173,
       "usdc": 2.069395957431934,
       "ada": 2.0519524767133754,
       "xrp": 1.6862002785867833,
       "luna": 1.4174183409917738,
       "dot": 1.3521216975255868
     },
     "market_cap_change_percentage_24h_usd": 1.1920339588240372,
     "updated_at": 1642342201
   }
 }
 
 */


struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
       
        if let item = totalMarketCap.first(where: {$0.key == "usd"}) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: {$0.key == "usd"}) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}) {
            return item.value.asPercentString()
        }
        return ""
    }
}
