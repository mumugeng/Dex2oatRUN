DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
OPTIONALAPP_CONFIG="/data/adb/Dex2oatRUN/自选应用列表.prop"

#创建配置文件
mkdir /data/adb/Dex2oatRUN
touch $DEX2OAT_CONFIG
touch $OPTIONALAPP_CONFIG
touch /data/adb/Dex2oatRUN/删除编译内容（会闪退，不影响）.sh
cp $MODPATH/删除编译内容.sh /data/adb/Dex2oatRUN/删除编译内容（会闪退，不影响）.sh
oldid=$(getprop ro.system.build.id)
touch $MODPATH/old.id
echo $oldid > $MODPATH/old.id

#读取旧配置
system_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^系统应用=" | cut -f2 -d '=')
tripartite_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^三方应用=" | cut -f2 -d '=')
optional_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^自选应用=" | cut -f2 -d '=')
boot_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^开机运行=" | cut -f2 -d '=')
timing_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^定时运行=" | cut -f2 -d '=')
run_time=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^定时执行时间=" | cut -f2 -d '=')
Optionalapp=$(cat $OPTIONALAPP_CONFIG | grep -v '^#')
if [ "$system_app" = "" ]; then
	system_app="speed-profile"
fi
if [ "$tripartite_app" = "" ]; then
	tripartite_app="无"
fi
if [ "$optional_app" = "" ]; then
	optional_app="无"
fi
if [ "$boot_operation" = "" ]; then
	boot_operation="是"
fi
if [ "$timing_operation" = "" ]; then
	timing_operation="是"
fi
if [ "$run_time" = "" ]; then
	run_time="00 00"
fi

#写入配置
echo "#基础配置：
#可填：
#无、verify、quicken、space-profile、space、speed-profile、speed、everything
#越往后性能越好，占用空间越大。
系统应用=$system_app
三方应用=$tripartite_app
自选应用=$optional_app
#运行模式：
#填：是、否
开机运行=$boot_operation
定时运行=$timing_operation
#定时服务的执行时间，前面是分，后面是时，例如12点： 00 12 记得空格。
定时执行时间=$run_time
" > $DEX2OAT_CONFIG
echo "#自选列表（填包名，一行一个）：
$Optionalapp
" > $OPTIONALAPP_CONFIG

ui_print "- 模块会根据配置自动执行dex2oat。"
ui_print "- 配置及日志文件都在此文件夹下：/data/adb/Dex2oatBOOT"

