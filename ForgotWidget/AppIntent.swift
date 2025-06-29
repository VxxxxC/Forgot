//
//  AppIntent.swift
//  ForgotWidget
//
//  Created by VC on 29/6/2025.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {

    static var title: LocalizedStringResource { "Forgot!" }
    static var description: IntentDescription { "This is an Forgot widget." }

    // An example configurable parameter.
    @Parameter(title: "Forgot Thing", default: "😃")
    var forgotItem: String
}
