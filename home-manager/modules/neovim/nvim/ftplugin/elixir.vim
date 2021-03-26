lua <<EOF
require'lspconfig'.elixirls.setup{
    cmd = { "language_server.sh" };
}
EOF
