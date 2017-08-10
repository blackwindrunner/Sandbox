#!/usr/bin/python
# -*- coding: UTF-8 -*-

import xml.sax

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
		
def docTestResultDetials(errors,failures,tests):
	fp = open('testResult.properties','w') 
	enter="\n"
	s=""
	lines = open('buildResult.txt').readlines()
	print("======")
	for l in lines:
		print(l)
		s+=l
	print("======")
	successful=int(tests)-int(failures)-int(errors)
	rate=round((float(tests)-float(failures))*100/float(tests),2)
	if errors=="0" and failures=="0":
		s+="finalTestResult=s"+enter
	else:
		s+="finalTestResult=f"+enter
	s+="failures="+failures+enter
	s+="errors="+errors+enter
	s+="tests="+tests+enter
	s+="successful="+str(successful)+enter
	s+="successfulRate="+str(rate)+"%"+enter
	print(s)
	fp.write(s)
	fp.close()  # 关闭文件
if ( __name__ == "__main__"):
   
   
   # 创建一个 XMLReader
   parser = xml.sax.make_parser()
   # turn off namepsaces
   parser.setFeature(xml.sax.handler.feature_namespaces, 0)

   # 重写 ContextHandler
   Handler = MovieHandler()
   parser.setContentHandler( Handler )
   
   parser.parse("D:\\defect8204\\BTTAutomation\\build\\report\\fvt\\TESTS-TestSuites.xml")
   print("==="+Handler.errors)
   docTestResultDetials(Handler.errors,Handler.failures,Handler.tests)