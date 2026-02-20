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

-- 异步预览 ROOT 文件内容
function M:peek(job)
    -- 检查依赖
    if not check_rootls() then
        ya.err("ROOT preview plugin: rootls command not found")
        return 1
    end

    local file = job.file.url
    local cmd = string.format("rootls -ctRr %q 2>&1", file)

    -- 尝试从缓存读取
    if cache[file] then
        job:absolute(cache[file])
        return 1
    end

    -- 异步执行 rootls 命令
    return ya.urlopen({
        cmd = { "sh", "-c", cmd },
    }, function(result)
        if result and result.stdout then
            -- 清理 ANSI 颜色代码以提高可读性
            local content = strip_ansi_codes(result.stdout)
            cache[file] = content
            job:absolute(content)
        else
            ya.err("ROOT preview plugin: failed to execute rootls")
            job:absolute("Failed to preview ROOT file")
        end
    end)
end

-- 处理预览滚动（可选实现）
function M:seek(job)
    -- 对于纯文本输出，seek 可以由 Yazi 默认处理
    -- 如果需要实现自定义滚动，可以在这里处理
    return 1
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
