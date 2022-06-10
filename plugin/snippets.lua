local ls = require 'luasnip'
local types = require('luasnip.util.types')

local snippet = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require('luasnip.extras').lambda
local dl = require('luasnip.extras').dynamic_lambda

ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	update_events = "TextChanged,TextChangedI",
	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	-- luasnip uses this function to get the currently active filetype. This
	-- is the (rather uninteresting) default, but it's possible to use
	-- eg. treesitter for getting the current filetype by setting ft_func to
	-- require("luasnip.extras.filetype_functions").from_cursor (requires
	-- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
	-- the current filetype in eg. a markdown-code block or `vim.cmd()`.
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,

})

local function wrap(val)
    if type(val) == 'string' then
        return { t {val}, i(0) }
    end
    if type(val) == 'table' then
        for k, v in ipairs(val) do
            if type(v) == 'string' then
                val[k] = t { v }
            end
        end
    end
    return val
end

local function make(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        local opts = {}
        opts.trig = k
        if type(v) == 'table' then
            for opt, o_val in pairs(v) do
                if type(opt) == 'string' then
                    opts[opt] = o_val
                end
            end
        end
        table.insert(result, snippet(opts, wrap(v)))
    end
    return result
end

local snippets = {}

local function rec_ls(args, parent, old_state, snip)
    return sn(nil, {
        c(1, {
            -- important!! Having the sn(...) as the first choice will cause infinite recursion.
            t({""}),
            -- The same dynamicNode as in the snippet (also note: self reference).
            sn(nil, {snip, d(2, rec_ls, {snip})}),
        }),
    })
end

snippets.zig = make {
    import = {
        dscr = 'import file',
        'const ',
        i(1),
        ' = @import("',
        dl(2, l._1, 1),
        '.zig");',
        i(0),
    },
    importm = {
        dscr = 'import member field',
        'const ',
        i(1),
        ' = @import("',
        i(2, 'FILE'),
        '.zig").',
        dl(3, l._1, 1),
        ';',
        i(0),
    },
    importp = {
        dscr = 'import package',
        'const ',
        i(1),
        ' = @import("',
        dl(2, l._1, 1),
        '");',
        i(0),
    },
    impstd = {
        dscr = 'import std',
        'const std = @import("std");',
    },
    test = {
        dscr = 'test declaration',
        'test ',
        c(1, {
            sn(nil, { t'"', i(1, 'TEST NAME'), t'" ' }),
            t'',
        }),
        t {'{', '\t'},
        i(2, 'return error.SkipZigTest;'),
        t {'', '}'},
    },
    ["while"] = {
        dscr = 'while loop',
        'while (',
        i(1, 'TEST'),
        ') ',
        c(2, {
            sn(nil, { t'|', i(1, 'CAPTURE'), t'| ' }),
            t'',
        }),
        c(3, {
            sn(nil, { t': (', i(1, 'CONTINUE'), t') ' }),
            t'',
        }),
        t {'{', '\t'},
        i(4),
        t {'', '}'},
    },
    fn = {
        dscr = 'function definition',
        'fn ',
        i(1, 'funcName'),
        '(',
        i(2, 'param'),
        ': ',
        i(3, 'Type'),
        d(4, rec_ls, { sn(1, { t', ', i(1, 'param'), t': ', i(2, 'Type') }) }),
        ') ',
        i(5, 'Type'),
        t{' {', '\t'},
        i(6),
        t{'', '}'},
    },
    itw = {
        dscr = 'iter while pattern',
        t{ '{', '\t' },
        'var iter = ',
        i(1, 'ITERATOR'),
        t{';', '\t'},
        t'while (iter.',
        i(2, 'next()'),
        ') |',
        i(3, 'CAPTURE'),
        '| ',
        c(4, {
            sn(nil, { t': (', i(1, 'CONTINUE'), t') ' }),
            t'',
        }),
        t {'{', '\t\t'},
        i(5),
        t {'', '\t}', '}'},
    },
}

local function envSnip(envtype, default)
    return {
        t {'\\begin{' .. envtype .. '}', '\t'},
        i(1, default),
        t { '', '\\end{' .. envtype .. '}', '' }
    }
end

local function labelledEnvSnip(env, label_prefix)
    label_prefix = label_prefix or env
    return {
        '\\begin{' .. env .. '}\\label{' .. label_prefix .. ':',
        i(1, 'LABEL'),
        t {'}', '\t'},
        i(2),
        t { '', '\\end{' .. env .. '}', ''},
    }
end

local function lowerNoSpace(args)
    args[1][1]:gsub(' ', '-'):lower()
end

local function secSnip(sectype)
    return {
        '\\' .. sectype .. '{',
        i(1, sectype:upper() .. 'NAME'),
        '}\\label{sec:',
        dl(2, l._1:gsub(' +', '-'):lower(), 1),
        t { '}', '' },
    }
end

local function thmSnip(thmtype)
    return {
        '\\begin{' .. thmtype .. '}\\label{' .. thmtype .. ':',
        i(1, 'LABEL'),
        t({'}', '\t'}),
        i(2),
        t({'', '\t\\begin{proof}', ''}),
        i(3, '\t\t\\sorry'),
        t({'', '\t\\end{proof}', '', '\\end{' .. thmtype .. '}', ''}),
    }
end

local function enumSnip(enumtype)
    return {
        t { '\\begin{' .. enumtype .. '}', '\t\\item ' },
        i(1),
        t { '', '\\end{' .. enumtype .. '}', '' }
    }
end

snippets.tex = make {
    begin = {
        '\\begin{',
        i(1, 'ENV'),
        t {'}', ''},
        i(2),
        t {'', '\\end{'},
        l(l._1, 1),
        t {'}', ''},
    },
    lem = thmSnip('lem'),
    thm = thmSnip('thm'),
    prop = thmSnip('prop'),
    proof = envSnip('proof', '\\sorry'),
    rem = labelledEnvSnip('remark', 'rem'),
    cor = labelledEnvSnip('cor'),
    defn = labelledEnvSnip('defn', 'def'),
    conj = labelledEnvSnip('conj'),
    eq = labelledEnvSnip('equation', 'eq'),
    align = labelledEnvSnip('align', 'eq'),
    ['eq*'] = envSnip('eq*'),
    ['align*'] = envSnip('align*'),
    sec = secSnip('section'),
    sub = secSnip('subsection'),
    ssub = secSnip('subsubsection'),
    fig = {
        t { '\\begin{figure}', '\t\\centering', '\t' },
        i(3),
        t { '', '\t\\caption{' },
        i(2, 'CAPTION'),
        t { '}', '\t\\label{fig:' },
        i(1, 'LABEL'),
        t { '}', '\\end{figure}' },
    },
    subfig = {
        '\\begin{subfigure}{',
        i(4, '0.45\\textwidth}'),
        t { '', '\t\\centering', '\t' },
        i(3),
        t { '', '\t\\caption{' },
        i(2, 'CAPTION'),
        t { '}', '\t\\label{fig:' },
        i(1, 'LABEL'),
        t { '}', '\\end{subfigure}' },
    },
    item = enumSnip('itemize'),
    enum = enumSnip('enumerate'),
}

local function kvpair(idx, name)
    return sn(idx, {
        t { '\t' .. name .. ' = "' },
        i(1, name:upper()),
        t { '",', '' },
    })
end
snippets.bib = make {
    article = {
        '@article{',
        i(1, 'name'),
        t {',' ,'' },
        kvpair(2, 'author'),
        kvpair(3, 'journal'),
        kvpair(4, 'title'),
        kvpair(5, 'year'),
        kvpair(6, 'valume'),
        kvpair(7, 'number'),
        kvpair(8, 'pages'),
        '\thowpublished = "\\url{', i(9, 'howpub'), t { '}",', '}', '' },
    },
    book = {
        '@book{',
        i(1, 'name'),
        t {',', ''},
        kvpair(2, 'author'),
        kvpair(2, 'title'),
        kvpair(2, 'year'),
        kvpair(2, 'publisher'),
        t { '}', '' },
    }
}

for ft, snippets in pairs(snippets) do
    ls.add_snippets(ft, snippets)
end
