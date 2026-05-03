# blink-cmp-nerdfont

A [blink.cmp](https://github.com/Saghen/blink.cmp) completion source for [Nerd Font](https://www.nerdfonts.com/) glyphs.

## Requirements

- Neovim 0.10+
- [blink.cmp](https://github.com/Saghen/blink.cmp)
- A [Nerd Font](https://www.nerdfonts.com/) installed and configured in your terminal

## Installation

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'saghen/blink.cmp',
    dependencies = { 'timrydefalk/blink-cmp-nerdfont' },
    opts = {
        sources = {
            default = { 'nerdfont' },
            providers = {
                nerdfont = {
                    module = "blink-cmp-nerdfont",
                    name = "blink-cmp-nerdfont",
                    max_items = 10,
                    min_keyword_length = 1,
                    score_offset = 10,
                    opts = {
                        trigger = ":"
                    }
                },
            }
        }
    }
}
```

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `trigger` | `string` | `:` | Trigger string that activate the source |

```lua
opts = {
    trigger = ':'
}
```

## Usage

Type the trigger character (default `:`) followed by a part of the glyph name to search for a nerdfont glyph.

<img width="1349" height="1100" alt="nerdfont" src="https://github.com/user-attachments/assets/e4250734-8604-4804-b013-f512169fc3b7" />

