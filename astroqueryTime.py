from astroquery.gaia import Gaia
import csv
import json
import math
queryBlueprint ='''SELECT TOP 6000 gaia_source.source_id,gaia_source.ra,gaia_source.dec,gaia_source.phot_g_mean_mag,gaia_source.distance_gspphot
FROM gaiadr3.gaia_source 
WHERE 
CONTAINS(
	POINT('ICRS',gaiadr3.gaia_source.ra,gaiadr3.gaia_source.dec),
	CIRCLE('ICRS',{0},{1},90)
)=1  AND  (gaiadr3.gaia_source.distance_gspphot>=1 AND gaiadr3.gaia_source.phot_g_mean_mag<=7)
'''
jsonBase = {}
jsonBase['exoplanets'] = {}
exoplanetCount = -1
meta = Gaia.load_table('gaiadr3.gaia_source')
data = []

with open('/home/flipflopnoob/Documents/exoplanets.csv', newline = '') as exofile:
    exoread = csv.reader(exofile, delimiter = ',', quotechar = '|')
    for row in exoread:
        if(exoplanetCount == -1):
            exoplanetCount += 1
            continue
        starCount = 0

        raRad = float(row[5]) * (math.pi/180.0)
        decRad = float(row[6]) * (math.pi/180.0)
        jsonBase['exoplanets'][exoplanetCount] = {}
        jsonBase['exoplanets'][exoplanetCount]['name'] = str(row[0])
        jsonBase['exoplanets'][exoplanetCount]['discovery'] = str(row[4])
        jsonBase['exoplanets'][exoplanetCount]['date'] = str(row[2])
        jsonBase['exoplanets'][exoplanetCount]['ra'] = str(row[5])
        jsonBase['exoplanets'][exoplanetCount]['dec'] = str(row[6])
        jsonBase['exoplanets'][exoplanetCount]['dist'] = str(row[7])
        
        try:
            jsonBase['exoplanets'][exoplanetCount]['x'] = str(float(row[7]) * math.cos(decRad) * math.cos(raRad))
            jsonBase['exoplanets'][exoplanetCount]['y'] = str(float(row[7]) * math.cos(decRad) * math.sin(raRad))
            jsonBase['exoplanets'][exoplanetCount]['z'] = str(float(row[7]) * math.sin(decRad))
        except:
            jsonBase['exoplanets'][exoplanetCount] = {}
            continue  
        
        

        job = Gaia.launch_job(queryBlueprint.format(row[5], row[6]))
        results = job.get_results()
        jsonBase['exoplanets'][exoplanetCount]['stars'] = {}
        for i in range(len(results)):
            raRad = results[i][1] * (math.pi/180)
            decRad = results[i][2] * (math.pi/180)

            jsonBase['exoplanets'][exoplanetCount]['stars'][i] = {}
            jsonBase['exoplanets'][exoplanetCount]['stars'][i]['x'] = str(results[i][4] * math.cos(decRad) * math.cos(raRad))
            jsonBase['exoplanets'][exoplanetCount]['stars'][i]['y'] = str(results[i][4] * math.cos(decRad) * math.sin(raRad))
            jsonBase['exoplanets'][exoplanetCount]['stars'][i]['z'] = str(results[i][4] * math.sin(decRad))
            jsonBase['exoplanets'][exoplanetCount]['stars'][i]['mag'] = str(results[i][3])
            jsonBase['exoplanets'][exoplanetCount]['stars'][i]['dist'] = str(results[i][4])
        exoplanetCount += 1
        print(exoplanetCount)
        if(exoplanetCount % 10 == 0):
            with open('/home/flipflopnoob/Documents/unmatchedpowerofthesuns.json', 'w') as fp:
                pass
            with open('/home/flipflopnoob/Documents/unmatchedpowerofthesuns.json', 'a+') as outfile:
                data.append(jsonBase)
                json.dump(data, outfile)
                jsonBase = {}
                jsonBase['exoplanets'] = {}

