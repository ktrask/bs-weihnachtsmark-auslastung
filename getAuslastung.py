import requests
import re
import logging as log

orte = {
    'burgplatz': {'data-component-id': 'braunschweig-app-1'},
    'ruh':{'data-component-id': 'braunschweig-app-2'},
    'domplatz':{'data-component-id': 'braunschweig-app-3'},
    'rathaus':{'data-component-id': 'braunschweig-app-4'},
}

baseurl = "https://www.braunschweig.de/weihnachtsmarkt/auslastung-flaechen.php?sp:out=htmlFragment&component="

timestamps = []
auslastungen = []
for ort in orte:
    #print(orte[ort]['data-component-id'])
    url = baseurl+orte[ort]['data-component-id']
    #print(url)
    myres = requests.get(url)
    timestamp = re.sub(r".*last update: (....-..-.. ..:..:..) - .*",r"\1",str(myres.content))
    timestamps.append(timestamp)
    auslastung = re.sub(r".*Auslastung: ([\.,0-9]+).nbsp.%.*",r"\1",str(myres.content))
    re.sub(",",".",auslastung)
    try:
        float(auslastung)
    except Exception as e:
        log.warning(e)
        auslastung = ""
        # if the auslastung cannot be converted to a number, it is most likely an error like the string 'HTTP Exception' which means the values is not available
    auslastungen.append(auslastung)
result = f"{timestamps[0]},{auslastungen[0]}," +\
    f"{timestamps[1]},{auslastungen[1]}," +\
    f"{timestamps[2]},{auslastungen[2]}," +\
    f"{timestamps[3]},{auslastungen[3]}"

with open("auslastung.csv", "a") as fp:
    print(result, file=fp)
