//
//  HealthKitInterface.swift
//  Core Bluetooth HRM
//
//  Created by Software Testing on 4/13/18.
//  Copyright © 2018 Andrew Jaffee. All rights reserved.
//

import Foundation

// STEP 1: MUST import HealthKit
import HealthKit

class HealthKitInterface
{
    
    // STEP 2: a placeholder for a conduit to all HealthKit data
    let healthKitDataStore: HKHealthStore?
    
    // STEP 3: get a user's physical property that won't change
    let genderCharacteristic = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)
    
    // STEP 4: for flexibility, the API allows us to ask for
    // multiple characteristics at once
    let readableHKCharacteristicTypes: Set<HKCharacteristicType>?
    
    /*
    let readableHKDataTypes: Set<HKSampleType>?
    
    let writeableHKDataTypes: Set<HKSampleType>?
    */
    
    init() {
        
        // STEP 5: make sure HealthKit is available
        if HKHealthStore.isHealthDataAvailable() {
            
            // STEP 6: create one instance of the HealthKit store
            // per app; it's the conduit to all HealthKit data
            self.healthKitDataStore = HKHealthStore()
            
            //readableHKDataTypes = [HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
            //writeableHKDataTypes = [HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
            
            /*
            healthKitDataStore?.requestAuthorization(toShare: writeableHKDataTypes,
                                                     read: readableHKDataTypes,
                                                         completion: { (success, error) -> Void in
                                                            if success {
                                                                print("Successful authorization.")
                                                            } else {
                                                                print(error.debugDescription)
                                                            }
                                                    })
            
            */
            
            // STEP 7: I create a Set of one as that's what the call wants
            readableHKCharacteristicTypes = [genderCharacteristic!]
            
            // STEP 8: request user permission to read gender and
            // then read the value asynchronously
            healthKitDataStore?.requestAuthorization(toShare: nil,
                                                     read: readableHKCharacteristicTypes,
                                                          completion: { (success, error) -> Void in
                                                            if success {
                                                                print("Successful authorization.")
                                                                // STEP 9.1: read gender data (see below)
                                                                self.readGenderType()
                                                            } else {
                                                                print(error.debugDescription)
                                                            }
                                                    })
        }
            
        else {
            
            self.healthKitDataStore = nil
            //self.readableHKDataTypes = nil
            //self.writeableHKDataTypes = nil
            readableHKCharacteristicTypes = nil
        }
        
    } // end init()
    
    /*
    func writeHeartRateData( heartRate: Int ) -> Void {
        
        // "Count units are used to represent raw scalar values. They are often used to represent the number of times an event occurs—for example, the number of steps the user has taken or the number of times the user has used his or her inhaler."
        let heartRateCountUnit = HKUnit.count()
        // "HealthKit uses quantity objects to store numerical data. Quantities store a value for a given unit. You can request the value in any compatible units."
        // beats per minutes = heart beats / minute
        let beatsPerMinuteQuantity = HKQuantity(unit: heartRateCountUnit.unitDivided(by: HKUnit.minute()), doubleValue: Double(heartRate))
        // "HealthKit uses quantity types to create samples that store a numerical value. Use quantity type instances to create quantity samples that you can save in the HealthKit store."
        // Short-hand for HKQuantityTypeIdentifier.heartRate
        let beatsPerMinuteType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        // "Each quantity sample instance represent a piece of data with a single numeric value. For example, you can use a quantity sample to record the user’s height, the user’s current heart rate"
        let heartRateSampleData = HKQuantitySample(type: beatsPerMinuteType, quantity: beatsPerMinuteQuantity, start: Date(), end: Date())
        
        // "Saves an array of objects to the HealthKit store."
        healthKitDataStore?.save([heartRateSampleData]) { (success: Bool, error: Error?) in
            print("Heart rate \(heartRate) saved.")
        }
        
    } // end func writeHeartRateData
    
    func readHeartRateData() -> Void {

        let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
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

        healthKitDataStore?.execute(query)
        
    } // end func readHeartRateData
    */
    
    // STEP 9.2: actual code to read gender data
    func readGenderType() -> Void {
        
        do {
            
            let genderType = try self.healthKitDataStore?.biologicalSex()
            
            if genderType?.biologicalSex == .female {
                print("Gender is female.")
            }
            else if genderType?.biologicalSex == .male {
                print("Gender is male.")
            }
            else {
                print("Gender is unspecified.")
            }
            
        }
        catch {
            print("Error looking up gender.")
        }
        
    } // end func readGenderType
    
} // end class HealthKitInterface
