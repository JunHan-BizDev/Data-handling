import requests
from bs4 import BeautifulSoup
import urllib.request as req
import urllib.parse as parse
import time
import pandas as pd
import setdriver
from abc import *


class GetPage(metaclass=ABCMeta):
    @abstractmethod
    def processPage(self, driver):
        pass

    @abstractmethod
    def getSoup(self, url):
        pass

    @abstractmethod
    def getInfo(self, soup, driver):
        pass
    @abstractmethod
    def save(self):
        pass

class GetListPage(GetPage):

    def __init__(self, _driver, _url):
        self.driver = _driver
        self.url = _url
        self.soup = None
        self.index = 0
        self.item_list  = {
            "index" : [],
            "제품명" : [],
            "구매건수" : [],
            "가격" : [],
            "찜하기수" : [],
            "url" : []
        }

    def getSoup(self):
        self.url = self.driver.current_url

        # 현재 html을 반환
        current_html = self.driver.find_element_by_xpath("//html").get_attribute('outerHTML')
        self.soup = BeautifulSoup(current_html, 'html.parser')

    def getInfo(self):
        for k in range(1000):  
            print(f"{k+1}번째 페이지 크롤링중.. ")
            self.processPage()
            self.getSoup()

            cnt = len(self.soup.find_all('li', class_='basicList_item__2XT81'))

            for i in range(0, cnt):
                try:
                    metadata = self.soup.find_all('div', class_='basicList_title__3P9Q7')[i]
                    detail_info = self.soup.find_all('div', class_='basicList_etc_box__1Jzg6')[i]
                except:
                    switch = False
                    continue
                # 리뷰 개수
                try:
                    review_block = detail_info.a
                    num_review = review_block.em.text
                except:
                    pass

                # 구매건수
                try:
                    sales_block = review_block.next_sibling
                    num_sales = sales_block.em.text
                except:
                    sales_block = 0
                    num_sales = 0
                    continue  # 리뷰 건수 없을땐 그냥 진행

                # 찜하기 수
                like = detail_info.span.next_sibling.em.text

                # title
                title = metadata.a.get('title')

                # 가격
                price = self.soup.find_all('span', class_='price_num__2WUXn')[i].text

                # url
                url = metadata.a.get('href')

                self.index += 1

                self.item_list['index'].append(self.index)
                self.item_list['제품명'].append(title)
                self.item_list['구매건수'].append(num_sales)
                self.item_list['가격'].append(price)
                self.item_list['찜하기수'].append(like)
                self.item_list['url'].append(url)

            self.clickNext()

    def processPage(self):
        ''' 페이지 끝까지 스크롤 다운  '''
        SCROLL_PAUSE_SEC = 1

        # 스크롤 높이 가져옴
        last_height = self.driver.execute_script("return document.body.scrollHeight")
        while True:
            # 끝까지 스크롤 다운
            self.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

            # 1초 대기
            time.sleep(SCROLL_PAUSE_SEC)

            # 스크롤 다운 후 스크롤 높이 다시 가져옴
            new_height = self.driver.execute_script("return document.body.scrollHeight")
            if new_height == last_height:
                break
            last_height = new_height


    def clickNext(self):
        self.driver.find_element_by_xpath('//*[@id="__next"]/div/div[2]/div[2]/div[3]/div[1]/div[3]/a').click()
        self.driver.implicitly_wait(3)

    def save(self):
        try:
            df = pd.DataFrame().from_dict(self.item_list, orient='index').transpose()
        except:
            print("데이터프레임화 실패 ")
        try:
            df.to_csv('main_list.csv', index=True)
        except:
            print("csv파일 만들기 실패.. ㅠㅠ")

    def getItemList(self):
        return self.item_list

class GetDetailedPage(GetPage):
    def __init__(self, _driver):
        self.driver = _driver
        self.url = None
        self.soup = None
        self.index = 0
        self.reference = {
            "index" : [],
            "url" : []
        }
        self.item_list = {
            "index": [],
            "delivery_cost" : [],
            "num_review": [],
            "num_photo": [],
            "num_1month_review": [],
            "rebuy": [],
            "as_duratiion": [],
        }

    def getInfo(self):
        ''' retreive information '''

        proceed = self.processPage()

        if proceed:
            self.getSoup()

            # 데이터 수집

            # 배송비
            delivery_cost = self.soup.find('span', class_='Y-_Vd4O6dS').text
            # 평점
            rating = self.soup.find('div', class_="_2Q0vrZJNK1").next_sibling \
                         .find('strong', class_='_2pgHN-ntx6').text[0:-2]
            # 리뷰 수
            num_review = self.soup.find('strong', class_="_2pgHN-ntx6").text

            # 포토/동영상 리뷰 수
            num_photo_review = self.soup.find('em', class_="_2QV7qjUdl5")

            ''' Http 파라미터로 전달할 키 값을 받지 못해 크롤링 못한 애트리뷰트 '''
            # 한달 상품평 리뷰 수
            # 재구매율 리뷰 수
            # as기간

            #정보 저장

            self.item_list['index'].append(self.index)
            self.item_list['delivery_cost'].append(delivery_cost)
            self.item_list['rating'].append(rating)
            self.item_list['num_review'].append(num_review)
            self.item_list['num_photo'].append(num_photo_review)
            self.item_list['num_1month_review'].append("")
            self.item_list['rebuy'].append(False)
            self.item_list['as_duratiion'].append("")

        else:
            # 정보 빈칸 저장
            self.item_list['index'].append(self.index)
            self.item_list['delivery_cost'].append("")
            self.item_list['rating'].append("")
            self.item_list['num_review'].append("")
            self.item_list['num_photo'].append("")
            self.item_list['num_1month_review'].append("")
            self.item_list['rebuy'].append(False)
            self.item_list['as_duratiion'].append("")


        self.index += 1

    def processPage(self):
        ''' page load '''

        urn = self.reference['url'][self.index]

        # 스마트스토어 페이지만 진행
        if urn[8:18] != 'smartstore':
            return False
        else:
            self.url = urn
            self.changeUrl()
            return True

    def changeUrl(self):
        ''' change driver's url '''
        self.driver.get(self.url)
        self.driver.implicitly_wait(2)
        self.url = self.driver.current_url

    def getSoup(self, url):
        ''' get html & assign soup '''
        current_html = self.driver.find_element_by_xpath("//html").get_attribute('outerHTML')
        self.soup = BeautifulSoup(current_html, 'html.parser')

    def copyItemList(self,dict):
        ''' copy dictionary from main page dict '''
        self.reference = dict((key,value) for key, value in dict.iteritems()\
                              if (key == 'index' or key == 'url'))

    def save(self):
        try:
            df = pd.DataFrame().from_dict(self.item_list, orient='index').transpose()
        except:
            print("데이터프레임화 실패 ")
        try:
            df.to_csv('detail_list.csv', index=True)
        except:
            print("csv파일 만들기 실패.. ㅠㅠ")
