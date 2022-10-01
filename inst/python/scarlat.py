import numpy as np  
import pandas as pd 
import json
from datetime import date
from tqdm.auto import tqdm
tqdm.pandas()

from fhir.resources.bundle import Bundle
from fhir.resources.patient import Patient
from fhir.resources.condition import Condition
from fhir.resources.observation import Observation
from fhir.resources.medicationrequest import MedicationRequest
from fhir.resources.procedure import Procedure
from fhir.resources.encounter import Encounter
from fhir.resources.claim import Claim
from fhir.resources.immunization import Immunization

import os
filesList = os.listdir('.')
print(len(filesList))
print(filesList)

PATIENT = pd.DataFrame(columns=['PatientUID', 'NameFamily', 'NameGiven', 'DoB', 'Gender'])
CONDITION = pd.DataFrame(columns=['ConditionText', 'ConditionOnsetDates', 'PatientUID'])
OBSERVATION = pd.DataFrame(columns=['ObservationText', 'ObservationValue', 'ObservationUnit',
       'ObservationDate', 'PatientUID'])
MEDICATION = pd.DataFrame(columns=['MedicationText', 'MedicationDates', 'PatientUID'])
PROCEDURE = pd.DataFrame(columns=['ProcedureText', 'ProcedureDates', 'PatientUID'])
ENCOUNTER = pd.DataFrame(columns=['EncountersText', 'EncounterLocation', 'EncounterProvider','EncounterDates', 'PatientUID'])
CLAIM = pd.DataFrame(columns=['ClaimProvider', 'ClaimInsurance', 'ClaimDate', 'ClaimType','ClaimItem', 
                              'ClaimUSD', 'PatientUID'])
IMMUNIZATION = pd.DataFrame(columns=['Immunization', 'ImmunizationDates', 'PatientUID'])


f = open('./'+filesList[50],)
json_obj = json.load(f)

oneBundle = Bundle.parse_obj(json_obj)

# Resources

resources = []
if oneBundle.entry is not None:
    for entry in oneBundle.entry:
        resources.append(entry.resource)


oneResources = []
for j in range(len(resources)):
    oneResources.append(type(resources[j]))
    
print(len(oneResources))

uniqResources = set(oneResources)
print(len(uniqResources))
print(uniqResources)


onePatient = Patient.parse_obj(resources[0])
onePatient.name[0]

# Patient demographics
onePatientID = onePatient.id

print(onePatientID)
print(onePatient.name[0].family)
print(onePatient.name[0].given[0])
print(onePatient.birthDate)
print(onePatient.gender)

resCondition = []
for j in range(len(resources)):
    if resources[j].__class__.__name__ == 'Condition':
        resCondition.append(resources[j])
        
conditions = []
conditionOnsetDates = []
for j in range(len(resCondition)):
    oneCondition = Condition.parse_obj(resCondition[j])
    conditions.append(oneCondition.code.text)
    conditionOnsetDates.append(str(oneCondition.onsetDateTime.date()))  
    
onePatConditions = pd.DataFrame()

onePatConditions['ConditionText'] = conditions
onePatConditions['ConditionOnsetDates'] = conditionOnsetDates
onePatConditions['PatientUID'] = onePatientID

print(onePatConditions.shape)
print(onePatConditions.sample(1))

# Find Observation resources 

resObservation = []
for j in range(len(resources)):
    if resources[j].__class__.__name__ == 'Observation':
        resObservation.append(resources[j])
        
obsText = []
obsValue = []
obsUnit = []
obsDate = []

for j in range(len(resObservation)):
    oneObservation = Observation.parse_obj(resObservation[j])
    obsText.append(oneObservation.code.text)
    if oneObservation.valueQuantity:
        obsValue.append(round(oneObservation.valueQuantity.value,2))
        obsUnit.append(oneObservation.valueQuantity.unit)
    else:
        obsValue.append('None')
        obsUnit.append('None')
    obsDate.append(oneObservation.issued.date())
    

onePatObs = pd.DataFrame()

onePatObs['ObservationText'] = obsText
onePatObs['ObservationValue'] = obsValue
onePatObs['ObservationUnit'] = obsUnit
onePatObs['ObservationDate'] = obsDate
onePatObs['PatientUID'] = onePatientID

print(onePatObs.shape)
print(onePatObs.sample(1))

# Find MedicationRequest resources 

