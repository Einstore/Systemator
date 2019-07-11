//
//  MenuView.swift
//  Systemator
//
//  Created by Ondrej Rafaj on 11/07/2019.
//  Copyright © 2019 Ondrej Rafaj. All rights reserved.
//

import SwiftUI

struct MenuView : View {
    var body: some View {
        List {
            MenuCell()
            MenuCell()
        }
    }
}

#if DEBUG
struct MenuView_Previews : PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
#endif
