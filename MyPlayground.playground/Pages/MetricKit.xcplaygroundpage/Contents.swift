import Foundation
#if os(iOS)
import MetricKit


#endif

public struct Bucket {
    let count: Int
    let start: Double
    let end: Double

    /// 階級値
    func calcClassValue() -> Double {
        return (start + end) / 2.0
    }
}
public struct HangRate {
    let buckets: [Bucket]

    /// NOTE:
    /// AVG = Σ(階級値×相対度数)
    /// X: 階級値, Y: データ数(Bucket#count), n = Bucket数 としたときに
    /// AVG = {X1*Y1/(Y1+Y2+ ... +Yn)}+{X2*Y2/(Y1+Y2+ ... +Yn)}+...+{Xn*Yn/(Y1+Y2+ ... +Yn)}
    func calcAverage() -> Double {
        let totalBucketCount = buckets.map { $0.count }.reduce(0) { $0 + $1 }
        return buckets
                    .map {
                        let classValue = $0.calcClassValue() // 階級値
                        let relativeFrequency = Double($0.count / totalBucketCount) //相対度数
                        return classValue * relativeFrequency
                    }
                    .reduce(0) { $0 + $1 }
    }
}
public struct HangrateMetricPayload {
    let hangrate: HangRate
    let rawData: Data
}

public protocol HangRateMetricSubscriberProtocol {
    func deliverPayloads(_ payloads: [HangrateMetricPayload])
}

/// MetricKitのHangrate情報を加工してログ送信するクラス
/// ref: https://dely.docbase.io/posts/1634404
class HangRateMetricSubscriber: NSObject, HangRateMetricSubscriberProtocol {
    private let queue: DispatchQueue = .global(qos: .background)

    func deliverPayloads(_ payloads: [HangrateMetricPayload]) {
        queue.async {
            // Send
        }
    }
}

extension HangRateMetricSubscriber: MXMetricManagerSubscriber {
    func didReceive(_ payloads: [MXMetricPayload]) {
        let _payloads = payloads
            .compactMap { $0.applicationResponsivenessMetrics }
            .map { metric -> HangrateMetricPayload in
                let buckets: [Bucket] = metric.histogrammedApplicationHangTime.bucketEnumerator.allObjects.compactMap {
                    guard let object = $0 as? MXHistogramBucket<Unit> else { return nil }
                    return .init(
                        count: object.bucketCount,
                        start: object.bucketStart.value,
                        end: object.bucketEnd.value
                    )
                }
                let hangrate = HangRate(buckets: buckets)
                let json = metric.jsonRepresentation()
                return HangrateMetricPayload(hangrate: hangrate, rawData: json)
            }

        deliverPayloads(_payloads)
    }
}


