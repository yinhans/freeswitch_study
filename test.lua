-- 用于解析XML的函数
function parseargs_xml(s)
    local arg = {}
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
                         arg[w] = a
                      end)
    return arg
end

-- 将XML转换为lua表格。
function parse_xml(s)
    local stack = {};
    local top = {};
    table.insert(stack, top);
    local ni,c,label,xarg, empty;
    local i, j = 1, 1;
    while true do
       ni,j,c,label,xarg, empty = string.find(s, "<(%/?)(%w+)(.-)(%/?)>", i);
       if not ni then
      break
       end
       local text = string.sub(s, i, ni-1);
       if not string.find(text, "^%s*$") then
      table.insert(top, text);
       end
       if empty == "/" then
      table.insert(top, {label=label, xarg=parseargs_xml(xarg), empty=1});
       elseif c == "" then
      top = {label=label, xarg=parseargs_xml(xarg)};
      table.insert(stack, top);
       else
      local toclose = table.remove(stack);
      top = stack[#stack];
      if #stack < 1 then
         error("nothing to close with "..label);
      end
      if toclose.label ~= label then
         error("trying to close "..toclose.label.." with "..label);
      end
      table.insert(top, toclose);
       end
       i = j+1;
    end
    local text = string.sub(s, i);
    if not string.find(text, "^%s*$") then
       table.insert(stack[stack.n], text);
    end
    if #stack > 1 then
       error("unclosed "..stack[stack.n].label);
    end
    return stack[1];
 end
 
 -- 用于解析XML结果。
 function getResults(s) 
    local xml = parse_xml(s);
    local stack = {}
    local top = {}
    table.insert(stack, top)
    top = {grammar=xml[1].xarg.grammar, score=xml[1].xarg.score, text=xml[1][1][1]}
    table.insert(stack, top)
    return top;
 end


function onInput(s, type, obj)
    freeswitch.consoleLog("info", "Callback with type " .. type .. "\n");
    if (type == "dtmf") then
       freeswitch.consoleLog("info", "DTMF Digit: " .. obj.digit .. "\n");
    else if (type == "event") then
         local event = obj:getHeader("Speech-Type");
         if (event == "begin-speaking") then
             freeswitch.consoleLog("info", "\n" .. obj:serialize() .. "\n");
             -- 在begin-speaking事件上返回“break”以停止播放声音或TTS。
             return "break";
         end
         if (event == "detected-speech") then
             freeswitch.consoleLog("info", "\n" .. obj:serialize() .. "\n");
             if (obj:getBody()) then
                 -- 暂停语音检测（已自动处理，但为了安全起见，进行暂停处理）
                 session:execute("detect_speech", "pause");
                 -- 将事件的结果解析到结果表中以备后用。
                 results = getResults(obj:getBody());
             end
             return "break";
         end
       end
    end
 end


while (session:ready() == true) do 
    session:sleep(100);
    -- 这些人在找谁？
    session:streamFile("/usr/local/freeswitch/sounds/en/us/directory/directory-speak_name.wav");
    -- 这个延时块住，直到检测到语音事件。必须给你足够的时间来讲话并获取结果。
    session:sleep(3000);
    session:sleep(3000);
    -- 如果结果不为空并且我们在表格中有一个分机号。
    if (results.text ~= nil) then
       -- 让主叫方知道我们正在尝试。
       session:streamFile("/usr/local/freeswitch/sounds/en/us/directory/directory-please_hold.wav");
       -- 停止检测语音，否则它将继续触发语音事件并浪费资源。
       session:execute("detect_speech", "stop"); 
       -- 将通话转移到lua表之外的分机号。
       session:execute("transfer", extensions[results.text] .. " XML home");
    end
    -- 我们的地址簿中没有这些人。
    session:streamFile("/usr/local/freeswitch/sounds/en/us/directory/directory-not_found.wav");
    -- 清除任何结果，以防万一。
    results = {};
    -- 恢复检测语音。
    session:execute("detect_speech", "resume");
 end