import time
from selenium import webdriver
 
driver = webdriver.Firefox(executable_path="/home/kali/Downloads/geckodriver")
driver.get("https://pointman.cloud/forget-password")

# 1. Find Textbox for Email 
emailElement = driver.find_element_by_id("email")
# 2. Type in skajiwara@prostarcorp.com
emailElement.send_keys('skajiwara@prostarcorp.com')
# 3. Submit
sendCodeButton = driver.find_element_by_class_name("MuiButtonBase-root")
sendCodeButton.click()


while True:
	time.sleep(111111)
	codeElement = driver.find_element_by_id("code")
	codeElement.send_keys('534678')
	paswdElement = driver.find_element_by_id("password")
	paswdElement.send_keys('Test12345678')
	submitElement = driver.find_element_by_class_name("MuiFormLabel-root")
	submitElement.click()
