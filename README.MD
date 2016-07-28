 半同步 / 半异步进程池实现


这里我们实现一个基于高效的半同步 / 半异步并发模式的进程池。
为了避免父、子进程之间传递文件描述符，我们将接受新连接的操作放到子进程中。
很显然，对于这种模式而言，一个客户连接上的所有任务始终由一个子进程来处理。
代码清单见processpool.h

主线程只管理监听 socket ，连接 socket 由工作线程来管理。
当有新的连接到来时，主线程就接受之并将新返回的连接 socket 派发给某个工作线程，
此后该新 socket 上的任何 I/O 操作都被选中的工作线程处理，直到客户关闭连接。
主线程向工作线程派发 socket 的最简单的方式，是往它和工作线程之间的管道里写数据。
工作线程检测到管道上有数据可读时，就分析是否是一个新的客户连接请求到来，如果是，
则把该新的 socket 上的读写事件注册到自己的 epoll 内核事件表中。

每个进程都维持自己的时间循环，他们各自独立地监听不同的时间。
因此，在这种高效的半同步 / 半异步模式中，每个进程都工作在异步模式，
所有它并非严格意义上的半同步 / 半异步模式。 

 然后利用建立的进程池，实现了一个 CGI 服务器。代码清单见processpool.cpp