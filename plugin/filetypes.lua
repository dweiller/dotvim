vim.filetype.add({
    extension = {
        gcode = 'gcode',
        gco = 'gcode',
        g = 'gcode',
        csv = 'csv',
        fen = 'fen',
        wgsl = 'wgsl',
    },
    filename = {
        Tupfile = 'tup',
        ['Tuprules.tup'] = 'tup',
        TODO = 'markdown',
    },
})

vim.g.filetype_cls = 'tex'
