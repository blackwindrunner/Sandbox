import re

btt_all_component = open("../8210.txt")
component_name = 1

for component_name in btt_all_component.readlines():
    print(component_name)
    #component_name = btt_all_compoent.readline().strip()
    if (component_name != ''):
        try:
            print("name:"+component_name.strip()+"/component.properties")
            f = open("../../"+component_name.strip()+"/component.properties")             # 调用compoent.properties文件，来获取所依赖的jar文件
            output_file = open("../../"+component_name.strip()+'/DependencyComponents.properties', 'w') #将来把依赖的组件名都写入到这个文件中
            component_set = set()
            line = 1            # 调用文件的 readline()方法
            output=""
            while line:
                line = f.readline()
                if line.__contains__("classpath"):  #只关心文件中classpath部分的内容
                    print(line)
                    lines=re.split(r'[/;]',line[10:]) #去掉字符串里的classpath=，之后按照/;这两个字符进行切割
                    print(lines)
                    index = 0 #用来记录当前所循环的索引位置
                    for x in lines:
                        if x.__contains__("deliverables"): # 查找需要deliverables下jar文件的组件名称
                           for work_space_index in range(index,0,-1): # 循环查找deliverables之前...
                              if str(lines[work_space_index])=='${ENG_WORK_SPACE}': #...同时找到${ENG_WORK_SPACE}的位置...
                                    print(work_space_index+1)
                                    #output+=lines[work_space_index+1]+"\n" #...找到数组标记${ENG_WORK_SPACE}之后的位置，这个就是组件的名称，考虑到会有类似子目录的情况
                                    component_set.add(lines[work_space_index+1]) # 用法同上，只是用set可以去重
                                    break #一旦找到在deliverables之前，${ENG_WORK_SPACE}之后的组件名称后，跳出循环，查找下一个依赖的组件。
                        index += 1
            print(output)
            output="\n".join(tuple(component_set))
            output_file.write(output) #输出文件。
            output_file.close()
            f.close()
        except FileNotFoundError as err:
            print(err)
btt_all_component.close()