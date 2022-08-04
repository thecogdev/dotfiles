#! /bin/bash
if ! hash curl 2> /dev/null 
then
    sudo apt update
    sudo apt install curl
fi

if ! hash rustup 2> /dev/null 
then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "rust installed"
fi

if ! hash rust-analyzer 2> /dev/null 
then
    curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.cargo/bin/rust-analyzer
    chmod +x ~/.cargo/bin/rust-analyzer
else
    echo "rust-analyzer installed"
fi
