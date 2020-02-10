# bash-script-date-and-time-playground

```sh
chmod a+x main.sh 
fswatch -o main.sh  | xargs -n1 -I{} sh main.sh
```