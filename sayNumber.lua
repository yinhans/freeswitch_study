--[[
具体流程说明

通过cc_member_session_uuid获取呼叫者的UUID
通过cc_agent获取坐席号码（即前面设定的8100）
通过session:ready()判断是否准备好，可接收媒体了
通过执行uuid_broadcast播放工号
修改完成后，重新加载配置，并把脚本保存到script目录下，呼叫‘1234’电话就被路由到1000话机上，接听后呼叫方就会听到工号播报了。工号播报部分日志如下：
]]

session:setAutoHangeup(false)

local opUid = session:getVariable("cc_member_session_uuid")
local theAgent = session:getVariable("cc_agent")

session:consoleLog("NOTICE","The incoming call:" .. theAgent .. "" .. opUid)

local waitMax = 10
while session:ready()==false and waitMax>0 do
    waitMax = waitMax - 1
    session:sleep(1000)
end

local fsApi = freeswitch.API()
fsApi:execute("uuid_broadcast", opUuid .. " " .. "say::en\\snumber\\siterated\\s" .. theAgent)

