#!/usr/bin/python
# -*- coding: UTF-8 -*-

import xml.sax
tests_total=int(0)
errors_total=int(0)
failures_total=int(0)
class MovieHandler( xml.sax.ContentHandler ):
   def __init__(self):
      self.CurrentData = ""
      self.errors = ""
      self.failures = ""
      self.tests = ""
      self.rate = ""
      

   # 元素开始事件处理
   def startElement(self, tag, attributes):
      self.CurrentData = tag
      if tag == "testsuite":
		print "*****testsuite*****"
		self.errors = attributes["errors"]
		self.failures = attributes["failures"]
		self.tests = attributes["tests"]
		print "errors:", self.errors
		print "failures:", self.failures
		print "tests:", self.tests
		print "successful rate:",self.rate
		global tests_total
		global errors_total
		global failures_total
		tests_total+=int(self.tests)
		errors_total+=int(self.failures)
		failures_total+=int(self.errors)
def docTestResultDetials():
	fp = open('testResult.properties','w') 
	enter="\n"
	s=""
	lines = open('buildResult.txt').readlines()
	print("======")
	for l in lines:
		print(l)
		s+=l
	print("======")
	successful=int(tests_total)-int(failures_total)-int(errors_total)
	rate=round((float(tests_total)-float(failures_total))*100/float(tests_total),2)
	
	if errors_total==0 and failures_total==0:
		s+="finalTestResult=s"+enter
	else:
		s+="finalTestResult=f"+enter
	s+="failures="+str(failures_total)+enter
	s+="errors="+str(errors_total)+enter
	s+="tests="+str(tests_total)+enter
	s+="successful="+str(successful)+enter
	s+="successfulRate="+str(rate)+"%"+enter
	print(s)
	fp.write(s)
	fp.close()  # 关闭文件
def getTests_total():
	return tests_total
if ( __name__ == "__main__"):
   print getTests_total()
   
   # 创建一个 XMLReader
   parser = xml.sax.make_parser()
   # turn off namepsaces
   parser.setFeature(xml.sax.handler.feature_namespaces, 0)

   # 重写 ContextHandler
   Handler = MovieHandler()
   parser.setContentHandler( Handler )
   
   parser.parse("D:\\BTT_workspace\\BTTAutomation\\build\\report\\fvt\\TESTS-TestSuites.xml")
   print("===errors:"+Handler.errors)
   print("===failures:"+Handler.failures)
   docTestResultDetials()