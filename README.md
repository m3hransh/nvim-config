# Neovim

## Prerequisite

1. Install Neovim following [here](https://github.com/neovim/neovim/wiki/Installing-Neovim)
2. Install [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
3. Install [fnm](https://github.com/Schniz/fnm)

## Language Support

### Java

- Follow instruction on [jdtls](https://github.com/mfussenegger/nvim-jdtls)

#### Debugging

##### java-debug installation

- Clone [java-debug](https://github.com/microsoft/java-debug)
- Navigate into the cloned repository (`cd java-debug`)
- Run `./mvnw clean install`
- Set or extend the initializationOptions (= init_options of the config from configuration) as follows in file [./ftplugin/java.lua](./ftplugin/java.lua):

```lua
  config['init_options'] = {
      bundles = {
      vim.fn.glob("path/to/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-\*.jar", 1)
      };
  }
```

##### vscode-java-test installation

- Clone the [vscode-java-test](https://github.com/microsoft/vscode-java-test)
- Navigate into the folder (`cd vscode-java-test`)
- Run `npm install`
- Run `npm run build-plugin`
- Extend the bundles in the nvim-jdtls config:

```lua

-- This bundles definition is the same as in the previous section (java-debug installation)
local bundles = {
  vim.fn.glob("path/to/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1),
};

-- This is the new part
vim.list_extend(bundles, vim.split(vim.fn.glob("/path/to/microsoft/vscode-java-test/server/*.jar", 1), "\n"))
config['init_options'] = {
  bundles = bundles;
}
```

### Go

    1. Install Go [go.dev/doc/install](https://go.dev/doc/install)
    2. When you open up neovim use following command `:GoInstallBinaries` to install dependencies for `go.nvim` package

- Typescript
  1. Install [fnm](https://github.com/Schniz/fnm) for a fast and simple Node.js version manager, built in Rust
  2. Install following dependencies
     ```bash
         fnm install --lts # install latest long-term support node
         npm install -g typescript typescript-language-server eslint @fsouza/prettierd yarn vscode-languageserver
     ```

### Rust:

    1. Install rust and cargo [www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install)

- Lua:
  1. Install lua-language-server using these [instructions](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua)
  2. To support formatting on Buffer Write for lua files install the following package with cargo (or comment out BufWritePre \*.lua [autocommands.lua](.config/nvim/lua/user/autocommands.lua))
     ```bash
     cargo install stylua
     ```

## Get healthy

Open `nvim` and enter the following:

```

:checkhealth

```

You'll probably notice you don't have support for copy/paste also that python and node haven't been setup

So let's fix that

First we'll fix copy/paste

- On mac `pbcopy` should be builtin

- On Ubuntu

```

sudo apt install xsel

```

- On Arch Linux

```

sudo pacman -S xsel

```

Next we need to install python support (node is optional)

- Neovim python support

```

pip install pynvim

```

### Learning about Neovim

Each video will be associated with a branch so checkout the one you are interested in, you can follow along with this [playlist](https://www.youtube.com/watch?v=ctH-a-1eUME&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ).

> The computing scientist's main challenge is not to get confused by the complexities of his own making.

\- Edsger W. Dijkstra

```

```
