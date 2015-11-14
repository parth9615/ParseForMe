import json,httplib,urllib
connection = httplib.HTTPSConnection('api.parse.com', 443)
params = urllib.urlencode({"where":json.dumps({
       "username": "flerp@flerp.com"
     })})
print params
connection.connect()
connection.request('GET', '/1/classes/Events?%s' % params, '', {
       "X-Parse-Application-Id": "D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT",
       "X-Parse-REST-API-Key": "exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF"
     })
result = json.loads(connection.getresponse().read())
print result
