JobQueue
======

[![Swift][swift-badge]][swift-url]
[![Platform][platform-badge]][platform-url]
[![License][mit-badge]][mit-url]
[![Slack][slack-badge]][slack-url]

##Usage


```
public class BasicWorker : Worker {
    public func perform(job: Job) throws {
        try job.execute()
    }
}

public class ExampleJob : Job {
    public func execute() throws {
        print("Hello Zewo")
    }
}


var workers = [BasicWorker]()
workers.append(BasicWorker())

let pool = WorkerPool<BasicWorker>(with: workers)


var jobQueue = [Job]()

for _ in 0...10 {
    jobQueue.enqueue(ExampleJob())
}


do {
    while true {
        let job = try jobQueue.dequeue()
        
        try pool.with { (worker) in
            try worker.perform(job)
        }
    }
}
catch {}
```


## Community

[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](https://zewo-slackin.herokuapp.com)

Join us on [Slack](https://zewo-slackin.herokuapp.com).

License
-------

**JobQueue** is released under the MIT license. See LICENSE for details.

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org
[platform-badge]: https://img.shields.io/badge/Platform-Mac%20%26%20Linux-lightgray.svg?style=flat
[platform-url]: https://swift.org
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
[slack-image]: http://s13.postimg.org/ybwy92ktf/Slack.png
[slack-badge]: https://zewo-slackin.herokuapp.com/badge.svg
[slack-url]: http://slack.zewo.io
