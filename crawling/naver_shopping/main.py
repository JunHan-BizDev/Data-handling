from crawlPage import GetListPage
from crawlPage import GetDetailedPage
from setdriver import Driver



url = 'https://search.shopping.naver.com/' \
      'search/all?bt=0&frm=NVSHCHK&origQuery=의자&pagingIndex=1&pagingSize=40&' \
      'productSet=checkout&query=의자&sort=rel&timestamp=&viewType=list'

''' 셀레니움 드라이버 세팅 '''
driver_setting = Driver(url)
driver = driver_setting.getDriver()


''' 메인 페이지 크롤링 '''
crawl_main = GetListPage(driver, url)
try:
    crawl_main.getInfo()
except:
    print("메인페이지 크롤링 에러 발생. 저장 후 종료합니다.")

# main page csv 저장
crawl_main.save()

''' 세부 페이지 크롤링 '''

crawl_detail = GetDetailedPage(driver)

# 딕셔너리 정보 중, index와 url만 복사
crawl_detail.copyItemList(crawl_main.getItemList())

# 세부 페이지 크롤링
try:
    crawl_detail.getInfo()
except:
    print("세부페이지 크롤링 에러 발생. 저장 후 종료합니다.")

# main page csv 저장
crawl_detail.save()


