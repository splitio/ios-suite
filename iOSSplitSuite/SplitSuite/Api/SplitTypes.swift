//
//  Types.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 23/11/2023.
//

import Foundation
import Split
import SplitRumAgent

public typealias SplitClientConfig = Split.SplitClientConfig
public typealias SplitClient = Split.SplitClient
public typealias SplitRumConfig = SplitRumAgent.SplitRumConfig
public typealias Key = Split.Key
public typealias ServiceEndpoints = Split.ServiceEndpoints
public typealias SplitFactory = Split.SplitFactory
public typealias SplitFactoryBuilder = Split.SplitFactoryBuilder
public typealias DefaultSplitFactoryBuilder = Split.DefaultSplitFactoryBuilder
public typealias SplitEvent = Split.SplitEvent


public typealias SplitLogLevel = Split.SplitLogLevel
public typealias SplitView = Split.SplitView
public typealias SplitImpression = Split.SplitImpression
public typealias SplitManager = Split.SplitManager
public typealias DefaultSplitFactory = Split.DefaultSplitFactory
public typealias DefaultSplitClient = Split.DefaultSplitClient
public typealias SplitResult = Split.SplitResult
public typealias SplitImpressionListener = (SplitImpression) -> Void
