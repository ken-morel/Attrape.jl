# Examples

To get them running I advice:

```sh
julia --project=. -O0 --compile=min --startup-file no <file>.jl
```

Less compilation time => less waiting on initial page open
but reactivity kinda slower
