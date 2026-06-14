---
title: "Concurrency Patterns in Go: A Practical Guide"
description: "A deep dive into goroutines, channels, and the patterns that make Go concurrency click — with real-world examples."
date: 2024-03-15
lastmod: 2024-03-15
categories:
    - Tech
tags:
    - Go
    - Concurrency
    - Backend
image: cover.jpg
---

Go's concurrency model is one of the language's biggest selling points, but it's easy to
misuse. This post walks through the patterns I reach for most often in production systems.

## The mental model: CSP

Go is built on **Communicating Sequential Processes** (CSP). The key idea:

> *Don't communicate by sharing memory; share memory by communicating.*

This flips the typical threading model on its head. Instead of locking shared state,
you pass ownership of data through channels.

## Pattern 1 — Fan-out / Fan-in

Fan-out distributes work across multiple goroutines. Fan-in collects results back into
a single channel.

```go
func fanOut(jobs <-chan Job, workers int) []<-chan Result {
    channels := make([]<-chan Result, workers)
    for i := range workers {
        channels[i] = process(jobs)
    }
    return channels
}

func fanIn(channels ...<-chan Result) <-chan Result {
    merged := make(chan Result)
    var wg sync.WaitGroup

    collect := func(c <-chan Result) {
        defer wg.Done()
        for r := range c {
            merged <- r
        }
    }

    wg.Add(len(channels))
    for _, c := range channels {
        go collect(c)
    }

    go func() {
        wg.Wait()
        close(merged)
    }()

    return merged
}
```

## Pattern 2 — Worker pool

A bounded pool prevents goroutine explosion when the workload is unpredictable.

```go
func workerPool(jobs <-chan Job, results chan<- Result, n int) {
    var wg sync.WaitGroup
    wg.Add(n)
    for range n {
        go func() {
            defer wg.Done()
            for job := range jobs {
                results <- process(job)
            }
        }()
    }
    go func() {
        wg.Wait()
        close(results)
    }()
}
```

**Rule of thumb:** set pool size to `runtime.NumCPU()` for CPU-bound work;
for I/O-bound work you can go higher — profile first.

## Pattern 3 — Cancellation via context

Always propagate `context.Context` for long-running operations so callers can cancel.

```go
func fetch(ctx context.Context, url string) ([]byte, error) {
    req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
    if err != nil {
        return nil, err
    }
    resp, err := http.DefaultClient.Do(req)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()
    return io.ReadAll(resp.Body)
}
```

## Common mistakes

- **Goroutine leaks** — always ensure goroutines can exit. If a goroutine blocks on a
  channel send and the receiver is gone, it leaks forever.
- **Closing a channel from the receiver** — only the sender should close a channel.
  Closing from the receiver races with ongoing sends.
- **Shared mutable state without sync** — channels are great but sometimes a `sync.Mutex`
  is cleaner. Don't over-channel.

## Takeaway

Go concurrency isn't magic — it's disciplined. Pick the simplest pattern that fits the
problem, pass context everywhere, and profile before adding more workers.

Happy shipping. 🚀