resMedicationRequest = []
for j in range(len(resources)):
    if resources[j].__class__.__name__ == 'MedicationRequest':
        resMedicationRequest.append(resources[j])
        
meds = []
medsDates = []
for j in range(len(resMedicationRequest)):
    oneMed = MedicationRequest.parse_obj(resMedicationRequest[j])
    meds.append(oneMed.medicationCodeableConcept.text)
    medsDates.append(str(oneMed.authoredOn.date()))  
    
onePatMeds = pd.DataFrame()

onePatMeds['MedicationText'] = meds
onePatMeds['MedicationDates'] = medsDates
onePatMeds['PatientUID'] = onePatientID

print(onePatMeds.shape)
print(onePatMeds.sample(1))

resProcedures = []
for j in range(len(resources)):
    if resources[j].__class__.__name__ == 'Procedure':
        resProcedures.append(resources[j])
        
procs = []
procDates = []
for j in range(len(resProcedures)):
    oneProc = Procedure.parse_obj(resProcedures[j])
    procs.append(oneProc.code.text)
    procDates.append(str(oneProc.performedPeriod.start.date()))  
    
onePatProcs = pd.DataFrame()

onePatProcs['ProcedureText'] = procs
onePatProcs['ProcedureDates'] = procDates
onePatProcs['PatientUID'] = onePatientID

print(onePatProcs.shape)
print(onePatProcs.sample(1))

# Find Encounter resources 

resEncounters = []
for j in range(len(resources)):
    if resources[j].__class__.__name__ == 'Encounter':
        resEncounters.append(resources[j])
        
encounters = []
encountDates = []
encountLocation = []
encountProvider = []

for j in range(len(resEncounters)):
    oneEncounter = Encounter.parse_obj(resEncounters[j])
    encounters.append(oneEncounter.type[0].text)
    encountLocation.append(oneEncounter.serviceProvider.display)
    if oneEncounter.participant:
        encountProvider.append(oneEncounter.participant[0].individual.display)
    else:
        encountProvider.append('None')
    encountDates.append(str(oneEncounter.period.start.date()))  
    
onePatEncounters = pd.DataFrame()

onePatEncounters['EncountersText'] = encounters
onePatEncounters['EncounterLocation'] = encountLocation
onePatEncounters['EncounterProvider'] = encountProvider
onePatEncounters['EncounterDates'] = encountDates
onePatEncounters['PatientUID'] = onePatientID

print(onePatEncounters.shape)
print(onePatEncounters.sample(1))

# Find Claim resources 

resClaims = []
for j in range(len(resources)):
    if resources[j].__class__.__name__ == 'Claim':
        resClaims.append(resources[j])
        
claimProvider = []
claimInsurance = []
claimDate = []
claimType = []
claimItem = []
claimUSD = []

for j in range(len(resClaims)):
    oneClaim = Claim.parse_obj(resClaims[j])
    # Inner loop over claim items:
    for i in range(len(resClaims[j].item)):
        claimProvider.append(oneClaim.provider.display)
        claimInsurance.append(oneClaim.insurance[0].coverage.display)
        claimDate.append(str(oneClaim.billablePeriod.start.date()))
        claimType.append(oneClaim.type.coding[0].code)
        claimItem.append(resClaims[j].item[i].productOrService.text)
        if resClaims[j].item[i].net:
            claimUSD.append(str(resClaims[j].item[i].net.value))
        else:
            claimUSD.append('None')
    
onePatClaims = pd.DataFrame()

onePatClaims['ClaimProvider'] = claimProvider
onePatClaims['ClaimInsurance'] = claimInsurance
onePatClaims['ClaimDate'] = claimDate
onePatClaims['ClaimType'] = claimType
onePatClaims['ClaimItem'] = claimItem
onePatClaims['ClaimUSD'] = claimUSD
onePatClaims['PatientUID'] = onePatientID

print(onePatClaims.shape)
print(onePatClaims.sample(1))

resImmunization = []
for j in range(len(resources)):
    if resources[j].__class__.__name__ == 'Immunization':
        resImmunization.append(resources[j])
        
immun = []
immunDates = []
for j in range(len(resImmunization)):
    oneImmun = Immunization.parse_obj(resImmunization[j])
    immun.append(oneImmun.vaccineCode.coding[0].display)
    immunDates.append(str(oneImmun.occurrenceDateTime.date()))  
    
onePatImmun = pd.DataFrame()

