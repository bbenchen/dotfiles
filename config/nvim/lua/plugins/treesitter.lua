---@type LazySpec
return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        treesitter = {
            highlight = true, -- enable/disable treesitter based highlighting
            indent = true, -- enable/disable treesitter based indentation
            auto_install = true, -- enable/disable automatic installation of detected languages
            ensure_installed = {
                "bash",
                "c",
                "editorconfig",
                "desktop",
                "dockerfile",
                "git_config",
                "gitattributes",
                "gitignore",
                "java",
                "javascript",
                "json",
                "json5",
                "jsonnet",
                "lua",
                "markdown",
                "markdown_inline",
                "properties",
                "python",
                "toml",
                "typescript",
                "typespec",
                "vim",
                "yaml",
                "zsh",
            },
        },
    },
}
