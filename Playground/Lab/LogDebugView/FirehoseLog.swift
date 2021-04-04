//
//  FirehoseLog.swift
//  Playground
//
//  Created by Kenichi Saito on 2021/03/17.
//

import CoreGraphics
import Foundation

public struct FirehoseLog: Encodable {
    public let installationId: String
    public let kurashiruId: String
    public let firstOpenTimestampMicros: Int64
    public let userProperties: [UserProperty]
    public let device: Device
    public let appInfo: AppInfo
    public let eventDate: String
    public let eventName: String
    public let eventParams: [EventParam]
    public let eventTimestampMicros: Int64

    public init(
        installationId: String,
        kurashiruId: String,
        firstOpenTimestampMicros: Int64,
        userProperties: [UserProperty],
        eventName: String,
        eventParams: [String: Any]
    ) {
        let date = Date()
        self.eventDate = date.to8digitString()
        self.eventTimestampMicros = date.microsecondsSince1970
        self.eventName = eventName
        self.eventParams = eventParams.map { .init(key: $0, value: $1) }
        self.installationId = installationId
        self.kurashiruId = kurashiruId
        self.firstOpenTimestampMicros = firstOpenTimestampMicros
        self.appInfo = .init()
        self.device = .init()
        self.userProperties = userProperties
    }

    public enum CodingKeys: String, CodingKey {
        case installationId = "user_installation_id"
        case kurashiruId = "user_kurashiru_id"
        case firstOpenTimestampMicros = "user_first_open_timestamp_micros"
        case userProperties = "user_properties"
        case device
        case appInfo = "app_info"
        case eventDate = "event_date"
        case eventName = "event_name"
        case eventParams = "event_params"
        case eventTimestampMicros = "event_timestamp_micros"
    }
}

extension FirehoseLog {
    enum UserPropertyKey: String {
        case test
    }

    public struct UserProperty: Encodable {
        public let key: String
        public let value: Value

        init(key: UserPropertyKey, value: Any) {
            self.key = key.rawValue
            self.value = Value(value)
        }
    }

    public struct EventParam: Encodable {
        public let key: String
        public let value: Value

        init(key: String, value: Any) {
            self.key = key
            self.value = Value(value)
        }
    }

    public struct Value: Encodable {
        public var stringValue: String?
        public var intValue: Int?
        public var floatValue: CGFloat?

        private enum CodingKeys: String, CodingKey {
            case stringValue = "string_value"
            case intValue = "int_value"
            case floatValue = "float_value"
        }

        init(_ value: Any) {
            switch value {
            case let v as Int:
                self.intValue = v
            case let v as CGFloat:
                self.floatValue = v
            case let v as Float:
                self.floatValue = CGFloat(v)
            case let v as Double:
                self.floatValue = CGFloat(v)
            default:
                self.stringValue = String(describing: value)
            }
        }
    }

    public struct Device: Encodable {
        public let deviceCategory = "DeviceInfo.category"
        public let mobileBrandName = "Apple"
        public let mobileModelName = "DeviceInfo.mobileModelName"
        public let mobileMarketingName = "DeviceInfo.mobileModelName"
        public let mobileOsHardwareModel = "DeviceInfo.mobileOsHardwareModel"
        public let osVersion = "DeviceInfo.osVersion"
        public let vendorId = "DeviceInfo.vendorId"
        public let advertisingId = "Shared.AppInfo.MobileAdId"
        public let language = "DeviceInfo.language"
        public let timeZoneOffsetSeconds = "DeviceInfo.timeZoneOffsetSeconds"
        public let limitAdTrackingEnabled = "DeviceInfo.limitAdTrackingEnabled"

        public enum CodingKeys: String, CodingKey {
            case deviceCategory = "device_category"
            case mobileBrandName = "mobile_brand_name"
            case mobileModelName = "mobile_model_name"
            case mobileMarketingName = "mobile_marketing_name"
            case mobileOsHardwareModel = "mobile_os_hardware_model"
            case osVersion = "os_version"
            case vendorId = "vendor_id"
            case advertisingId = "advertising_id"
            case language
            case timeZoneOffsetSeconds = "time_zone_offset_seconds"
            case limitAdTrackingEnabled = "limit_ad_tracking_enabled"
        }
    }

    public struct AppInfo: Encodable {
        public let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        public let buildVersion = Int(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0") ?? 0
        public let platform = "ios"

        public enum CodingKeys: String, CodingKey {
            case version
            case buildVersion = "build_version"
            case platform
        }
    }
}

extension Date {
    func to8digitString() -> String { "" }

    var microsecondsSince1970: Int64 { 0 }
}
