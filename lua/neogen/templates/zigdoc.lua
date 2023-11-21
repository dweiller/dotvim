local i = require("neogen.types.template").item

return {
    { nil, "/ $1", { no_results = true } },
    { nil, "/ $1" },
    { i.HasParameter, "/", },
    { i.Parameter, "/ @param %s $1" },
    { i.HasReturn, "/" },
    { i.Return, "/ Returns $1" },
}
