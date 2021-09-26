// swift-tools-version:5.3
//
//  Conçu avec ♡ par Levasseur Wesley.
//  © Copyright 2021. Tous droits réservés.
//
//  Création datant du 27/05/2021.
//

import PackageDescription

let package = Package(
        name: "RemasteredJson",
        products: [
            .library(
                    name: "RemasteredJson",
                    targets: ["RemasteredJson"])
        ],
        targets: [
            .target(
                    name: "RemasteredJson",
                    resources: [
                        .process("Resources/test.json")
                    ]
            ),
            .testTarget(
                    name: "RemasteredJsonTests",
                    dependencies: ["RemasteredJson"])
        ]
)
