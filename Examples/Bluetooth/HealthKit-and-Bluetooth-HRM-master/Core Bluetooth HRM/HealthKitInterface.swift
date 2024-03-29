//
//  HealthKitInterface.swift
//  Core Bluetooth HRM
//
//  Created by Software Testing on 4/13/18.
//
/*
 
 Copyright (c) 2018 Andrew L. Jaffee, microIT Infrastructure, LLC, and iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

import Foundation

// STEP 1: MUST import HealthKit
import HealthKit

class HealthKitInterface
{
    
    // STEP 2: a placeholder for a conduit to all HealthKit data
    let healthKitDataStore: HKHealthStore?
    
    // STEP 3: create member properties that we'll use to ask
    // if we can read and write heart rate data
    let readableHKQuantityTypes: Set<HKQuantityType>?
    let writeableHKQuantityTypes: Set<HKQuantityType>?
    
    init() {
        
        // STEP 4: make sure HealthKit is available
        if HKHealthStore.isHealthDataAvailable() {
            
            // STEP 5: create one instance of the HealthKit store
            // per app; it's the conduit to all HealthKit data
            self.healthKitDataStore = HKHealthStore()
            
            // STEP 6: create two Sets of HKQuantityTypes representing
            // heart rate data; one for reading, one for writing
            readableHKQuantityTypes = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
            writeableHKQuantityTypes = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
            
            // STEP 7: ask user for permission to read and write
            // heart rate data
            healthKitDataStore?.requestAuthorization(toShare: writeableHKQuantityTypes,
                                                     read: readableHKQuantityTypes,
                                                         completion: { (success, error) -> Void in
                                                            if success {
                                                                print("Successful authorization.")
                                                            } else {
                                                                print(error.debugDescription)
                                                            }
                                                    })
            
        } // end if HKHealthStore.isHealthDataAvailable()
            
        else {
            
            self.healthKitDataStore = nil
            self.readableHKQuantityTypes = nil
            self.writeableHKQuantityTypes = nil
            
        }
        
    } // end init()
    
    // STEP 8.0: this is my wrapper for writing one heart
    // rate sample at a time to the HKHealthStore
    func writeHeartRateData( heartRate: Int ) -> Void {
        
        // STEP 8.1: "Count units are used to represent raw scalar values. They are often used to represent the number of times an event occurs"
        let heartRateCountUnit = HKUnit.count()
        // STEP 8.2: "HealthKit uses quantity objects to store numerical data. When you create a quantity, you provide both the quantity’s value and unit."
        // beats per minute = heart beats / minute
        let beatsPerMinuteQuantity = HKQuantity(unit: heartRateCountUnit.unitDivided(by: HKUnit.minute()), doubleValue: Double(heartRate))
        // STEP 8.3: "HealthKit uses quantity types to create samples that store a numerical value. Use quantity type instances to create quantity samples that you can save in the HealthKit store."
        // Short-hand for HKQuantityTypeIdentifier.heartRate
        let beatsPerMinuteType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        // STEP 8.4: "you can use a quantity sample to record ... the user's current heart rate..."
        let heartRateSampleData = HKQuantitySample(type: beatsPerMinuteType, quantity: beatsPerMinuteQuantity, start: Date(), end: Date())
        
        // STEP 8.5: "Saves an array of objects to the HealthKit store."
        healthKitDataStore?.save([heartRateSampleData]) { (success: Bool, error: Error?) in
            print("Heart rate \(heartRate) saved.")
        }
        
    } // end func writeHeartRateData
    
    // STEP 9.0: this is my wrapper for reading all "recent"
    // heart rate samples from the HKHealthStore
    func readHeartRateData() -> Void {

        // STEP 9.1: just as in STEP 6, we're telling the `HealthKitStore`
        // that we're interested in reading heart rate data
        let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
        // STEP 9.2: define a query for "recent" heart rate data;
        // in pseudo-SQL, this would look like:
        //
        // SELECT bpm FROM HealthKitStore WHERE qtyTypeID = '.heartRate';
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) {
            (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            
            if let samples = samplesOrNil {

                for heartRateSamples in samples {
                    print(heartRateSamples)
                }
                
            }
            else {
                print("No heart rate sample available.")
            }
            
        }

        // STEP 9.3: execute the query for heart rate data
        healthKitDataStore?.execute(query)
        
    } // end func readHeartRateData
 
} // end class HealthKitInterface
