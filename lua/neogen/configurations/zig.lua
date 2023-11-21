local neogen = require('neogen')
local node_utils = require('neogen.utilities.nodes')
local extractors = require('neogen.utilities.extractors')
local i = require('neogen.types.template').item
local template = require('neogen.template')

function function_extractor(node)
    local tree = {
        {
            retrieve = "first",
            node_type = "ParamDeclList",
            subtree = {
                {
                    retrieve = "all",
                    node_type = "ParamDecl",
                    subtree = {
                        { retrieve = "first", node_type = "IDENTIFIER", extract = true }
                    },
                }
            }
        },
        { retrieve = "first", node_type = "ErrorUnionExpr", extract = true, as = "return_type" },
    }

    local nodes = node_utils:matching_nodes_from(node, tree)
    local res = extractors:extract_from_matched(nodes)

    local has_return_type = { true }
    if res.return_type and res.return_type[1] == "void"  then
        has_return_type = nil
    end

    return {
        [i.Parameter] = res.IDENTIFIER,
        [i.Return] = has_return_type,
        [i.HasReturn] = has_return_type,
        [i.HasParameter] = res.IDENTIFIER and { true },
    }
end

return {
    parent = {
        func = { "Decl" },
    },
    data = {
        func = {
            ["Decl"] = {
                ["1"] = {
                    match = "FnProto",
                    extract = function_extractor,
                }
            },
        },
    },
    template = template:config({ use_default_comment = true }):add_default_annotation("zigdoc"),
}
