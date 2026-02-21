-- ROOT 文件预览插件
-- 用于在 Yazi 中预览 CERN ROOT 框架的 .root 文件
--
-- 实现标准的 Yazi 预览器接口

local M = {}

-- 缓存文件内容，避免重复执行 rootls
-- cache[file] = { lines = {...}, total = total_lines }
local cache = {}

-- 检查 rootls 是否可用
local function check_rootls()
    local handle = io.popen("which rootls 2>/dev/null && echo 'found' || echo 'not_found'")
    local result = handle:read("*a")
    handle:close()
    return result:match("found") ~= nil
end

-- 清理输出中的 ANSI 颜色代码
local function strip_ansi_codes(str)
    return str:gsub("\x1b%[[%d;]*m", "")
end

-- 预览 ROOT 文件内容
function M:peek(job)
    -- 检查依赖
    if not check_rootls() then
        ya.preview_widget(job, ui.Text.parse("Error: rootls command not found. Please install ROOT framework.\nSee: https://root.cern/install/"):area(job.area))
        return
    end

    -- 修复：将 Url 对象转换为字符串
    local file = tostring(job.file.url)

    -- 尝试从缓存读取
    local cached = cache[file]
    if not cached then
        -- 使用 Yazi 的 Command API 执行 rootls 命令
        local output, err = Command("rootls"):arg({ "-t", "-r", file }):output()

        if err then
            ya.err("ROOT preview plugin: failed to execute rootls - " .. tostring(err))
            ya.preview_widget(job, ui.Text.parse("Failed to preview ROOT file\n" .. tostring(err)):area(job.area):wrap(ui.Wrap.YES))
            return
        end

        -- 清理 ANSI 颜色代码以提高可读性
        local content = strip_ansi_codes(output.stdout)

        -- 预先分割成行并缓存
        local lines = {}
        for line in content:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        -- 缓存分割后的行数组
        cached = { lines = lines, total = #lines }
        cache[file] = cached
    end

    -- 处理分页和滚动
    local lines = {}
    local limit = job.area.h
    local start_line = job.skip + 1
    local end_line = math.min(job.skip + limit, cached.total)

    -- 如果滚动超出范围，发送 peek 事件调整位置
    if job.skip > 0 and end_line >= cached.total then
        ya.emit("peek", {
            math.max(0, cached.total - limit),
            only_if = job.file.url,
            upper_bound = true,
        })
        return
    end

    -- 直接从缓存中提取需要的行
    for i = start_line, end_line do
        table.insert(lines, cached.lines[i])
    end

    -- 显示分页后的内容
    ya.preview_widget(job, ui.Text.parse(table.concat(lines, "\n")):area(job.area):wrap(ui.Wrap.NO))
end

-- 处理预览滚动
function M:seek(job)
    local h = cx.active.current.hovered
    if h and h.url == job.file.url then
        ya.emit("peek", {
            math.max(0, cx.active.preview.skip + job.units),
            only_if = job.file.url,
        })
    end
end

-- 打开 ROOT 文件（使用 root browser）
function M:entry(job)
    -- 检查 rootbrowse 命令是否可用
    local handle = io.popen("which rootbrowse 2>/dev/null && echo 'found' || echo 'not_found'")
    local result = handle:read("*a")
    handle:close()

    if result:match("found") == nil then
        ya.notify({
            title = "ROOT Preview",
            content = "rootbrowse command not found. Please install ROOT framework.\nSee: https://root.cern/install/",
            level = "error",
            timeout = 5.0,
        })
        return
    end

    -- 隐藏 Yazi 界面
    local _ = ui.hide and ui.hide() or ya.hide()

    -- 使用 rootbrowse 打开文件
    local file = tostring(job.file.url)
    local child, err = Command("rootbrowse")
        :arg({ file })
        :stdin(Command.INHERIT)
        :stdout(Command.INHERIT)
        :stderr(Command.PIPED)
        :spawn()

    if not child then
        ya.notify({
            title = "ROOT Preview",
            content = "Failed to open ROOT file: " .. tostring(err),
            level = "error",
            timeout = 5.0,
        })
        return
    end

    -- 等待 rootbrowse 退出
    local output, err_code = child:wait_with_output()
    if err_code ~= nil then
        ya.notify({
            title = "ROOT Browser Error",
            content = "Exit code: " .. err_code,
            level = "error",
            timeout = 5.0,
        })
    end
end

-- 插件初始化
function M:setup(state, opts)
    -- 检查依赖
    if not check_rootls() then
        ya.err("ROOT preview plugin: rootls command not found. Please install ROOT framework.")
        ya.err("See: https://root.cern/install/")
        return false
    end

    -- 检查用户配置
    opts = opts or {}

    -- 成功初始化
    ya.info("ROOT preview plugin loaded successfully")
    return true
end

-- 插件元数据
M.metadata = {
    name = "root-preview",
    description = "Preview ROOT files using rootls command",
    version = "0.1.0",
    author = "chenxu",
    dependencies = { "rootls" },
}

return M
