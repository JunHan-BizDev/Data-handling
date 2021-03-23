import requests
import json

def getWeatherInfo():
    apikey = "91fd3b249433022eab80d8f01631fac2"
    cities = ["Seoul,KR", "Tokyo,JP", "New York,US"]

    api = "http://api.openweathermap.org/data/2.5/weather?q={city}&appid={key}"
    k2c = lambda k: k - 273.15

    for name in cities:
        url = api.format(city = name, key = apikey)

        r =requests.get(url)

        data = json.loads(r.text)

        print("+ city =", data["name"])
        print("| weather =", data["weather"][0]["description"])
        print("| min temp =", k2c(data["main"]["temp_min"]))
        print("| max temp =", k2c(data["main"]["temp_max"]))
        print("| humidity =", data["main"]["humidity"])
        print("| pressure =", data["main"]["pressure"])
        print("| DEG =", data["wind"]["deg"])
        print("| speed =", data["wind"]["speed"])
        print("")


def getWeatherInfo2():
    apikey = "91fd3b249433022eab80d8f01631fac2"
    USA_code = 840
    zip_code = {
        "Los Angeles" : 94040,
        "New York" : 10019,
        "Texas" : 77449
    }
    cityid = [1835848, 1838524]
    api = "http://api.openweathermap.org/data/2.5/weather?id={city_id}&appid={API_key}"

    print("weather condition for helicopter operation.")
    for code in cityid:
        url = api.format(city_id = code ,API_key = apikey)

        r =requests.get(url)

        jdata = json.loads(r.text)

        print("+city name : " + jdata['name'])
        print("|wind speed: " + str(jdata['wind']['speed']))
        print("|condition : " + jdata['weather'][0]['main'])
        try:
            print("rain in 1h: " + str(jdata['rain']['1h']))
            print("rain in 3h: " + str(jdata['rain']['3h']))
        except:
            continue


getWeatherInfo()
getWeatherInfo2()