onePatImmun['Immunization'] = immun
onePatImmun['ImmunizationDates'] = immunDates
onePatImmun['PatientUID'] = onePatientID

print(onePatImmun.shape)
print(onePatImmun.sample(1))

#for fileNum in range(100):
for fileNum in tqdm(range(100)):
    f = open('./'+filesList[fileNum],)
    json_obj = json.load(f)

    oneBundle = Bundle.parse_obj(json_obj)

    # Resources 
    resources = []
    if oneBundle.entry is not None:
        for entry in oneBundle.entry:
            resources.append(entry.resource)
    
    onePatient = Patient.parse_obj(resources[0])

    # Patient demographics ########################################
    onePatientID = onePatient.id

    PATIENT.loc[len(PATIENT.index)] = [onePatientID, onePatient.name[0].family, 
                                       onePatient.name[0].given[0], onePatient.birthDate, onePatient.gender] 
    
    # Find Condition resources ########################################
    resCondition = []
    for j in range(len(resources)):
        if resources[j].__class__.__name__ == 'Condition':
            resCondition.append(resources[j])

    conditions = []
    conditionOnsetDates = []
    for j in range(len(resCondition)):
        oneCondition = Condition.parse_obj(resCondition[j])
        conditions.append(oneCondition.code.text)
        conditionOnsetDates.append(str(oneCondition.onsetDateTime.date()))  

    onePatConditions = pd.DataFrame()

    onePatConditions['ConditionText'] = conditions
    onePatConditions['ConditionOnsetDates'] = conditionOnsetDates
    onePatConditions['PatientUID'] = onePatientID

    CONDITION = pd.concat([CONDITION, onePatConditions], ignore_index = True, axis=0)
    CONDITION.reset_index()
    
    # Find Observation resources ########################################
    resObservation = []
    for j in range(len(resources)):
        if resources[j].__class__.__name__ == 'Observation':
            resObservation.append(resources[j])

    obsText = []
    obsValue = []
    obsUnit = []
    obsDate = []

    for j in range(len(resObservation)):
        oneObservation = Observation.parse_obj(resObservation[j])
        obsText.append(oneObservation.code.text)
        if oneObservation.valueQuantity:
            obsValue.append(round(oneObservation.valueQuantity.value,2))
            obsUnit.append(oneObservation.valueQuantity.unit)
        else:
            obsValue.append('None')
            obsUnit.append('None')
        obsDate.append(oneObservation.issued.date())
  
    onePatObs = pd.DataFrame()

    onePatObs['ObservationText'] = obsText
    onePatObs['ObservationValue'] = obsValue
    onePatObs['ObservationUnit'] = obsUnit
    onePatObs['ObservationDate'] = obsDate
    onePatObs['PatientUID'] = onePatientID

    OBSERVATION = pd.concat([OBSERVATION, onePatObs], ignore_index = True, axis=0)
    OBSERVATION.reset_index()
    
    # Find Medication resources ########################################
    resMedicationRequest = []
    for j in range(len(resources)):
        if resources[j].__class__.__name__ == 'MedicationRequest':
            resMedicationRequest.append(resources[j])

    meds = []
    medsDates = []
    for j in range(len(resMedicationRequest)):
        oneMed = MedicationRequest.parse_obj(resMedicationRequest[j])
        meds.append(oneMed.medicationCodeableConcept.text)
        medsDates.append(str(oneMed.authoredOn.date()))  

    onePatMeds = pd.DataFrame()

    onePatMeds['MedicationText'] = meds
    onePatMeds['MedicationDates'] = medsDates
    onePatMeds['PatientUID'] = onePatientID
    
    MEDICATION = pd.concat([MEDICATION, onePatMeds], ignore_index = True, axis=0)
    MEDICATION.reset_index()
    
    # Find Procedure resources ########################################
    resProcedures = []
    for j in range(len(resources)):
        if resources[j].__class__.__name__ == 'Procedure':
            resProcedures.append(resources[j])

    procs = []
    procDates = []
    for j in range(len(resProcedures)):
        oneProc = Procedure.parse_obj(resProcedures[j])
        procs.append(oneProc.code.text)
        procDates.append(str(oneProc.performedPeriod.start.date()))  

    onePatProcs = pd.DataFrame()

    onePatProcs['ProcedureText'] = procs
    onePatProcs['ProcedureDates'] = procDates
    onePatProcs['PatientUID'] = onePatientID


    PROCEDURE = pd.concat([PROCEDURE, onePatProcs], ignore_index = True, axis=0)
    PROCEDURE.reset_index()
    
    # Find Encounter resources ########################################
    resEncounters = []
    for j in range(len(resources)):
        if resources[j].__class__.__name__ == 'Encounter':
            resEncounters.append(resources[j])

    encounters = []
    encountDates = []
    encountLocation = []
    encountProvider = []

    for j in range(len(resEncounters)):
        oneEncounter = Encounter.parse_obj(resEncounters[j])
        encounters.append(oneEncounter.type[0].text)
        encountLocation.append(oneEncounter.serviceProvider.display)
        if oneEncounter.participant:
            encountProvider.append(oneEncounter.participant[0].individual.display)
        else:
            encountProvider.append('None')
        encountDates.append(str(oneEncounter.period.start.date()))  

    onePatEncounters = pd.DataFrame()

    onePatEncounters['EncountersText'] = encounters
    onePatEncounters['EncounterLocation'] = encountLocation
    onePatEncounters['EncounterProvider'] = encountProvider
    onePatEncounters['EncounterDates'] = encountDates
    onePatEncounters['PatientUID'] = onePatientID
    
    ENCOUNTER = pd.concat([ENCOUNTER, onePatEncounters], ignore_index = True, axis=0)
    ENCOUNTER.reset_index()
    
    # Find Claim resources ########################################
    resClaims = []
    for j in range(len(resources)):
        if resources[j].__class__.__name__ == 'Claim':
            resClaims.append(resources[j])

    claimProvider = []
    claimInsurance = []
    claimDate = []
    claimType = []
    claimItem = []
    claimUSD = []

    for j in range(len(resClaims)):
        oneClaim = Claim.parse_obj(resClaims[j])
        # Inner loop over claim items:
        for i in range(len(resClaims[j].item)):
            claimProvider.append(oneClaim.provider.display)
            claimInsurance.append(oneClaim.insurance[0].coverage.display)
            claimDate.append(str(oneClaim.billablePeriod.start.date()))
            claimType.append(oneClaim.type.coding[0].code)
            claimItem.append(resClaims[j].item[i].productOrService.text)
            if resClaims[j].item[i].net:
                claimUSD.append(str(resClaims[j].item[i].net.value))
            else:
                claimUSD.append('None')

    onePatClaims = pd.DataFrame()

    onePatClaims['ClaimProvider'] = claimProvider
    onePatClaims['ClaimInsurance'] = claimInsurance
    onePatClaims['ClaimDate'] = claimDate
    onePatClaims['ClaimType'] = claimType
    onePatClaims['ClaimItem'] = claimItem
    onePatClaims['ClaimUSD'] = claimUSD
    onePatClaims['PatientUID'] = onePatientID
    
    CLAIM = pd.concat([CLAIM, onePatClaims], ignore_index = True, axis=0)
    CLAIM.reset_index()

    # Find Immunization resources ########################################
    resImmunization = []
    for j in range(len(resources)):
        if resources[j].__class__.__name__ == 'Immunization':
            resImmunization.append(resources[j])

    immun = []
    immunDates = []
    for j in range(len(resImmunization)):
        oneImmun = Immunization.parse_obj(resImmunization[j])
        immun.append(oneImmun.vaccineCode.coding[0].display)
        immunDates.append(str(oneImmun.occurrenceDateTime.date()))  

    onePatImmun = pd.DataFrame()

    onePatImmun['Immunization'] = immun
    onePatImmun['ImmunizationDates'] = immunDates
    onePatImmun['PatientUID'] = onePatientID
    
    IMMUNIZATION = pd.concat([IMMUNIZATION, onePatImmun], ignore_index = True, axis=0)
    IMMUNIZATION.reset_index()

PATIENT.to_csv('PATIENT.csv', index=False)
CONDITION.to_csv('CONDITION.csv', index=False)
OBSERVATION.to_csv('OBSERVATION.csv', index=False)
MEDICATION.to_csv('MEDICATION.csv', index=False)
PROCEDURE.to_csv('PROCEDURE.csv', index=False)
ENCOUNTER.to_csv('ENCOUNTER.csv', index=False)
CLAIM.to_csv('CLAIM.csv', index=False)
IMMUNIZATION.to_csv('IMMUNIZATION.csv', index=False)
