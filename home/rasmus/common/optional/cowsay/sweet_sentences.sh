#!/bin/bash

# echo (ls $COWPATH*.cow | shuf -n 1)

(
shuf -n 1 << EOF 
Remember to ask about my day!
I luvvve u
Hello beautiful
Min elskede Rasmus
Hej rapanden Rasmus
Hvad så prutskid
Davs med dig
Hellllllllllllllo
Wha saaaa
Husk ikke at gå for sent i seng
Ostemanden rasmus
I chose you
EOF
) | cowsay -f $(ls $COWPATH/*.cow | shuf -n 1) | lolcat
# echo $COW_DRAW
