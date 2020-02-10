# bash-script-date-and-time-playground

examples of working with formatted dates in bash including time operations such as adding time

see [`main.sh`](main.sh)

## Running

```sh
chmod a+x main.sh 
fswatch -o main.sh  | xargs -n1 -I{} sh main.sh
```