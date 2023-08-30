local M = {}

M.check = function()
    vim.health.start("Configuration")
    local ok = true
    local extensions = vim.g.Templ_extensions
    if extensions ~= nil then
        if type(extensions) == "table" then
            for i, v in ipairs(extensions) do
                if type(v) ~= "string" then
                    ok = false
                    vim.health.error(string.format("g:Templ_extensions type error: entry %d has type %s", i, type(v)), {
                        "edit your configurations to make sure g:Templ_extensions is a list of strings",
                    })
                end
            end
            if not ok then
                vim.health.info("g:Templ_extensions is set to " .. vim.inspect(extensions))
            end
        else
            ok = false
            vim.health.error(
                "g:Templ_extensions type error", {
                    "edit your configurations to make sure g:Templ_extensions is a list of strings",
                })
        end
    end

    local dos = vim.g.Templ_disable_on_startup
    if dos ~= nil then
        if type(dos) ~= "bool" and type(dos) ~= "number" then
            ok = false
            vim.health.error("g:Templ_disable_on_startup must be a v:t_bool or a number", {"set g:Templ_disable_on_startup to v:true, v:false, 0, or 1"})
            vim.health.info("g:Templ_disable_on_startup is set to " .. vim.inspect(dos))
        end
    end

    local tt = vim.g.Templ_Tagger
    if tt ~= nil then
        if type(tt) ~= "bool" and type(tt) ~= "number" then
            ok = false
            vim.health.error("g:Templ_Tagger must be a v:t_bool or a number", {"set g:Templ_Tagger to v:true, v:false, 0, or 1"})
            vim.health.info("g:Templ_Tagger is set to " .. vim.inspect(dos))
        end
    end

    if ok then
        vim.health.ok("No issues found")
    end
end

return M
