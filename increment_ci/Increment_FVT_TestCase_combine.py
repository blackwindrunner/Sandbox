from xml_tool import CI_XML

defectComponent = open("../properties/defectComponent.properties")
defectDependCom = open("../properties/defectDependCom.properties")
# 缺陷和依赖组件名称集合
all_component_set = set()
# 合并缺陷和依赖组件名称
for component in defectComponent.readlines():
    all_component_set.add(component.strip())
for component in defectDependCom.readlines():
    all_component_set.add(component.strip())
defectComponent.close()
defectDependCom.close()
# 所有组件依赖fvt用例集合
all_fvtcase_set = set()
for s in all_component_set:
    if str(s).strip() != "":

        try:
            with open("../../" + s + "/DependencyFVTTestCase.properties") as component_fvt_testcases:
                for testcase in component_fvt_testcases.readlines():
                    if testcase.strip() != "": all_fvtcase_set.add(testcase.strip())
            print(s+":success")
        except FileNotFoundError as err:
            print(s+":"+str(err))


# 1. 读取xml文件
xml=CI_XML()
tree = xml.read_xml("../../BTTAutomation/increment_fvtcases_template.xml")

# A. 找到父节点
nodes = xml.find_nodes( tree, "target")
#print(nodes)
# B. 通过属性准确定位子节点
result_nodes = xml.get_node_by_keyvalue(nodes, {"name": "test"})
#print(result_nodes)
for fvtcase in all_fvtcase_set:
    a = xml.create_node( "case", {"id": fvtcase}, "")
    xml.add_child_node(result_nodes, a)

xml.write_xml(tree, "../../BTTAutomation/increment_fvtcases.xml")
