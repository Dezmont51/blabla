import time
import requests
from urllib.parse import quote
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

options = webdriver.ChromeOptions()
options.add_argument('headless')
driver = webdriver.Chrome(executable_path='C:/chromedriver.exe', chrome_options=options)  # Optional argument, if not specified will search path.
driver.get('https://zenmoney.ru/a/#');
time.sleep(2) # Let the user actually see something!
search_box = driver.find_element_by_id('proceedGoogle')
search_box.click()

#time.sleep(5) # Let the user actually see something!

time.sleep(2)
img = driver.find_element_by_xpath('//*[@id="identifierId"]')
img = driver.find_element_by_id('identifierId')
img.send_keys('', Keys.ENTER)
time.sleep(2)
img = driver.find_element_by_xpath('//*[@id="password"]/div[1]/div/div[1]/input')
img.send_keys('', Keys.ENTER)
time.sleep(5)
debths = driver.find_element_by_class_name('debths')
debthslist = debths.find_elements_by_xpath(".//*") 
dictdeb = {}
k = 0
for en,el in enumerate(debthslist):
	if el.text != "Я должен":
		if el.get_attribute("class") == "sum":
			dictdeb[debthslist[en+2].text] = el.text
	else:
		break
print(dictdeb)
r = requests.get('https://api.vk.com/method/messages.send?user_id=6694921&v=5.37&message='+quote(str(dictdeb))+'&access_token=48d2f83d5a329544fab41c0a49c438275621cb116847ce5686bb202caf81ee5116a54aa568c79cc30ee0d')
driver.save_screenshot('C:\OneScriptTest\Python\Парсер\Картинки.png')
driver.quit()
#//*[@id="balanceForm"]/div[21]/div[1]/span/span[2]
#//*[@id="balanceForm"]/div[21]


