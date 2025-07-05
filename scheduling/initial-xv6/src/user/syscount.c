#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/syscall.h"
#include "user/user.h"

char *syscall_names[] = {
    "fork", "exit", "wait", "pipe", "read", "kill", "exec", "fstat",
    "chdir", "dup", "getpid", "sbrk", "sleep", "uptime", "open", "write",
    "mknod", "unlink", "link", "mkdir", "close", "waitx", "getSysCount",
    "sigalarm", "sigreturn", "settickets"};

char *find_name(int mask)
{
    int ind = 0;
    while (mask > 1)
    {
        mask = mask >> 1;
        ind++;
    }

    return syscall_names[ind - 1];
}

int main(int argc, char *argv[])
{
    int mask = atoi(argv[1]);
    if (mask == 0)
    {
        printf("Invalid mask\n");
        exit(1);
    }

    int pid = fork();
    if (pid < 0)
    {
        printf("Fork failed\n");
        exit(1);
    }
    else if (pid == 0)
    {
        if (argc > 2)
        {
            exec(argv[2], &argv[2]);
            printf("Exec failed\n");
            exit(1);
        }
    }
    else
    {
        wait(0);
        int count = getsyscount(mask);
        printf("PID %d called %s %d times.\n", getpid(), find_name(mask), count);
    }

    return 0;
}
