from selenium import webdriver
from selenium.webdriver import ActionChains
import time

class Driver:
    def __init__(self, url):
        self.driver = None
        self.options = None
        self.initDriver(url)

    def __del__(self):
        self.driver.quit()

    def initDriver(self, url):
        self.setOptions()

        try:
            self.driver = webdriver.Chrome("./chromedriver", chrome_options=self.options)
            self.driver.implicitly_wait(3)
        except:
            print("크롬 드라이버 없음. ")
            exit()

        try:
            self.driver.get(url)
            time.sleep(3)
        except:
            print("url 가져오는데 문제 발생. ")
            exit()

        print("웹 크롤 준비 완료.")

    def setOptions(self):
        self.options = webdriver.ChromeOptions()
        self.options.add_argument('headless')
        self.options.headless = True
        self.options.add_argument('window-size=1920x1080')
        self.options.add_argument("disable-gpu")
        self.options.add_argument(
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15")
        self.options.add_argument("lang=ko_KR")

    def getDriver(self):
        return self.driver

    def setUrl(self, url):
        self.driver.get(url)
