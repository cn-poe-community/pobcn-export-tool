# pobcn-export-tool

此项目是是国服pob的一个导出工具，需要把整个文件夹复制到国服pob\Tools里面

bun_extract_file.exe是https://github.com/zao/ooz/releases/ 里面的

通过以下命令可以从Content.ggpk里面提取文件
`bun_extract_file.exe extract-files <Content.ggpk路径> . <要提取的文件>`

像这样提取多个文件 

`bun_extract_file.exe extract-files C:\games\ggpk\Content.ggpk . "Data/Simplified Chinese/Stats.dat64" "Data/Simplified Chinese/StatSemantics.dat64" "Data/Simplified Chinese/VirtualStatContextFlags.dat64"`

