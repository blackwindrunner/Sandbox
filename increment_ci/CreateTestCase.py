"""
CHAOPContext
ExpressionCase
DeepMapper


ExpressionCase

DependencyFVTTestCase.properties

"""

core = open("BTTCore/DependencyFVTTestCase.properties","w")
core.write("CHAOPContext\nExpressionCase\nDeepMapper")
channel = open("BTTChannels/DependencyFVTTestCase.properties","w")
channel.write("AparJR35290JR35228\nExpressionCase")
BTTLicense = open("BTTLicense/DependencyFVTTestCase.properties","w")
BTTLicense.write("ExpressionCase\nDataCloneTest")
BTTRuleProviderService = open("BTTRuleProviderService/DependencyFVTTestCase.properties","w")
BTTRuleProviderService.write("ICollEleReNameTest\nDataCloneTest")
