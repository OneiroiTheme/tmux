## Installation

Compile and install:

1. Clone this repository

    ```bash
    git clone "{{repository.url}}" ./tmux
    cd ./tmux
    ```

2. Add this line to the bottom of `.tmux.conf`:

    ```bash
    run-shell /a/path/you/choose oneiroi.tmux
    ```

3. Reload Tmux by either restarting or reloading with:

    ```bash
    tmux source ~/.tmux.conf
    ```
