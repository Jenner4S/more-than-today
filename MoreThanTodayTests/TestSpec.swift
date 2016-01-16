//
//  TestSpec.swift
//  MoreThanToday
//
//  Created by Assaf Gelber on 1/16/16.
//  Copyright © 2016 Gelber, Assaf. All rights reserved.
//

import Quick
import Nimble

class TestSpec: QuickSpec {
  override func spec() {
    describe("The tests") {
      it("should just work") {
        let x = true
        expect(x).to(beTrue())
      }
    }
  }
}
