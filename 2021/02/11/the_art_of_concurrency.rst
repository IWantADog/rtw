public: yes
tags: [concurrency]
summary: |
    《并发的艺术》读后记录。

The Art Of Concurrency
=========================

并发算法的设计模型
-------------------

任务分解:

什么是需要计算的任务以及如何定义他们？
        
    找出独立的任务，需要开发人员对原始代码有足够的了解。找出程序中可单独计算任务的难度与对代码的理解成都成反比。

    找出可并行的串行代码后，分解任务时需遵守两个原则

    1. 任务的数量最少应该等于线程（或是处理器核）的数量。
    2. 每个任务中的计算量（即粒度）必须足够大，以弥补在管理这些任务和线程时间时造成的开销。

任务之间存在那些依赖以及如何解决？

    顺序依赖与数据依赖。

如何将任务分配到线程？

    静态分配和动态分配。

    静态分配，任务的分配在任务开始时已经完成且无法修改。

    动态分配，通过共享容器（通常是一个队列）。“老板/工人”算法，通过一个线程单独接受任务，其他线程向该线程请求任务。“消费者/生产者”模型，生产者向容器中添加任务，消费者从容器中获取并处理任务。

    **静态分配相比动态分配更简单，带来的额外开销更小，开发是如果有可能尽可能使用静态分配。**


数据分解:

如何将数据分解为数据块？

    除了考虑任务分解中的两点之外。

    还需额外考虑数据块的形状。数据块的形状确定那些数据块是邻接的，以及数据块在计算过程中如何交换数据。

    作者建议 **努力将数据的体积和表面积的比值最大化。体积对应任务的粒度，表面积对应交换数据的数据块边界。**

如何确保每个处理数据块的任务能够在更新操作中访问到需要的数据?

1. 将临近数据复制到线程本地数据结构中。
2. 需要时才从临近的数据块获取数据。

如何将数据分配到各个线程？

    静态分配和动态分配。

并发模型评判要素:

1. **效率** 。效率意味着要分析为了保证代码正确执行而增加的计算开销，在不同的线程安排方式或任务组织模式下程序的好坏。
2. **简单性** 。对于通过修改串行代码得到并发代码来说，简单性将侧重于并发代码相对于串行代码所增加的代码量，以及最初的串行代码中有多少结构可以保持不变。
3. **可移植性** 。
4. **可伸缩性** 。可伸缩性是指，随着处理器核数量或者数据集规模的变化，给定的并发算法将表现出怎样的行为。

根据作者的观点，**可伸缩性是这四个要素中最重要的要素，效率则居第二位。**


算法的正确性证明与性能衡量
--------------------------

并发抽象的基本原则:

1. 程序有多条 **原子语句** 组成。原子语句指不能进一步分解为更小指令的语句，它在执行完成之前无法被中断。
2. 并发程序是两个或多个线程中原子语句的交替执行。
3. 假设某个线程的所有语句肯定会在某次交替执行中被运行。

通过对并发抽象前提的正确理解，才能合理地分析并发可能出现的情况验证并发模型的正确性。


形成死锁的是个必要条件:

1. **互斥** 。某个资源要么可用，要么每次被不超过一个线程持有。
2. **持有和等待** 。一个持有某些资源的线程试图获取其他一些资源。
3. **不可抢占** 。当一个线程持有某一资源时，只有当这个线程主动释放，否则其他线程无法获取该资源。
4. **循环等待** 。存在一个循环等待链，其中一些线程请求的资源由循环链上的下一个线程持有。

要想防止死锁问题的发生，必须打破这4个条件中的某一个。


性能测试:

加速比
    串行执行时间与并行执行时间的比值。例如加速比为2，表明在串行代码执行一遍的时间里，并行代码能够执行两遍。

Amdahl定律

    在某个项目并行化之前，预先估计能够实现的性能提升量。使用Amdahl定律时，需要知道可以并行化的代码量占总代码量的百分比，以及有多少代码必须串行执行。

    Speedup <= 1 / ((1 - pctPar) + pctPar/p))

    pctPar: 并行代码占执行时间的百分比
    p: 处理器核数

    缺点：未考虑实际情况中的一些因素，例如在实现并发带来的开销（通信、同步以及线程管理），并且不可能有无穷的处理器核可供使用。

    优点：简单。

Gustafson-Barsis定律（又称可伸缩加速比）:

    Amdahl定律用于预测将串行代码修改为并行代码时能够获得的加速比。Gustafson-Barsis定律则用于计算现有并行代码的加速比。

    Speedup <= p + (1 - p) * s

    p: 处理器核的数量。
    s: 给定的数据集和处理器核数量的情况下，并行程序中串行执行时间占总执行时间的百分比。

效率:

    **效率是与加速比相关的另一个衡量标准，效率可以告诉我们并发算法对系统中资源的利用程度。**

    效率的计算方法，**加速比除以处理器核数** ，然后将其结果用百分比表示。

    例如，如果在64核处理器核的情况下获得的加速比为53，那么效率就是82.8%。这意味着，从平均上来看，在执行过程中，每个处理器核的空闲时间为17%左右。

并行化能够有效利用多核处理器。但维持代码在并行下正常执行需要额外的时间消耗。为了进一步提升效率，必须适当减少额外消耗时间与任务执行时间之间的比例。一句话，减少额外的消耗即提升效率。


多线程程序设计中的8条简单规则
----------------------------------

1. 找出真正独立的运算。
2. 在尽可能高的层次上实现并发（更高层次=更大的粒度）。
3. 尽早考虑通过增加处理器核的数量来获得可伸缩性。
4. 尽可能使用线程安全的库。
5. 使用正确的多线程模型。
6. 永远不要假设程序会按照某种特定的顺序运行。
7. 尽可能使用线程局部存储或者特定数据相关的锁。（1、尽可能使用局部变量；2、尽可能减少锁的数量）

补充概念
-------------

可重入：函数可以在执行的任意时刻被中断，转入操作系统调度而执行另一段代码，并且返回的是否不会崩溃。

不可重入：一般使用了全局变量，如果被中断会出现错误。对于不可重入的函数需要额外互斥手段，保持代码正确运行。