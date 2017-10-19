lines = open("git_logs/diff.txt",'r',encoding='UTF-8')
set = set()
for line in lines:
   list =line.split("/")
   if list.__len__()>1:
       component_name= line.split("/")[0]
       print(component_name)
       set.add(component_name)
lines.close()
c = open("../properties/defectComponent.properties",'w')
out=""
for s in set:
    out+=s+"\n"
c.write(out)
c.close()
