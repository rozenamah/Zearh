//
//  Router.swift
//  Rozenamah
//
//  Created by Dominik Majda on 05.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation

protocol Router {
    associatedtype RoutingViewController
    var viewController: RoutingViewController? { get }
}
