--- @module 'blink.cmp'
--- @class blink.cmp.Source
--- @field items lsp.CompletionItem[]
--- @field opts table
local source = {}

local function compute_items()
    return vim.tbl_map(
        function(entry)
            return vim.tbl_deep_extend("force", entry, {
                kind_name = 'Nerdfont',
                kind_icon = '',
                kind_hl = false,
                insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText
            })
        end,
        require('blink-cmp-nerdfont.glyphs')
    )
end

--- @param opts table
function source.new(opts)
    vim.validate('blink-cmp-nerdfont.opts.trigger', opts.trigger, { 'string' }, true)

    local self = setmetatable({}, { __index = source })

    self.opts = opts
    self.opts.trigger = self.opts.trigger or ':'
    self.items = compute_items()

    return self
end

function source:get_trigger_characters() return { self.opts.trigger } end

--- @param triggers string[]
--- @param line string
--- @param start_col number
local function get_matched_trigger(triggers, line, start_col)
    for _, trigger in ipairs(triggers) do
        local trigger_len = vim.fn.strcharlen(trigger)
        local prefix = line:sub(start_col - trigger_len, start_col - 1)

        if prefix == trigger then
            return trigger, trigger_len
        end
    end
end

--- @param context blink.cmp.Context
--- @param callback fun(response?: blink.cmp.CompletionResponse)
function source:get_completions(context, callback)
    local trigger, trigger_len = get_matched_trigger(
        self:get_trigger_characters(),
        context.line,
        context.bounds.start_col
    )

    if not trigger then
        callback({
            items = {},
            is_incomplete_backward = false,
            is_incomplete_forward = false
        })

        return function() end
    end

    local cursor_line = context.cursor[1] - 1

    local range = {
        start = {
            line = cursor_line,
            character = context.bounds.start_col - 1 - trigger_len,
        },
        ["end"] = {
            line = cursor_line,
            character = context.cursor[2],
        },
    }

    local items = vim.tbl_map(function(entry)
        return vim.tbl_deep_extend("force", entry, {
            textEdit = { range = range }
        })
    end, self.items)

    callback({
        items = items,
        is_incomplete_backward = true,
        is_incomplete_forward = true,
    })

    return function() end
end

--- @param item blink.cmp.CompletionItem
--- @param callback fun(resolved_item?: lsp.CompletionItem)
function source:resolve(item, callback)
    item = vim.deepcopy(item)

    item.textEdit.newText = item.insertText

    callback(item)
end

--- @param context blink.cmp.Context
--- @param item blink.cmp.CompletionItem
--- @param callback fun()
--- @param default_implementation fun()
--- @diagnostic disable-next-line: unused-local
function source:execute(context, item, callback, default_implementation)
    default_implementation()

    callback()
end

return source
