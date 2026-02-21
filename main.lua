-- ROOT 文件预览插件
-- 用于在 Yazi 中预览 CERN ROOT 框架的 .root 文件
--
-- 实现标准的 Yazi 预览器接口

local M = {}

-- 缓存文件内容，避免重复执行 rootls
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
    if cache[file] then
        ya.preview_widget(job, ui.Text.parse(cache[file]):area(job.area):wrap(ui.Wrap.NO))
        return
    end

    -- 使用 Yazi 的 Command API 执行 rootls 命令
    local output, err = Command("rootls"):arg({ "-t", "-r", file }):output()

    if err then
        ya.err("ROOT preview plugin: failed to execute rootls - " .. tostring(err))
        ya.preview_widget(job, ui.Text.parse("Failed to preview ROOT file\n" .. tostring(err)):area(job.area):wrap(ui.Wrap.YES))
        return
    end

    -- 清理 ANSI 颜色代码以提高可读性
    local content = strip_ansi_codes(output.stdout)
    cache[file] = content

    -- 使用 ui.Text 显示内容
    ya.preview_widget(job, ui.Text.parse(content):area(job.area):wrap(ui.Wrap.NO))
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
