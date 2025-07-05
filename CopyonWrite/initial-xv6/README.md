# xv6

## part-2: Copy-On-Write(COW) performance analysis

### 2.Copy-on-Write (COW) in fork() 
#### improves efficiency and conserves memory by not duplicating a process's memory until it is actually modified. When a process calls fork(), rather than immediately duplicating the entire memory of the parent process, both the parent and child processes initially share the same memory pages. Only if one of the processes attempts to modify a shared page does the operating system create a copy of that specific page thus helps in memory conservation.

### Further optimization
#### COW now works at level of memory pages but not all process change complete page so by optimizing the granularity of memory sharing (e.g., at the level of smaller regions of memory), COW could reduce unnecessary copying and improve performance.But it is tough to implement