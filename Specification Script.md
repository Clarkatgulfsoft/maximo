# Specification Script

2mTRLM]v 
```py
# SPECREQ.py - Automation Script for Specification Required Conditions 

from psdi.mbo import Mbo, MboRemote, MboSet, MboSetRemote
from psdi.common.condition import MaxCondition
from psdi.server import MXServer
from java.util import Arrays, List

# function to get the title of the specification attribute
def getAttributeTitle(spec):
    if(spec.getMboSet("ASSETATTRIBUTE").isEmpty()):
        return spec.getString("ASSETATTRID")
    return spec.getString("ASSETATTRIBUTE.DESCRIPTION")

# function to get the column name of the specification attribute: ALNVALUE, TABLEVALUE, NUMVALUE
def getAttributeName(spec):
    types = {"ALN": "ALNVALUE", "TABLE": "TABLEVALUE", "NUMERIC": "NUMVALUE"}
    if(spec.getMboSet("ASSETATTRIBUTE").isEmpty()):
        return None
    datatype = spec.getString("ASSETATTRIBUTE.DATATYPE")
    return types[datatype]

# function to check the required specification condition
# returns True when the required criteria is met but the attribute is blank 
def specRequired(cond, spec):
    if(cond.isNull("REQCONDITION")):
        return False
    conditionNum = cond.getString("REQCONDITION")
    condition = MXServer.getMXServer().getConditionCache().get(conditionNum)
    if(condition == None):
        return False
    conditionMbo = mbo if cond.getBoolean("REQISMAIN") else spec
    return condition.evaluate(conditionMbo, False) and (spec.isNull(getAttributeName(spec)) or spec.getString(getAttributeName(spec)) == "")

# main code: fetching the relevant specification record and processing the "specRequired" function 
# throws an error message with the list of the blank and required attribute titles if there is any
canSave = True
msgparams = ''

relationName = mboname + "SPECCLASS"
titles = {"WORKORDER": "Is Emri", "ASSET": "Demirbas", "LOCATION": "Konum", "ITEM": "Parca"}
title = titles[mboname] if mboname in ('WORKORDER', 'ASSET', 'LOCATION', 'ITEM') else ''

specSet = mbo.getMboSet(relationName)

if(not specSet.isEmpty()):
    cnt = specSet.count()p
    for i in range(cnt):
        spec = specSet.getMbo(i)
        if(spec.getMboSet("SPECCONDITION").isEmpty()):
            continue
        cond = spec.getMboSet("SPECCONDITION").getMbo(0)
        if(specRequired(cond, spec)):
            canSave = False 
            msgparams = msgparams + '\n' + getAttributeTitle(spec)

    if(not canSave):
        errorkey = 'requiredMsg'.
        errorgroup = 'errorMsg'
        params = [title, msgparams]
```

```py
# SPECVAL.py - Automation Script for Specification Validation Conditions 

from psdi.mbo import Mbo, MboRemote, MboSet, MboSetRemote
from psdi.common.condition import MaxCondition
from psdi.server import MXServer
from java.util import Arrays, List
from java.lang import System

# function to check the specification conditions for validation
# returns False when the validation criteria is not met 
def specValid(cond, spec):
    if(mbovalue is None):
        return True
    if(cond.isNull("VALCONDITION")):
        return True
    conditionNum = cond.getString("VALCONDITION")
    condition = MXServer.getMXServer().getConditionCache().get(conditionNum)
    if(condition == None):
        return True
    conditionMbo = mbo if cond.getBoolean("VALISMAIN") else spec
    return condition.evaluate(conditionMbo, False) 

# function to throw invalid error message
def throwError(cond):
    global errorkey, errorgroup
    if(cond.getMboSet("MAXMESSAGES").isEmpty()):
        errorkey = 'invalidMsg'
        errorgroup = 'errorMsg'
    else:
        errorkey = cond.getString("MAXMESSAGES.MSGKEY")
        errorgroup = cond.getString("MAXMESSAGES.MSGGROUP")

# main code: fetching the relevant specification record and processing the "specValid" function 
# throws an error message if the attribute value is invalid
if(not mbo.getMboSet("SPECCONDITION").isEmpty()):
    cond = mbo.getMboSet("SPECCONDITION").getMbo(0)
    if(not specValid(cond, mbo)):
        throwError(cond)
```

#scripts #toread